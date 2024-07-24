import { picker } from '@kit.CoreFileKit'
import { promptAction } from '@kit.ArkUI'
import fs from '@ohos.file.fs';
@Entry
@Component
struct Index {
  @State isShow :boolean=false
@Builder  mySideBar(){
  Column(){
    Text('我是侧边栏组件')
  }
  .borderRadius(50)
  .backgroundColor(Color.White)

}


  // 选择系统相册图片，获取路径
  async pickerAvatar() {
    //  1. 实例化选择参数对象
    const options = new picker.PhotoSelectOptions()
    options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE // 表示从相册中选择图片
    options.maxSelectNumber = 1 // 表示只选择一张

    //   2. 实例化选择器对象
    const pickerView = new picker.PhotoViewPicker()
    //   3. 调用选择器对象上的select方法传入参数对象即可完成选择
    let res = await pickerView.select(options)

    AlertDialog.show({message:JSON.stringify(res.photoUris)})

    // 4. 判断用户取消了选择图片，则组织下面代码的继续运行
    if (res.photoUris.length === 0) {
      promptAction.showToast({ message: "用户取消图片选择" })
      return
    }
    //   4.1 准备好一个图片的完整路径
    let ext = 'jpg' // 后缀
    let fileName = Date.now().toString() // 图片名称 //文件名
    let cacheDir = getContext().cacheDir // 获取应用程序的缓存目录 //沙箱路径
    let full = cacheDir + '/' + fileName + '.' + ext // 完整的图片路径
    //   4.2 利用fs拷贝图片
    let file = fs.openSync(res.photoUris[0], fs.OpenMode.READ_ONLY) // 打开那张选中照片    以只读模式
    fs.copyFileSync(file.fd,cacheDir+full)  // 拷贝的文件的标识符     拷贝的路径(沙箱路径 缓存路径)
    // AlertDialog.show({ message: '图片拷贝成功' })
  }


  build() {
      SideBarContainer(SideBarContainerType.Overlay){
        // 侧边栏
        this.mySideBar()
      //主页面
        Column(){
          Text('主页面')
            Button('上传照片')
              .onClick(()=>{
                this.pickerAvatar()
              })
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Pink)

      }
      .showSideBar($$this.isShow)
      .sideBarWidth('80%')
      .minSideBarWidth('80%')
      .maxSideBarWidth('100%')
      .minContentWidth('100%')
      .onChange((value: boolean) => {
        console.info('status:' + value)
      })
      .divider({ strokeWidth: '1vp', color: Color.Gray, startMargin: '4vp', endMargin: '4vp' })




  }
}