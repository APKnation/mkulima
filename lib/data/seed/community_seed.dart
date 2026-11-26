import '../models/post.dart';

const _img = 'assets/images';

List<CommunityPost> communitySeed() => [
      CommunityPost(
        id: 'c1',
        author: 'Amina Mwakyusa',
        role: 'Mkulima wa mboga · Njombe',
        location: 'Njombe',
        timeAgo: 'Dakika 25 zilizopita',
        content:
            'Nimeanza kutumia matandazo kwenye bustani ya nyanya. Baada ya wiki mbili, udongo unakaa unyevu mchana mzima na magugu yamepungua sana. Nimeambatanisha picha ya bustani leo.',
        categoryLabel: 'Mboga',
        type: 'mafanikio',
        imageAsset: '$_img/vegetables.jpg',
        likes: 64,
        comments: [
          CommunityComment(
            id: 'c1-1',
            author: 'Joseph Mrema',
            role: 'Mkulima · Kilimanjaro',
            timeAgo: 'Dakika 18 zilizopita',
            text: 'Hongera! Matandazo ni suluhisho la kweli kwa kiangazi. Umeweka nyasi gani?',
          ),
          CommunityComment(
            id: 'c1-2',
            author: 'Dk. Faraja Mwenda',
            role: 'Mtaalamu wa kilimo',
            timeAgo: 'Dakika 10 zilizopita',
            text: 'Nzuri sana. Endelea kukagua chini ya matandazo kwa wadudu na kuhakikisha hakuna kuoza.',
            isExpert: true,
          ),
        ],
      ),
      CommunityPost(
        id: 'c2',
        author: 'Hamisi Ally',
        role: 'Mfugaji wa kuku · Pwani',
        location: 'Kibaha',
        timeAgo: 'Saa 2 zilizopita',
        content:
            'Swali kwa wafugaji wenzangu: kuku wangu wa broiler wana umri wa wiki 5 lakini baadhi wana upungufu wa kula. Banda lina joto la kawaida na maji yapo. Nifanye nini?',
        categoryLabel: 'Ufugaji wa Kuku',
        type: 'swali',
        likes: 22,
        comments: [
          CommunityComment(
            id: 'c2-1',
            author: 'Neema Mushi',
            role: 'Mfugaji · Morogoro',
            timeAgo: 'Saa 1 iliyopita',
            text: 'Angalia ubora wa chakula na tarehe ya kumalizika. Mara nyingi chakula kilichohifadhiwa vibaya kinapunguza hamu.',
          ),
          CommunityComment(
            id: 'c2-2',
            author: 'Dk. Faraja Mwenda',
            role: 'Mtaalamu wa mifugo',
            timeAgo: 'Dakika 40 zilizopita',
            text: 'Pima joto la banda usiku. Pia angalia dalili za ugonjwa wa kupumua. Mwite mtaalamu wa mifugo karibu nawe ikiwa hali haibadiliki.',
            isExpert: true,
          ),
        ],
      ),
      CommunityPost(
        id: 'c3',
        author: 'Grace Kimaro',
        role: 'Mkulima wa matunda · Tanga',
        location: 'Muheza',
        timeAgo: 'Saa 5 zilizopita',
        content:
            'Bei ya machungwa imeanza kupanda sokoni Muheza. Wanunuzi wanakuja moja kwa moja shambani. Nimeuza gunia la kilo 40 kwa TSh 105,000 jana.',
        categoryLabel: 'Matunda',
        type: 'ushauri',
        likes: 41,
        comments: [
          CommunityComment(
            id: 'c3-1',
            author: 'Amina Mwakyusa',
            role: 'Mkulima · Njombe',
            timeAgo: 'Saa 3 zilizopita',
            text: 'Asante kwa taarifa. Naomba unijulishe mnunuzi kama anahitaji kiasi kikubwa.',
          ),
        ],
      ),
      CommunityPost(
        id: 'c4',
        author: 'Joseph Mrema',
        role: 'Mkulima wa nafaka · Mbeya',
        location: 'Mbalizi',
        timeAgo: 'Jana',
        content:
            'Tumemaliza kuvuna mahindi na kuyakausha kwa siku tano. Unyevu ni 12.8%. Tunatafuta mnunuzi wa gunia 200 kwa bei ya jumla. Tafadhali wasiliana kupitia ujumbe.',
        categoryLabel: 'Nafaka',
        type: 'ushauri',
        imageAsset: '$_img/cereals.jpg',
        likes: 37,
        comments: [
          CommunityComment(
            id: 'c4-1',
            author: 'Chama cha Wakulima Iringa',
            role: 'Ushirika · Iringa',
            timeAgo: 'Jana',
            text: 'Tunaweza kujadili. Tutakutafuta kwa simu leo mchana.',
          ),
        ],
      ),
      CommunityPost(
        id: 'c5',
        author: 'Neema Mushi',
        role: 'Mfugaji wa kuku · Morogoro',
        location: 'Mvomero',
        timeAgo: 'Siku 2 zilizopita',
        content:
            'Nimeanza kutumia daftari dogo la kumbukumbu ya chakula, chanjo na mayai kwa kila kundi. Sasa najua kuku gani wanazalisha faida na wapi napoteza pesa. Napendekeza kila mfugaji aanze.',
        categoryLabel: 'Ufugaji wa Kuku',
        type: 'mafanikio',
        likes: 58,
        comments: [
          CommunityComment(
            id: 'c5-1',
            author: 'Hamisi Ally',
            role: 'Mfugaji · Pwani',
            timeAgo: 'Siku 1 iliyopita',
            text: 'Wazo zuri. Unaweza kushiriki muundo wa daftari lako?',
          ),
        ],
      ),
    ];
