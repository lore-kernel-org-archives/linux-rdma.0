From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RDMA/qedr Add iWARP support for QL4xxxx
Date: Tue, 4 Jul 2017 12:27:20 +0000
Message-ID: <DM2PR0701MB1392BDAD991B797D7BDCA19188D70@DM2PR0701MB1392.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,=20

I want to submit our patch series that adds iWARP support to our QL4xxxx ne=
tworking adapters.

The first 6 patches of this series were previously sent as an RFC (patches =
13-18):
https://www.spinics.net/lists/linux-rdma/msg51416.html
The qed part of the RFC has already been applied to net-next:
https://www.spinics.net/lists/netdev/msg443224.html

This series requires merging net-next to obtain all qed/qede changes which =
were made for supporting iWARP.
It is not applicable without. This series was tested and built against:
git://github.com/dledford/linux.git, branch: k.o/for-4.13 after merging net=
-next into the branch

In addition, we have several pending patches that have not been accepted ye=
t.

https://patchwork.kernel.org/patch/9752761/
https://patchwork.kernel.org/patch/9810023/
https://patchwork.kernel.org/patch/9810025/
https://patchwork.kernel.org/patch/9810027/

We would like to prioritize iWARP submission. Could you please advise on ho=
w you would like us to submit the series:=20
On top of the outstanding patches?=20
Submit a new series that includes these patches and replaces the previous o=
nes?=20
Would you like to merge net-next before we provide the series?=20

Once this series is accepted we have one more patch for qed (net) that does=
 the iWARP enablement,
which is the last in the series, can this be added to the series and submit=
ted via the rdma tree?=20

Thanks,
Michal




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
