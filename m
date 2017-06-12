From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 22:16:26 +0000
Message-ID: <VI1PR0502MB30088258D7BADC83B0609F38D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <VI1PR0502MB3008478FC7C70D1F398FE2B2D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612162917.GA11993@obsidianresearch.com>
 <VI1PR0502MB3008EA451DA9ECEBECE27362D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612164343.GA12435@obsidianresearch.com>
 <VI1PR0502MB300831A1560531E67B29589DD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612165536.GB12435@obsidianresearch.com>
 <6747e257-67b0-a364-be21-04f73ef82ffe@talpey.com>
 <VI1PR0502MB30080B672B80836FF0A328DCD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612214135.GB30578@obsidianresearch.com>
 <VI1PR0502MB30087762738A4E02A1DA24D0D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612220730.GA32510@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612220730.GA32510-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, June 12, 2017 5:08 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>; Bart Van Assche
> <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Mon, Jun 12, 2017 at 09:59:22PM +0000, Parav Pandit wrote:
> > Hi Jason,
> >
> > > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > > Sent: Monday, June 12, 2017 4:42 PM
> > > To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>; Bart Van Assche
> > > <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Subject: Re: [PATCH rdma-next 0/3] Support out of order data
> > > placement
> > >
> > > On Mon, Jun 12, 2017 at 09:32:30PM +0000, Parav Pandit wrote:
> > >
> > > > There can be cases in deployment where responder has support for
> > > > receiving out-of-order, but requester doesn't.  Read responses
> > >
> > > You still haven't explained at all what the transmitter side does
> differently..
> >
> > Let's say
> > Read-1
> > Read-2 are issued by requester.
> >
> > For some reason read response for each read arrived via different path
> > to requester, If ooo is enabled on a QP they will be processed
> > correctly. Else read responses for 2nd read could be dropped.
>=20
> This is still only discussing the reciever side of a QP.
>=20
> > transmitter of read responder is different when ooo is enabled.
>=20
> And I keep asking you to explain what is different about the transmitter
> side.
Above sequence explains read_response_transmitter behavior.
I will check with hardware team if there is anything done differently at wr=
ite_transmitter (requester) other than what I explained above.

>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
