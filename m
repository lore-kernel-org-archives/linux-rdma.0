From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Thu, 20 Jul 2017 15:06:20 +0000
Message-ID: <VI1PR0502MB30084850CF0B14D4E43CF0E2D1A70@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <6747e257-67b0-a364-be21-04f73ef82ffe@talpey.com>
 <VI1PR0502MB30080B672B80836FF0A328DCD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <475e1873-e842-ecb9-d260-34777da57e51@talpey.com>
 <VI1PR0502MB3008B7FE60CAB3BD49907A1BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <d3a436a0-9ace-b11a-2e4c-387fc575877e@talpey.com>
 <VI1PR0502MB3008E04612EED6BC83F37115D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fbdcf05b-ccd8-bd9c-c9c8-86f373303250@talpey.com>
 <VI1PR0502MB30089271EB542493AA58060CD1C20@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fb11f261-b80b-f71a-8076-204706267798@talpey.com>
 <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170719171211.GB25714@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170719171211.GB25714-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, July 19, 2017 12:12 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>; Bart Van Assche
> <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Wed, Jul 19, 2017 at 05:33:52AM +0000, Parav Pandit wrote:
>=20
> > It does guarantee that writes don't bypass writes and reads don't bypas=
s reads
> (Table 79), and transport operations are executed in their *message* orde=
r (C9-
> 28):
> > "A responder shall execute SEND requests, RDMA WRITE requests and
> > ATOMIC Operation requests in the message order in which they are
> > received."
>=20
> At a minimum, you need to include a version of table 79 in your documenta=
tion
> that reflects the modified WR ordering rules for this mode,=20
Sure. In fact I had it in internal version before posting upstream, but dro=
pped for some reason.
I will add it in v1.

> and I'm not sure we
> should continue to call this thing a 'RC QP'
1. None of the Reliability property is affected with this optional attribut=
e. So it is still RC QP.

> at all to avoid so much confusion.
All this details we discussed our email will be described in documentation =
v1 to avoid confusion.

> I recommend you rework this patch series to introduce a relaxed RC QP typ=
e
> instead of using a flag..
Additionally,
2. It doesn't make sense to introduce 3 more relaxed QP type (RC, XRC initi=
ator, target) for one common attribute among them.
3. New QP type makes it more difficult or impossible to make rdmacm work in=
 future.
Active side creates the QP and shared parameters through REQ-RSP messages.
Such existing interface would just become impossible to make use of.
This attribute is similar to MTU, IRD/ORD etc.
I prefer to keep it as optional QP attribute that brings simplicity and it =
is extendible compare to new QP type.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
