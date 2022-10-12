import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import '../models/BetweenSM.dart';
import '../models/ColorSettings.dart';

class Privacy extends StatefulWidget {
  Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  var values = [
    "「foodone福團團」是由「foodone開發團隊」（下稱我們）所經營之APP(下稱本APP)各項服務與資訊。",
    "以下是我們的隱私權保護政策，幫助您瞭解本APP所蒐集的個人資料之運用及保護方式。",
    "一、隱私權保護政策的適用範圍",
    "（1）請您在於使用本APP服務前，確認您已審閱並同意本隱私權政策所列全部條款，若您不同意全部或部份者，則請勿使用本APP服務。",
    "（2）隱私權保護政策內容，包括我們如何處理您在使用本APP服務時蒐集到的個人識別資料。",
    "（3）隱私權保護政策不適用於本APP以外的相關連結網站，亦不適用於非我們所委託或參與管理之人員。",
    "",
    "二、個人資料的蒐集及使用",
    "（1）於一般瀏覽時，伺服器會自行記錄相關行徑，包括您使用連線設備的IP位址、使用時間、使用的瀏覽器、瀏覽及點選資料記錄等，做為我們增進服務的參考依據，此記錄為內部應用，絕不對外公布。",
    "（2）在使用我們的服務時，我們可能會要求您向我們提供可用於聯繫或識別您的某些個人資料，包括：",
    "• C001辨識個人者： 如姓名、地址、電話、電子郵件等資訊。",
    "• C011個人描述：例如：性別、出生年月日等。",
    "（3）本APP將蒐集的數據用於各種目的：",
    "•提供和維護系統所提供讀服務",
    "•提供用戶支持",
    "•提供分析或有價值訊息，以便我們改進服務",
    "•監控服務的使用情況",
    "•檢測，預防和解決技術問題",
    "（4）本APP針對蒐集數據的利用期間、地區、對象及方式：",
    "•期間：當事人要求停止使用或本服務停止提供服務之日為止。",
    "•地區：個人資料將用於台灣地區。",
    "•利用對象及方式：所蒐集到的資料將利用於各項業務之執行，利用方式為因業務執行所必須進行之各項分析、聯繫及通知。",
    "",
    "三、資料的保護與安全",
    "（1）本APP主機均設有防火牆、防毒系統等相關資訊安全設備及必要的安全防護措施，本APP及您的個人資料均受到嚴格的保護。只有經過授權的人員才能接觸您的個人資料，相關處理人員均有簽署保密合約，如有違反保密義務者，將會受到相關的法律處分。",
    "（2） 如因業務需要有必要委託本APP相關單位提供服務時，我們會要求其遵守保密義務，並採取相當之檢查程序以確定其將確實遵守。",
    "（3）請您妥善保管您的密碼與個人資料，並提醒您使用完畢本APP相關服務後，務必關閉本APP，以免您的資料遭人盜用。",
    "（4）您同意在使用本APP服務時，所留存的資料與事實相符。另若嗣後您發現您的個人資料遭他人非法使用或有任何異常時，應即時通知我們。",
    "（5）您同意於使用本APP服務時，所提供及使用之資料皆為合法，並無侵害第三人權利、違反第三方協議或涉及任何違法行為。如因使用本APP服務而致第三人損害，除因我們故意或重大過失所致外，我們並不負擔相關賠償責任。",
    "",
    "四、對外的相關連結",
    "本APP上有可能包含其他合作網站或網頁連結，該網站或網頁也有可能會蒐集您的個人資料，不論其內容或隱私權政策為何，皆與本APP 無關，您應自行參考該連結網站中的隱私權保護政策，我們不負任何連帶責任。",
    "五、與第三人共用個人資料之政策",
    "（1）本APP絕不會提供、交換、出租或出售任何您的個人資料給其他個人、團體、私人企業或公務機關，但有法律依據或合約義務者，不在此限。",
    "（2）前項但書之情形包括但不限於：",
    "•經由您書面同意。",
    "•法律明文規定。",
    "•為維護國家安全或增進公共利益。",
    "•為免除您生命、身體、自由或財產上之危險。",
    "•與公務機關或學術研究機構合作，基於公共利益為統計或學術研究而有必要，且資料經過提供者處理或蒐集者依其揭露方式無從識別特定之當事人。",
    "•當您在APP的行為，違反服務條款或可能損害或妨礙APP與其他使用者權益或導致任何人遭受損害時，經APP管理單位研析揭露您的個人資料是為了辨識、聯絡或採取法律行動所必要者。",
    "•有利於您的權益。",
    "（3）本APP委託廠商協助蒐集、處理或利用您的個人資料時，將對委外廠商或個人善盡監督管理之責。",
    "",
    "六、Cookie之使用",
    "（1）為了提供您最佳的服務，本網站會在您的電腦中放置並取用我們的Cookie，若您不願接受Cookie的寫入，您可在您使用的瀏覽器功能項中設定隱私權等級為高，即可拒絕Cookie的寫入，但可能會導致網站某些功能無法正常執行 。",
    "以下是可能使用的Cookie範例:",
    "•session cookies. 用來維護應用程式的狀態",
    "•Preference Cookies. 用來記錄您的喜好與設定",
    "•Security Cookies. 用來控制安全和檢查",
    "",
    "七、未成年人保護",
    "未成年人於註冊或使用本服務而同意本公司蒐集、利用其個人資訊時，應按其年齡由其法定代理人代為或在法定代理人之同意下為之。",
    "",
    "八、隱私權政策的修訂",
    "我們將因應需求擁有隨時修改本隱私權保護政策的權利，當我們做出修改時，會於本APP公告，且自公告日起生效，不再另行通知。",
    "",
    "",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          title: BetweenSM(
            color: kBodyTextColor,
            text: '隱私條款',
            fontFamily: 'NotoSansMedium',
          ),
          leading: IconButton(
            icon: Icon(
              Icons.west,
              color: kMaimColor,
              size: Dimensions.icon25,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView.builder(
          itemCount: values.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: EdgeInsets.only(
                left: Dimensions.width15,
                right: Dimensions.width15,
                top: Dimensions.height20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabText(
                    color: kBodyTextColor,
                    text: values[index],
                    maxLines: 100,
                    fontFamily: 'NotoSansMedium',
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
