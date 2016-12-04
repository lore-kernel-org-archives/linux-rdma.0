From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Sun, 4 Dec 2016 20:38:14 +0000
Message-ID: <HE1PR0501MB2812393A0A690DEC1E03DE3FB1800@HE1PR0501MB2812.eurprd05.prod.outlook.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-2-git-send-email-leon@kernel.org>
 <20161128170056.GC28381@obsidianresearch.com>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
 <cfdf28c6-4715-28d4-7da6-453fb6794c29@redhat.com>
 <5927e04b-42ec-52c1-88a3-456cc4409334@talpey.com>
 <HE1PR0501MB28124286F8D902C49596EF85B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161130163949.GC24639@obsidianresearch.com>
 <HE1PR0501MB28128CDB112558C5980CB638B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161130170830.GA17512@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA190@ORSMSX109.amr.corp.intel.com>
 <01e501d24b2e$ff2a3260$fd7e9720$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA1B7@ORSMSX109.amr.corp.intel.com>
 <d4bab4a9-aa32-282f-b501-ecfc00b0be0f@talpey.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA68E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0BA68E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean

>=20
> > I'd agree that the application picks the protocol, but I'd also argue
> > that the API should have a "wildcard" mode which allows the current
> > behavior. It could be a simple extension to just add a selector
> > parameter.
>=20
> I agree.  The QP type can be viewed as the socket type, we only need to a=
dd a
> protocol field to go along with it.  I.e. the protocol should be a qp att=
ribute
> provided on input to qp create.
>=20

Right.

> > The tricky part is what to do with passive endpoints. If a wildcard is
> > specified, should a multiprotocol adapter create listens on all
> > protocols? Also, what of protocols which auto-negotiate? It's my
> > understanding that some RoCE adapters will attempt to autodetect
> > whether their peer is RoCEv1 or RoCEv2 capable, and adjust their
> > protocol to suit.
>=20
> We could include the protocol selection, also with wildcard support, here=
 as
> well.  The rdma cm may be able to handle this, so that drivers won't need=
 to deal
> with a wildcard endpoint.  Assuming that we don't end up with some device=
s
> that require they implement wildcard support, while others can't...

Typically, the application will request the protocol that it wants or leave=
 it unspecified.
In that case, I think that the rdmacm would select the device default.

Anyway, returning to the initial matter at hand: I would like to start with=
 each port reporting a bit mask of the supported protocols on that link (Ro=
CE v1/v2, Raw Ethernet, iWARP, etc.)
It will be used for reporting device capabilities in general for tools, as =
well as by applications that don't use rdmacm.
--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
