From: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCHv1] net-next: treewide use is_vlan_dev() helper function.
Date: Mon, 6 Feb 2017 21:21:00 +0000
Message-ID: <BLUPR03MB1412D00046029D435FA40365CA400__31857.4472018101$1486416100$gmane$org@BLUPR03MB1412.namprd03.prod.outlook.com>
References: <1486227649-12648-1-git-send-email-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486227649-12648-1-git-send-email-parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "santosh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <santosh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "manish.chopra-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <manish.chopra-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "rahul.verma-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rahul.verma-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Dept-GELinuxNICDev-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Dept-GELinuxNICDev-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "harish.patil-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <harish.patil-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, KY Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org" <QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Parav Pandit [mailto:parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Saturday, February 4, 2017 12:01 PM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; santosh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org;
> ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; manish.chopra-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org; rahul.verma-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org;
> Dept-GELinuxNICDev-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org; harish.patil-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org; KY Srinivasan
> <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Stephen
> Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org;
> jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org; martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> arvid.brodin-SVm98a2vdck@public.gmane.org; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org;
> bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; arnd-r2nGTMty4D4@public.gmane.org;
> weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; jmaxwell37-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; varun-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org;
> jbenc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; fcoe-
> devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
> Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: [PATCHv1] net-next: treewide use is_vlan_dev() helper function.
>=20
> This patch makes use of is_vlan_dev() function instead of flag
> comparison which is exactly done by is_vlan_dev() helper function.
>=20
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


For drivers/net/hyperv/netvsc_drv.c
Acked-by: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>


Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
