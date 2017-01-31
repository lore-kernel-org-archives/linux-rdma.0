From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Need to set if_index in ib_init_ah_from_wc() ?
Date: Tue, 31 Jan 2017 01:57:29 +0000
Message-ID: <VI1PR0502MB300870D9CA34D68FDE6F57D8D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com>
 <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130221437.GA28117@obsidianresearch.com>
 <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170131005340.GA30809@obsidianresearch.com>
 <20170131014941.GA15387@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170131014941.GA15387-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

I will go through the posts.

Parav

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, January 30, 2017 7:50 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
>=20
> On Mon, Jan 30, 2017 at 05:53:40PM -0700, Jason Gunthorpe wrote:
>=20
> > In IB the matching GID table entry is placed in wc.sgid_index.
> >
> > I argued that rocee should do the same, but since mlx didn't implement
> > this in hardware they didn't want to take the performance cost when
> > building the WC.
>=20
> Sorry, I realized this reads confusingly after the fact - the argument wa=
s
> about adding a wc.gid_index - IB unambigously open-codes computing
> wc.gid_index ..
>=20
> I think you should review the thread starting here:
>=20
> http://www.spinics.net/lists/linux-rdma/msg30976.html
>=20
> Which is what caused this broken route lookup to be implemented in the fi=
rst
> place.
>=20
> And here is my first suggestion on how to fix it up:
>=20
> http://www.spinics.net/lists/linux-rdma/msg31118.html
>=20
> The fact the fundamental problems I raised during the review were not
> properly addressed is what is causing these problems and confusion now.
>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
