function val=FibonacciNum(n)
%%FIBONACCINUM  Determine the nth Fibonacci number. Fibonacci numbers are
%               the sequence 1, 1, 2, 3, 5, 8, ... for n=1,2,3,4,5,6,...
%               where F_{n}=F_{n-1}+F_{n-2} determines the next value. A
%               non-recursion expression is used here so that large
%               Fibonacci numbers can be quickly found.
%
%INPUTS: n A scalar or matrix of integer Fibonacci number positions, n>0.
%
%OUTPUTS: val The values of the Fibonacci numbers at the positions given in
%             n. These should be exact for n<70.
%
%The recursive and non-recursive formulae are taken from [1]. The recursive
%formula could be used up to n=78, as after that, finite precision errors
%dominate. However, a lookup table is much faster. Thus for n<=500, a
%lookup table is used. After that, the non-recusive formula is used. The
%formula is implemented in a slightly more convoluted manner than one might
%expect using log and exp to try to minimize finite precision errors as
%much as possible. The issue comes with the exponent of phi. The
%non-recusive formula should not be used when the recursive formula is
%exact as the non-recusive formula loses a few bits of precision before the
%recusive formula (in the n=70's.) However, the non-recusive formula is
%faster and has more bits of precision for very large values of n.
%
%REFERENCES:
%[1] Chandra, Pravin and Weisstein, Eric W. "Fibonacci Number." From
%    MathWorld--A Wolfram Web Resource.
%    http://mathworld.wolfram.com/FibonacciNumber.html
%
%November 2015 David F. Crouse, Naval Research Laboratory, Washington D.C.
%(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.

%Allocate space
val=zeros(size(n));

if(any(n~=fix(n)|imag(n)~=0|n<=0))
   error('n has the wrong format')
end

%Commented out below is the recursive implementation for small values of n.
%However, it is not used, because it is faster to use a lookup table.
%Set the starting cases.
% val(n==1|n==2)=1;
% %Select values that are small enough so that the recursion can be used
% %without a loss of precision
% sel=(n<=78)&(n>2);
% 
% y=n(sel);
% %Use the definition involving the recursion.
% if(~isempty(y))
%     numY=numel(y);
%     res=zeros(numY,1);
%     
%     %We sort it in increasing order, so that we do not have to go back.
%     y=sort(y);
%     
%     fCur=1;
%     fPrev=1;
%     curY=1;
%     curN=3;
%     while(curY<=numY)
%         f=fCur+fPrev;
%         
%         if(y(curY)==curN)
%             res(curY)=f;
%             curY=curY+1;
%         end
%         
%         fPrev=fCur;
%         fCur=f;
%         
%         curN=curN+1;
%     end
%     
%     val(sel)=res;
% end

%Lookup table implementation.
sel=n<=500;
val(sel)=fibNumFromTable(n(sel));

y=n(~sel);
%Deal with big numbers
if(~isempty(y))
    %The golden ratio.
    phi=(1+sqrt(5))/2;

    val(~sel)=round(exp(y*log(phi)-log(sqrt(5))));
end

end

function val=fibNumFromTable(n)
    theTable=[1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765,10946,17711,28657,46368,75025,121393,196418,317811,514229,832040,1346269,2178309,3524578,5702887,9227465,14930352,24157817,39088169,63245986,102334155,165580141,267914296,433494437,701408733,1134903170,1836311903,2971215073,4807526976,7778742049,12586269025,20365011074,32951280099,53316291173,86267571272,139583862445,225851433717,365435296162,591286729879,956722026041,1548008755920,2504730781961,4052739537881,6557470319842,10610209857723,17167680177565,27777890035288,44945570212853,72723460248141,117669030460994,190392490709135,308061521170129,498454011879264,806515533049393,1304969544928657,2111485077978050,3416454622906707,5527939700884757,8944394323791464,14472334024676221,23416728348467685,37889062373143906,61305790721611591,99194853094755497,160500643816367088,259695496911122585,420196140727489673,679891637638612258,1100087778366101931,1779979416004714189,2880067194370816120,4660046610375530309,7540113804746346429,12200160415121876738,19740274219868223167,31940434634990099905,51680708854858323072,83621143489848422977,135301852344706746049,218922995834555169026,354224848179261915075,573147844013817084101,927372692193078999176,1500520536206896083277,2427893228399975082453,3928413764606871165730,6356306993006846248183,10284720757613717413913,16641027750620563662096,26925748508234281076009,43566776258854844738105,70492524767089125814114,114059301025943970552219,184551825793033096366333,298611126818977066918552,483162952612010163284885,781774079430987230203437,1264937032042997393488322,2046711111473984623691759,3311648143516982017180081,5358359254990966640871840,8670007398507948658051921,14028366653498915298923761,22698374052006863956975682,36726740705505779255899443,59425114757512643212875125,96151855463018422468774568,155576970220531065681649693,251728825683549488150424261,407305795904080553832073954,659034621587630041982498215,1066340417491710595814572169,1725375039079340637797070384,2791715456571051233611642553,4517090495650391871408712937,7308805952221443105020355490,11825896447871834976429068427,19134702400093278081449423917,30960598847965113057878492344,50095301248058391139327916261,81055900096023504197206408605,131151201344081895336534324866,212207101440105399533740733471,343358302784187294870275058337,555565404224292694404015791808,898923707008479989274290850145,1454489111232772683678306641953,2353412818241252672952597492098,3807901929474025356630904134051,6161314747715278029583501626149,9969216677189303386214405760200,16130531424904581415797907386349,26099748102093884802012313146549,42230279526998466217810220532898,68330027629092351019822533679447,110560307156090817237632754212345,178890334785183168257455287891792,289450641941273985495088042104137,468340976726457153752543329995929,757791618667731139247631372100066,1226132595394188293000174702095995,1983924214061919432247806074196061,3210056809456107725247980776292056,5193981023518027157495786850488117,8404037832974134882743767626780173,13598018856492162040239554477268290,22002056689466296922983322104048463,35600075545958458963222876581316753,57602132235424755886206198685365216,93202207781383214849429075266681969,150804340016807970735635273952047185,244006547798191185585064349218729154,394810887814999156320699623170776339,638817435613190341905763972389505493,1033628323428189498226463595560281832,1672445759041379840132227567949787325,2706074082469569338358691163510069157,4378519841510949178490918731459856482,7084593923980518516849609894969925639,11463113765491467695340528626429782121,18547707689471986212190138521399707760,30010821454963453907530667147829489881,48558529144435440119720805669229197641,78569350599398894027251472817058687522,127127879743834334146972278486287885163,205697230343233228174223751303346572685,332825110087067562321196029789634457848,538522340430300790495419781092981030533,871347450517368352816615810882615488381,1409869790947669143312035591975596518914,2281217241465037496128651402858212007295,3691087032412706639440686994833808526209,5972304273877744135569338397692020533504,9663391306290450775010025392525829059713,15635695580168194910579363790217849593217,25299086886458645685589389182743678652930,40934782466626840596168752972961528246147,66233869353085486281758142155705206899077,107168651819712326877926895128666735145224,173402521172797813159685037284371942044301,280571172992510140037611932413038677189525,453973694165307953197296969697410619233826,734544867157818093234908902110449296423351,1188518561323126046432205871807859915657177,1923063428480944139667114773918309212080528,3111581989804070186099320645726169127737705,5034645418285014325766435419644478339818233,8146227408089084511865756065370647467555938,13180872826374098837632191485015125807374171,21327100234463183349497947550385773274930109,34507973060837282187130139035400899082304280,55835073295300465536628086585786672357234389,90343046356137747723758225621187571439538669,146178119651438213260386312206974243796773058,236521166007575960984144537828161815236311727,382699285659014174244530850035136059033084785,619220451666590135228675387863297874269396512,1001919737325604309473206237898433933302481297,1621140188992194444701881625761731807571877809,2623059926317798754175087863660165740874359106,4244200115309993198876969489421897548446236915,6867260041627791953052057353082063289320596021,11111460156937785151929026842503960837766832936,17978720198565577104981084195586024127087428957,29090180355503362256910111038089984964854261893,47068900554068939361891195233676009091941690850,76159080909572301618801306271765994056795952743,123227981463641240980692501505442003148737643593,199387062373213542599493807777207997205533596336,322615043836854783580186309282650000354271239929,522002106210068326179680117059857997559804836265,844617150046923109759866426342507997914076076194,1366619256256991435939546543402365995473880912459,2211236406303914545699412969744873993387956988653,3577855662560905981638959513147239988861837901112,5789092068864820527338372482892113982249794889765,9366947731425726508977331996039353971111632790877,15156039800290547036315704478931467953361427680642,24522987531716273545293036474970821924473060471519,39679027332006820581608740953902289877834488152161,64202014863723094126901777428873111802307548623680,103881042195729914708510518382775401680142036775841,168083057059453008835412295811648513482449585399521,271964099255182923543922814194423915162591622175362,440047156314635932379335110006072428645041207574883,712011255569818855923257924200496343807632829750245,1152058411884454788302593034206568772452674037325128,1864069667454273644225850958407065116260306867075373,3016128079338728432528443992613633888712980904400501,4880197746793002076754294951020699004973287771475874,7896325826131730509282738943634332893686268675876375,12776523572924732586037033894655031898659556447352249,20672849399056463095319772838289364792345825123228624,33449372971981195681356806732944396691005381570580873,54122222371037658776676579571233761483351206693809497,87571595343018854458033386304178158174356588264390370,141693817714056513234709965875411919657707794958199867,229265413057075367692743352179590077832064383222590237,370959230771131880927453318055001997489772178180790104,600224643828207248620196670234592075321836561403380341,971183874599339129547649988289594072811608739584170445,1571408518427546378167846658524186148133445300987550786,2542592393026885507715496646813780220945054040571721231,4114000911454431885883343305337966369078499341559272017,6656593304481317393598839952151746590023553382130993248,10770594215935749279482183257489712959102052723690265265,17427187520417066673081023209641459549125606105821258513,28197781736352815952563206467131172508227658829511523778,45624969256769882625644229676772632057353264935332782291,73822750993122698578207436143903804565580923764844306069,119447720249892581203851665820676436622934188700177088360,193270471243015279782059101964580241188515112465021394429,312718191492907860985910767785256677811449301165198482789,505988662735923140767969869749836918999964413630219877218,818706854228831001753880637535093596811413714795418360007,1324695516964754142521850507284930515811378128425638237225,2143402371193585144275731144820024112622791843221056597232,3468097888158339286797581652104954628434169971646694834457,5611500259351924431073312796924978741056961814867751431689,9079598147510263717870894449029933369491131786514446266146,14691098406862188148944207245954912110548093601382197697835,23770696554372451866815101694984845480039225387896643963981,38461794961234640015759308940939757590587318989278841661816,62232491515607091882574410635924603070626544377175485625797,100694286476841731898333719576864360661213863366454327287613,162926777992448823780908130212788963731840407743629812913410,263621064469290555679241849789653324393054271110084140201023,426547842461739379460149980002442288124894678853713953114433,690168906931029935139391829792095612517948949963798093315456,1116716749392769314599541809794537900642843628817512046429889,1806885656323799249738933639586633513160792578781310139745345,2923602405716568564338475449381171413803636207598822186175234,4730488062040367814077409088967804926964428786380132325920579,7654090467756936378415884538348976340768064993978954512095813,12384578529797304192493293627316781267732493780359086838016392,20038668997554240570909178165665757608500558774338041350112205,32423247527351544763402471792982538876233052554697128188128597,52461916524905785334311649958648296484733611329035169538240802,84885164052257330097714121751630835360966663883732297726369399,137347080577163115432025771710279131845700275212767467264610201,222232244629420445529739893461909967206666939096499764990979600,359579325206583560961765665172189099052367214309267232255589801,581811569836004006491505558634099066259034153405766997246569401,941390895042587567453271223806288165311401367715034229502159202,1523202464878591573944776782440387231570435521120801226748728603,2464593359921179141398048006246675396881836888835835456250887805,3987795824799770715342824788687062628452272409956636682999616408,6452389184720949856740872794933738025334109298792472139250504213,10440185009520720572083697583620800653786381708749108822250120621,16892574194241670428824570378554538679120491007541580961500624834,27332759203762391000908267962175339332906872716290689783750745455,44225333398004061429732838340729878012027363723832270745251370289,71558092601766452430641106302905217344934236440122960529002115744,115783425999770513860373944643635095356961600163955231274253486033,187341518601536966291015050946540312701895836604078191803255601777,303124944601307480151388995590175408058857436768033423077509087810,490466463202844446442404046536715720760753273372111614880764689587,793591407804151926593793042126891128819610710140145037958273777397,1284057871006996373036197088663606849580363983512256652839038466984,2077649278811148299629990130790497978399974693652401690797312244381,3361707149818144672666187219454104827980338677164658343636350711365,5439356428629292972296177350244602806380313370817060034433662955746,8801063578447437644962364569698707634360652047981718378070013667111,14240420007076730617258541919943310440740965418798778412503676622857,23041483585524168262220906489642018075101617466780496790573690289968,37281903592600898879479448409585328515842582885579275203077366912825,60323387178125067141700354899227346590944200352359771993651057202793,97605290770725966021179803308812675106786783237939047196728424115618,157928677948851033162880158208040021697730983590298819190379481318411,255533968719576999184059961516852696804517766828237866387107905434029,413462646668428032346940119724892718502248750418536685577487386752440,668996615388005031531000081241745415306766517246774551964595292186469,1082459262056433063877940200966638133809015267665311237542082678938909,1751455877444438095408940282208383549115781784912085789506677971125378,2833915139500871159286880483175021682924797052577397027048760650064287,4585371016945309254695820765383405232040578837489482816555438621189665,7419286156446180413982701248558426914965375890066879843604199271253952,12004657173391489668678522013941832147005954727556362660159637892443617,19423943329837670082661223262500259061971330617623242503763837163697569,31428600503229159751339745276442091208977285345179605163923475056141186,50852543833066829834000968538942350270948615962802847667687312219838755,82281144336295989585340713815384441479925901307982452831610787275979941,133133688169362819419341682354326791750874517270785300499298099495818696,215414832505658809004682396169711233230800418578767753330908886771798637,348548520675021628424024078524038024981674935849553053830206986267617333,563963353180680437428706474693749258212475354428320807161115873039415970,912511873855702065852730553217787283194150290277873860991322859307033303,1476475227036382503281437027911536541406625644706194668152438732346449273,2388987100892084569134167581129323824600775934984068529143761591653482576,3865462327928467072415604609040860366007401579690263197296200323999931849,6254449428820551641549772190170184190608177514674331726439961915653414425,10119911756749018713965376799211044556615579094364594923736162239653346274,16374361185569570355515148989381228747223756609038926650176124155306760699,26494272942318589069480525788592273303839335703403521573912286394960106973,42868634127888159424995674777973502051063092312442448224088410550266867672,69362907070206748494476200566565775354902428015845969798000696945226974645,112231541198094907919471875344539277405965520328288418022089107495493842317,181594448268301656413948075911105052760867948344134387820089804440720816962,293825989466396564333419951255644330166833468672422805842178911936214659279,475420437734698220747368027166749382927701417016557193662268716376935476241,769246427201094785080787978422393713094534885688979999504447628313150135520,1244666864935793005828156005589143096022236302705537193166716344690085611761,2013913292136887790908943984011536809116771188394517192671163973003235747281,3258580157072680796737099989600679905139007491100054385837880317693321359042,5272493449209568587646043973612216714255778679494571578509044290696557106323,8531073606282249384383143963212896619394786170594625964346924608389878465365,13803567055491817972029187936825113333650564850089197542855968899086435571688,22334640661774067356412331900038009953045351020683823507202893507476314037053,36138207717265885328441519836863123286695915870773021050058862406562749608741,58472848379039952684853851736901133239741266891456844557261755914039063645794,94611056096305838013295371573764256526437182762229865607320618320601813254535,153083904475345790698149223310665389766178449653686710164582374234640876900329,247694960571651628711444594884429646292615632415916575771902992555242690154864,400778865046997419409593818195095036058794082069603285936485366789883567055193,648473825618649048121038413079524682351409714485519861708388359345126257210057,1049252690665646467530632231274619718410203796555123147644873726135009824265250,1697726516284295515651670644354144400761613511040643009353262085480136081475307,2746979206949941983182302875628764119171817307595766156998135811615145905740557,4444705723234237498833973519982908519933430818636409166351397897095281987215864,7191684930184179482016276395611672639105248126232175323349533708710427892956421,11636390653418416980850249915594581159038678944868584489700931605805709880172285,18828075583602596462866526311206253798143927071100759813050465314516137773128706,30464466237021013443716776226800834957182606015969344302751396920321847653300991,49292541820623609906583302538007088755326533087070104115801862234837985426429697,79757008057644623350300078764807923712509139103039448418553259155159833079730688,129049549878268233256883381302815012467835672190109552534355121389997818506160385,208806557935912856607183460067622936180344811293149000952908380545157651585891073,337856107814181089864066841370437948648180483483258553487263501935155470092051458,546662665750093946471250301438060884828525294776407554440171882480313121677942531,884518773564275036335317142808498833476705778259666107927435384415468591769993989,1431181439314368982806567444246559718305231073036073662367607266895781713447936520,2315700212878644019141884587055058551781936851295739770295042651311250305217930509,3746881652193013001948452031301618270087167924331813432662649918207032018665867029,6062581865071657021090336618356676821869104775627553202957692569518282323883797538,9809463517264670023038788649658295091956272699959366635620342487725314342549664567,15872045382336327044129125268014971913825377475586919838578035057243596666433462105,25681508899600997067167913917673267005781650175546286474198377544968911008983126672,41553554281937324111297039185688238919607027651133206312776412602212507675416588777,67235063181538321178464953103361505925388677826679492786974790147181418684399715449,108788617463475645289761992289049744844995705477812699099751202749393926359816304226,176023680645013966468226945392411250770384383304492191886725992896575345044216019675,284812298108489611757988937681460995615380088782304890986477195645969271404032323901,460835978753503578226215883073872246385764472086797082873203188542544616448248343576,745648276861993189984204820755333242001144560869101973859680384188513887852280667477,1206484255615496768210420703829205488386909032955899056732883572731058504300529011053,1952132532477489958194625524584538730388053593825001030592563956919572392152809678530,3158616788092986726405046228413744218774962626780900087325447529650630896453338689583,5110749320570476684599671752998282949163016220605901117918011486570203288606148368113,8269366108663463411004717981412027167937978847386801205243459016220834185059487057696,13380115429233940095604389734410310117100995067992702323161470502791037473665635425809,21649481537897403506609107715822337285038973915379503528404929519011871658725122483505,35029596967131343602213497450232647402139968983372205851566400021802909132390757909314,56679078505028747108822605166054984687178942898751709379971329540814780791115880392819,91708675472160090711036102616287632089318911882123915231537729562617689923506638302133,148387753977188837819858707782342616776497854780875624611509059103432470714622518694952,240096429449348928530894810398630248865816766662999539843046788666050160638129156997085,388484183426537766350753518180972865642314621443875164454555847769482631352751675692037,628580612875886694881648328579603114508131388106874704297602636435532791990880832689122,1017064796302424461232401846760575980150446009550749868752158484205015423343632508381159,1645645409178311156114050175340179094658577397657624573049761120640548215334513341070281,2662710205480735617346452022100755074809023407208374441801919604845563638678145849451440,4308355614659046773460502197440934169467600804865999014851680725486111854012659190521721,6971065820139782390806954219541689244276624212074373456653600330331675492690805039973161,11279421434798829164267456416982623413744225016940372471505281055817787346703464230494882,18250487254938611555074410636524312658020849229014745928158881386149462839394269270468043,29529908689737440719341867053506936071765074245955118399664162441967250186097733500962925,47780395944676052274416277690031248729785923474969864327823043828116713025492002771430968,77310304634413492993758144743538184801550997720924982727487206270083963211589736272393893,125090700579089545268174422433569433531336921195894847055310250098200676237081739043824861,202401005213503038261932567177107618332887918916819829782797456368284639448671475316218754,327491705792592583530106989610677051864224840112714676838107706466485315685753214360043615,529892711006095621792039556787784670197112759029534506620905162834769955134424689676262369,857384416798688205322146546398461722061337599142249183459012869301255270820177904036305984,1387277127804783827114186103186246392258450358171783690079918032136025225954602593712568353,2244661544603472032436332649584708114319787957314032873538930901437280496774780497748874337,3631938672408255859550518752770954506578238315485816563618848933573305722729383091461442690,5876600217011727891986851402355662620898026272799849437157779835010586219504163589210317027,9508538889419983751537370155126617127476264588285666000776628768583891942233546680671759717,15385139106431711643524221557482279748374290861085515437934408603594478161737710269882076744,24893677995851695395061591712608896875850555449371181438711037372178370103971256950553836461,40278817102283407038585813270091176624224846310456696876645445975772848265708967220435913205,65172495098135102433647404982700073500075401759827878315356483347951218369680224170989749666,105451312200418509472233218252791250124300248070284575192001929323724066635389191391425662871,170623807298553611905880623235491323624375649830112453507358412671675285005069415562415412537,276075119498972121378113841488282573748675897900397028699360341995399351640458606953841075408,446698926797525733283994464723773897373051547730509482206718754667074636645528022516256487945,722774046296497854662108306212056471121727445630906510906079096662473988285986629470097563353,1169472973094023587946102770935830368494778993361415993112797851329548624931514651986354051298,1892247019390521442608211077147886839616506438992322504018876947992022613217501281456451614651,3061719992484545030554313848083717208111285432353738497131674799321571238149015933442805665949,4953967011875066473162524925231604047727791871346061001150551747313593851366517214899257280600,8015687004359611503716838773315321255839077303699799498282226546635165089515533148342062946549,12969654016234677976879363698546925303566869175045860499432778293948758940882050363241320227149,20985341020594289480596202471862246559405946478745659997715004840583924030397583511583383173698,33954995036828967457475566170409171862972815653791520497147783134532682971279633874824703400847,54940336057423256938071768642271418422378762132537180494862787975116607001677217386408086574545,88895331094252224395547334812680590285351577786328700992010571109649289972956851261232789975392,143835667151675481333619103454952008707730339918865881486873359084765896974634068647640876549937,232730998245927705729166438267632598993081917705194582478883930194415186947590919908873666525329,376566665397603187062785541722584607700812257624060463965757289279181083922224988556514543075266,609297663643530892791951979990217206693894175329255046444641219473596270869815908465388209600595,985864329041134079854737521712801814394706432953315510410398508752777354792040897021902752675861,1595161992684664972646689501703019021088600608282570556855039728226373625661856805487290962276456,2581026321725799052501427023415820835483307041235886067265438236979150980453897702509193714952317,4176188314410464025148116525118839856571907649518456624120477965205524606115754507996484677228773,6757214636136263077649543548534660692055214690754342691385916202184675586569652210505678392181090,10933402950546727102797660073653500548627122340272799315506394167390200192685406718502163069409863,17690617586682990180447203622188161240682337031027142006892310369574875779255058929007841461590953,28624020537229717283244863695841661789309459371299941322398704536965075971940465647510004531000816,46314638123912707463692067318029823029991796402327083329291014906539951751195524576517845992591769,74938658661142424746936931013871484819301255773627024651689719443505027723135990224027850523592585,121253296785055132210628998331901307849293052175954107980980734350044979474331514800545696516184354,196191955446197556957565929345772792668594307949581132632670453793550007197467505024573547039776939,317445252231252689168194927677674100517887360125535240613651188143594986671799019825119243555961293,513637207677450246125760857023446893186481668075116373246321641937144993869266524849692790595738232,831082459908702935293955784701120993704369028200651613859972830080739980541065544674812034151699525,1344719667586153181419716641724567886890850696275767987106294472017884974410332069524504824747437757,2175802127494856116713672426425688880595219724476419600966267302098624954951397614199316858899137282,3520521795081009298133389068150256767486070420752187588072561774116509929361729683723821683646575039,5696323922575865414847061494575945648081290145228607189038829076215134884313127297923138542545712321,9216845717656874712980450562726202415567360565980794777111390850331644813674856981646960226192287360,14913169640232740127827512057302148063648650711209401966150219926546779697987984279570098768737999681,24130015357889614840807962620028350479216011277190196743261610776878424511662841261217058994930287041,39043184998122354968635474677330498542864661988399598709411830703425204209650825540787157763668286722,63173200356011969809443437297358849022080673265589795452673441480303628721313666802004216758598573763,102216385354134324778078911974689347564945335253989394162085272183728832930964492342791374522266860485,165389585710146294587522349272048196587026008519579189614758713664032461652278159144795591280865434248,267605971064280619365601261246737544151971343773568583776843985847761294583242651487586965803132294733,432995556774426913953123610518785740738997352293147773391602699511793756235520810632382557083997728981,700601527838707533318724871765523284890968696066716357168446685359555050818763462119969522887130023714,1133597084613134447271848482284309025629966048359864130560049384871348807054284272752352079971127752695,1834198612451841980590573354049832310520934744426580487728496070230903857873047734872321602858257776409,2967795697064976427862421836334141336150900792786444618288545455102252664927332007624673682829385529104,4801994309516818408452995190383973646671835537213025106017041525333156522800379742496995285687643305513,7769790006581794836315417026718114982822736329999469724305586980435409187727711750121668968517028834617,12571784316098613244768412217102088629494571867212494830322628505768565710528091492618664254204672140130,20341574322680408081083829243820203612317308197211964554628215486203974898255803242740333222721700974747,32913358638779021325852241460922292241811880064424459384950843991972540608783894735358997476926373114877,53254932961459429406936070704742495854129188261636423939579059478176515507039697978099330699648074089624,86168291600238450732788312165664788095941068326060883324529903470149056115823592713458328176574447204501,139423224561697880139724382870407283950070256587697307264108962948325571622863290691557658876222521294125];

    val=theTable(n);
end

%LICENSE:
%
%The source code is in the public domain and not licensed or under
%copyright. The information and software may be used freely by the public.
%As required by 17 U.S.C. 403, third parties producing copyrighted works
%consisting predominantly of the material produced by U.S. government
%agencies must provide notice with such work(s) identifying the U.S.
%Government material incorporated and stating that such material is not
%subject to copyright protection.
%
%Derived works shall not identify themselves in a manner that implies an
%endorsement by or an affiliation with the Naval Research Laboratory.
%
%RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE OF THE
%SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO INDEMNIFY THE NAVAL
%RESEARCH LABORATORY FOR ALL THIRD-PARTY CLAIMS RESULTING FROM THE ACTIONS
%OF RECIPIENT IN THE USE OF THE SOFTWARE.
