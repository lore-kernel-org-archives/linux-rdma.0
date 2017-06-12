From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 17:11:09 +0000
Message-ID: <VI1PR0502MB30089EDC828A142338B1EE06D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <1497281280.2770.1.camel@wdc.com>
 <VI1PR0502MB3008478FC7C70D1F398FE2B2D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612162917.GA11993@obsidianresearch.com>
 <VI1PR0502MB3008EA451DA9ECEBECE27362D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612164343.GA12435@obsidianresearch.com>
 <VI1PR0502MB300831A1560531E67B29589DD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612165536.GB12435@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612165536.GB12435-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, June 12, 2017 11:56 AM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
> <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Mon, Jun 12, 2017 at 04:53:28PM +0000, Parav Pandit wrote:
> >
> >
> > > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > > Sent: Monday, June 12, 2017 11:44 AM
> > > To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> > > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
> > > <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Subject: Re: [PATCH rdma-next 0/3] Support out of order data
> > > placement
> > >
> > > On Mon, Jun 12, 2017 at 04:42:27PM +0000, Parav Pandit wrote:
> > >
> > > > > I would suggest at least using the inverted sense like Bart
> > > > > describes in the kernel - every kernel ULP is safe.
> > >
> > > > I don't see a need to use inverted sense in code. I can surely
> > > > make
> > > documentation more descriptive as Bart suggested.
> > >
> > > If this is 'better' then it should be on as much as possible, and I
> > > certianly don't want to see kernel ULPs query caps and other
> > > pointless things when they already, necessarily, deal with out of ord=
er.
> >
> > Sure. Kernel ULPs and any other user ULPs can skip query caps.
>=20
As you know - capable doesn't mean enabled in query_cap.

> No, they can't because only mlx5 accepts the new flag.
>=20
By default out-of-order processing of RDMA write packets is disabled even o=
n mlx5 for all QPs.
When user requests it to enable during modify_qp() as described in Document=
ation/out_of_order.txt usage section 3, HCA will process it that way.

> This is why inverting the flag in the kernel makes much more sense.
When you say invert the flag, which flag do you mean?
Capability flag or QP attribute?
Capability flag indicates - whether out-of-order processing at RDMA level s=
upported or not.
QP attribute indicates - to enable such ooo processing for a particular QP.

Let's not mix PCIe write ordering with RDMA level out-of-order processing.
IB spec clearly says, as I reiterated in the Documentation/out_of_order.txt=
 - that application should not depend on the write data until write_with_im=
m arrives or subsequent rdma send arrives at responder side.
If some MPI or other application have taken shortcut based on some platform=
, they have to help themselves. This path is not intent to address such iss=
ue.

>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
