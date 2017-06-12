From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 17:28:00 +0000
Message-ID: <VI1PR0502MB3008304F8465C19ACCFF3D68D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <1497281280.2770.1.camel@wdc.com>
 <VI1PR0502MB3008478FC7C70D1F398FE2B2D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612162917.GA11993@obsidianresearch.com>
 <VI1PR0502MB3008EA451DA9ECEBECE27362D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612164343.GA12435@obsidianresearch.com>
 <VI1PR0502MB300831A1560531E67B29589DD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612165536.GB12435@obsidianresearch.com>
 <VI1PR0502MB30089EDC828A142338B1EE06D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612171436.GA12739@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612171436.GA12739-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, June 12, 2017 12:15 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
> <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Mon, Jun 12, 2017 at 05:11:09PM +0000, Parav Pandit wrote:
>=20
> > > This is why inverting the flag in the kernel makes much more sense.
> > When you say invert the flag, which flag do you mean?
> > Capability flag or QP attribute?
>=20
> QP attribute.
>=20
> > Let's not mix PCIe write ordering with RDMA level out-of-order
> > processing.  IB spec clearly says, as I reiterated in the
> > Documentation/out_of_order.txt - that application should not depend on
> > the write data until write_with_imm arrives or subsequent rdma send
> > arrives at responder side.  If some MPI or other application have
> > taken shortcut based on some platform, they have to help themselves.
> > This path is not intent to address such issue.
>=20
> Exactly - all spec conformant ULPs are compatible with enabling this new
> function of mlx5.
>=20
This per QP attribute is for read and write both. So responder can receive =
out-of-order read responses.
And HCA's QP need to be told to accept it that way, which by default doesn'=
t.

> There is no reason to add a flag at all, except to retain compatibility w=
ith
> certain non-confomant ULPs. We have none of those in the kernel, so kerne=
l
> QPs should always have the flag on.
>=20
ULP can be conformant, but it may not be the same HCA on both requester and=
 responder side which has this feature.
So requester or responder cannot assume what other side have enabled.
Therefore the need to be explicit enable flag.

As I explained, by default HCA doesn't process out-of-order packets. User n=
eed to tell him to do so.
For example adapter is capable of 16 incoming read requests, but when modif=
y_qp() happens, user need to tell how many incoming outstanding read reques=
ts it should accept.
Same for outgoing read requests. Etc.


> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
