import 'package:flutter/material.dart';
import 'package:flutterdemo02/res/ListData3.dart';

class BookMarkPage extends StatefulWidget {
  Map arguments;
  BookMarkPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<BookMarkPage> createState() => _BookMarkPageState(arguments: arguments);
}

class _BookMarkPageState extends State<BookMarkPage> {
  Map arguments;
  _BookMarkPageState({required this.arguments});
  final List<GlobalKey> categorias = [GlobalKey(), GlobalKey(), GlobalKey()];
  late ScrollController scrollcont;
  BuildContext? tabContext;

  @override
  void initState() {
    scrollcont = ScrollController();
    scrollcont.addListener(changeTabs);
    super.initState();
  }

  changeTabs() {
    late RenderBox box;

    for (var i = 0; i < categorias.length; i++) {
      box = categorias[i].currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);

      if (scrollcont.offset >= position.dy) {
        DefaultTabController.of(tabContext!)!
            .animateTo(i, duration: const Duration(milliseconds: 100));
      }
    }
  }

  //點標籤就滑到categoria(等於categoriast傳回來的key(index值))
  scrollTo(int index) async {
    scrollcont.removeListener(changeTabs);
    final categoria = categorias[index].currentContext!;
    await Scrollable.ensureVisible(
      categoria,
      duration: const Duration(milliseconds: 600),
    );
    scrollcont.addListener(changeTabs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 3,
            child: Builder(
              builder: (BuildContext context) {
                //不懂什麼意思
                tabContext = context;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200,
                      //往上滑一點APPBAR就會跑出來
                      // floating: true,
                      //只有Expanded的部分會隱藏
                      pinned: true,
                      stretch: true,
                      flexibleSpace: const FlexibleSpaceBar(
                        // background: Image.network(
                        //   'https://www.itying.com/images/flutter/6.png',fit: BoxFit.cover,),
                        //在上升的時候背景圖片固定
                        collapseMode: CollapseMode.pin,
                        // title: Text('My App Bar'),
                        centerTitle: true,
                      ),
                      actions: const [
                        Icon(Icons.settings),
                        SizedBox(
                          width: 12,
                        )
                      ],

                      bottom: TabBar(
                        tabs: const [
                          Tab(
                            text: '飯類',
                          ),
                          Tab(
                            text: '湯品',
                          ),
                          Tab(
                            text: '飲料',
                          )
                        ],
                        indicatorColor: const Color.fromRGBO(254, 151, 99, 2),
                        automaticIndicatorColorAdjustment: true,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        //點擊就將index傳到上面scrollTo的index
                        onTap: (int index) => scrollTo(index),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Column(
                        children: [
                          SingleChildScrollView(
                            controller: scrollcont,
                            child: Column(
                              children: [
                                categoriaComida(
                                    '飯類', 0), //0,1,2定義了它的index值，renderbox要用
                                gararListaComidas(JarrenClinic.rice),
                                categoriaComida('湯品', 1),
                                gararListaComidas(JarrenClinic.soup),
                                categoriaComida('飲料', 2),
                                gararListaComidas(JarrenClinic.beverage),
                              ],
                            ),
                          ),
                        ],
                      )
                    ]))
                  ],
                );
              },
            )));
  }

  gararListaComidas(List<Comida> comidas) {
    return Column(
      //comidaitem的index(Comida)傳給comidas.map循環便利出來並取名為gararListComidas
      children: comidas.map((index) => comidaItem(index)).toList(),
    );
  }

  //這邊定義Comida是index，所以下面的意思index.title是Comida的title
  Widget comidaItem(Comida index) {
    return Column(
      children: [
        ListTile(
          title: Text(index.title),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index.descibe,
                  style: const TextStyle(fontSize: 13),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    index.price,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          trailing: Image.network(index.imageUrl),
          contentPadding: const EdgeInsets.all(15),
        ),
        const Divider(),
      ],
    );
  }

  Widget categoriaComida(String titulo, int index) {
    return Padding(
      //重要scroll to的關鍵
      key: categorias[index],
      //重要scroll to的關鍵
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          ListTile(
            title: Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
