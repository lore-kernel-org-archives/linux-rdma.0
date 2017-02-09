From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Need to set if_index in ib_init_ah_from_wc() ?
Date: Thu, 9 Feb 2017 00:00:09 +0000
Message-ID: <VI1PR0502MB3008417F3E388B617291147CD1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com>
 <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130221437.GA28117@obsidianresearch.com>
 <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170131005340.GA30809@obsidianresearch.com>
 <CAAKD3BDbkFHbCi+gHyCXCGV2xi5E9FA+KgwKz+6dBJEtsV0ZkQ@mail.gmail.com>
 <20170208174040.GC30720@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208174040.GC30720-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, February 8, 2017 11:41 AM
> To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Roland Dreier
> <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak
> <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
>=20
> On Wed, Feb 08, 2017 at 06:02:44PM +0200, Matan Barak wrote:
>=20
> > Actually, I think one of the problems here is that we insert GIDs
> > which aren't supported by the hardware.
>=20
> That certainly sounds like a problem, yes.
>=20
> > So, assuming we only insert a combination of netdevices which could be
> > actually described by the hardware, we could try to match these
> > attributes in the gid cache table.  Once we have such a match, we
> > could verify that with the ingress route (actually, we could use
> > ingress route starting from get_netdev() as well).
>=20
> Yes, that is the proper thing to do.
>=20
> Presumably the hardware does this, it should not be receiving packets tha=
t
> do not match the GID table. That would be a huge problem when we talk
> about namespaces/etc.
>=20
> > Since RoCE is symmetrical (you don't know if an AH is for rx/tx in UD
> > and you need to select a single sgid_index for RC connections), we
> > need to verify that it matches an egress route bounded to this
> > netdevice.
>=20
> ?? how is an AH involved in RX?
>=20
> > As a quick fix, setting ifindex to get_netdev's ifindex in link local
> > addresses and filter out unsupported netdevices in the GID cache,
> > seems like a reasonable solution to me.
>=20
> That still breaks link local addresses on vlan devices, so it is an ugly =
hack, not a
> solution.

In presence of vlan, shouldn't we be passing the ifindex of the vlan netdev=
?


>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
