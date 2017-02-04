From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] net-next: treewide use is_vlan_dev() helper function.
Date: Sat, 4 Feb 2017 16:47:14 +0000
Message-ID: <VI1PR0502MB300889FE34A841AD7C84EAE7D14E0__31654.7424918555$1486226849$gmane$org@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1486182386-50797-1-git-send-email-parav@mellanox.com>
 <1486185045.22276.79.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486185045.22276.79.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "santosh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <santosh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "manish.chopra-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <manish.chopra-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "rahul.verma-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rahul.verma-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Dept-GELinuxNICDev-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Dept-GELinuxNICDev-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "harish.patil-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <harish.patil-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, kys <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org" <QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <jejb@linux.>
List-Id: linux-rdma@vger.kernel.org

Hi Joe,

> -----Original Message-----
> From: Joe Perches [mailto:joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org]
> On Fri, 2017-02-03 at 22:26 -0600, Parav Pandit wrote:
> > This patch makes use of is_vlan_dev() function instead of flag
> > comparison which is exactly done by is_vlan_dev() helper function.
>=20
> Thanks.
>=20
> btw:  after applying this patch, there is one left
>
I am sending v1 to cover it as well.

> $ git grep -E -n "&\s*IFF_802_1Q_VLAN\b" -- "*.c"
> drivers/net/ethernet/chelsio/cxgb4/l2t.c:435:   if (neigh->dev->priv_flag=
s &
> IFF_802_1Q_VLAN)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
