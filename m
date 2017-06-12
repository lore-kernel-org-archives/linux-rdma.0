From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 17:46:34 +0000
Message-ID: <VI1PR0502MB30081FD74492E97043F45BD8D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1497281280.2770.1.camel@wdc.com>
 <VI1PR0502MB3008478FC7C70D1F398FE2B2D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612162917.GA11993@obsidianresearch.com>
 <VI1PR0502MB3008EA451DA9ECEBECE27362D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612164343.GA12435@obsidianresearch.com>
 <VI1PR0502MB300831A1560531E67B29589DD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612165536.GB12435@obsidianresearch.com>
 <VI1PR0502MB30089EDC828A142338B1EE06D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612171436.GA12739@obsidianresearch.com>
 <VI1PR0502MB3008304F8465C19ACCFF3D68D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612173221.GA13302@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612173221.GA13302-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, June 12, 2017 12:32 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
> <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Mon, Jun 12, 2017 at 05:28:00PM +0000, Parav Pandit wrote:
>=20
> > > Exactly - all spec conformant ULPs are compatible with enabling this
> > > new function of mlx5.
>=20
> > This per QP attribute is for read and write both. So responder can rece=
ive
> out-of-order read responses.
> > And HCA's QP need to be told to accept it that way, which by default
> doesn't.
>=20
> I think this one flag is conflating too many things then.
>=20
Too many flags just confuses end-user for read/write/requester/responder et=
c.
Also there isn't well established use case either where user wants to do on=
ly certain things.

> Obviously sending out of order packets is not spec conformant, and I don'=
t
> think your discussion is clear enough, as this change to send side certai=
nly
> was not clear to me.
>=20
Ok. I can make Documentation more elaborate that describe summary of this d=
iscussion + Bart's point.

> I'm not excited about a new end-to-end flag without some kind of
> negotiation scheme, and I'm not excited about this being in any of the
> common APIs.
Many applications do out-of-band negotiation or static configuration and it=
s unrelated to the patchset.
So lack of negotiation shouldn't be issue. Its outside the scope of this ve=
rb extension anyway.

>=20
> Perhaps it should be in libmlx5 instead.

We think that its best usable through ibv_modify_qp because it's really sim=
ple enough and well documented which will address inputs given in this disc=
ussion.

>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
