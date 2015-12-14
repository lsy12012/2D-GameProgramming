unit Data;

interface

type
  TStageData = array[1..35] of Cardinal;

const
  StageCount =  25;

  Boy2Min    =  1;
  Boy2Max    = 20;
  Boy1Min    = 21;
  Boy1Max    = 25;
  Bunker2Min = 26;
  Bunker2Max = 30;
  Bunker1Min = 31;
  Bunker1Max = 35;

  DataOrgWidth  = 800;
  DataOrgHeight = 640;

  Datas : array[ 1..StageCount ] of TStageData =
  (
    ( 01110306, 02640179, 04240057, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 01250327, 02790200, 04340080, 00000000, 00000000, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 01110306, 02640179, 04240057, 02380268, 04010151, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 01250327, 02790200, 04340080, 00000000, 00000000, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 01110306, 02640179, 04240057, 02380268, 04010151, 00540435, 06070032, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 01250327, 02790200, 04340080, 00000000, 00000000, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 01110306, 02640179, 04240057, 02380268, 04010151, 00540435, 06070032, 01490182, 02910062, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 01250327, 02790200, 04340080, 00000000, 00000000, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 01110306, 02640179, 04240057, 02380268, 04010151, 00540435, 06070032, 01490182, 02910062, 01740082, 00520162, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 01250327, 02790200, 04340080, 00000000, 00000000, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 01270273, 02740172, 04190071, 00830258, 03830092, 00170364, 05320008, 00940295, 03850047, 02420195, 02310158, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 01400315, 02790212, 04220115, 00270398, 05520035, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 01500251, 03010138, 04410036, 01140280, 03490104, 00170364, 05030002, 00650321, 03990067, 02000212, 02490173, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 01400315, 02790212, 04220115, 00270398, 05520035, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 02290308, 03680208, 05290100, 01140280, 04210168, 00050357, 05290006, 01220386, 04060080, 02800274, 02490173, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 01400315, 02790212, 04220115, 00270398, 05520035, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 02290308, 03680208, 05290100, 01710348, 04210168, 00610436, 05810049, 01220386, 04680137, 02800274, 03210234, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 05520035, 00270398, 01400315, 02790212, 04220115, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 02760298, 03720215, 04770142, 02380328, 04090185, 01530389, 05010116, 01960364, 04460161, 03100274, 03430246, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03400482, 05040358, 06510240, 00000000, 00000000, 05520035, 00270398, 01400315, 02790212, 04220115, 02740463, 04360335, 05890215, 00000000, 00000000 ),
    ( 03880029, 01100247, 03630203, 02050107, 01760125, 00300432, 05730012, 00910256, 03680040, 05420031, 00080443, 03120249, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03970520, 05490392, 07110274, 04090413, 05800294, 05790049, 00270453, 01080271, 02030136, 03950062, 03110500, 04830367, 06440252, 03400394, 05150272 ),
    ( 03880029, 01100247, 03700201, 02050107, 01400397, 00300432, 05730012, 01930346, 04260157, 04870113, 02480298, 03120249, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03970520, 05490392, 07110274, 04090413, 05800294, 05790049, 00270453, 01080271, 02030136, 03950062, 03110500, 04830367, 06440252, 03400394, 05150272 ),
    ( 03880029, 01100247, 03770235, 02050107, 02270360, 00300432, 05730012, 02630329, 04090207, 04420180, 03050298, 03410264, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03970520, 05490392, 07110274, 04090413, 05800294, 05790049, 00270453, 01080271, 02030136, 03950062, 03110500, 04830367, 06440252, 03400394, 05150272 ),
    ( 00440432, 00000479, 04920094, 03220221, 01550339, 01010384, 05510053, 02080303, 04300137, 03800180, 02700261, 06110012, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03370445, 04820335, 06320214, 04070389, 05610274, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000 ),
    ( 00440432, 00000479, 04920094, 03220221, 01550339, 01010384, 05510053, 02080303, 04300137, 03800180, 02700261, 06110012, 00490322, 01160284, 01780234, 02380182, 03060137, 03610094, 04330042, 00000000, 03370445, 04820335, 06320214, 04070389, 05610274, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000 ),
    ( 04420099, 03430090, 05790039, 01220410, 00530014, 02280042, 02990180, 00810175, 02010234, 04580003, 00140372, 02010335, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 04770318, 06540235, 04260476, 00000000, 00000000, 00710047, 00960195, 02360060, 04670015, 04420118, 06560171, 05920214, 04040281, 03420440, 02660494 ),
    ( 04540047, 04000073, 03760172, 00950338, 00530014, 02150096, 02800250, 01060160, 01650127, 05130018, 00370377, 01460303, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 04770318, 06540235, 04260476, 00000000, 00000000, 02290118, 01730152, 05240039, 04720071, 01610334, 06560171, 05920214, 04040281, 03420440, 02660494 ),
    ( 04540047, 04740015, 02740055, 00950338, 00500188, 02150096, 03480215, 01060160, 01650127, 05130018, 00370377, 00510324, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 05320358, 06880225, 03760458, 00000000, 00000000, 02860085, 02290118, 01730152, 01150183, 05240039, 06230201, 05330281, 04710316, 04170358, 03060434 ),
    ( 04220084, 03890012, 02780072, 01170293, 00320267, 03060150, 01160194, 01890132, 05130018, 00200355, 02010224, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 05440341, 06880225, 03760458, 06190294, 04560404, 01210227, 00360294, 04000029, 02920091, 01950153, 06230201, 05480253, 04710316, 03890373, 03060434 ),
    ( 03850089, 04260007, 02560056, 01870275, 00880301, 03270170, 01100137, 01740097, 00630022, 00080320, 02880247, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 05440341, 06880225, 03760458, 06190294, 04560404, 01220165, 01000328, 04350024, 02700079, 01880124, 06230201, 05480253, 04710316, 03890373, 03060434 ),
    ( 03850089, 05980146, 02560056, 04910218, 00880301, 03270170, 01150166, 00510449, 00630022, 02620444, 02880247, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 05440341, 05360083, 02290386, 06640349, 05510451, 01290205, 01000328, 06080171, 02700079, 00580471, 04930073, 06080320, 04710316, 04890420, 01640353 ),
    ( 03850089, 05860082, 02560056, 04910115, 00880301, 03270170, 01670245, 00510449, 02050147, 02600314, 02880247, 01520400, 00850372, 04180189, 04580037, 06300022, 00700225, 01750327, 03750262, 03600347, 05870364, 06090257, 03710528, 06940294, 04870439, 00000000, 00000000, 00000000, 00000000, 00000000, 07170119, 06800164, 06280199, 05700242, 05230284 ),
    ( 00130227, 00810013, 00140129, 02000005, 01470041, 00720075, 01880067, 01190158, 00420176, 00820133, 02510019, 03210032, 00100040, 01550108, 02480080, 00980227, 00180292, 00000000, 00000000, 00000000, 06150322, 03940516, 05070414, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 05450291, 04320382, 03230485, 00000000, 00000000 ),
    ( 00380041, 01340049, 02460051, 03380034, 04320051, 00600193, 02150176, 03260181, 00620350, 01850313, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 03960494, 05920384, 07170260, 07230413, 06000518, 05680069, 05040116, 04340168, 03630222, 02840272, 04420271, 05040300, 05650323, 02900369, 03550404 ),
    ( 00380041, 01340049, 02460051, 03380034, 04320051, 00600193, 02150176, 05200124, 00620350, 02140346, 01520158, 02940135, 03830120, 02570211, 01440249, 00730267, 05240032, 00720118, 01920115, 00380442, 03990405, 04000334, 04840332, 05610338, 04020470, 05680069, 04570078, 04340168, 03130185, 02840272, 04420271, 05420235, 06320222, 02900369, 02850435 )

  );

implementation
end.
