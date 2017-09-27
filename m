From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 03/10] verbs: Split init_device into a match
 and alloc/bind step
Date: Wed, 27 Sep 2017 10:55:52 +0300
Message-ID: <20170927075552.GC2297@mtr-leonro.local>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <5a30e4a3-e22c-5d1a-435d-d3c5d94333fd@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5a30e4a3-e22c-5d1a-435d-d3c5d94333fd-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 07:00:16PM +0300, Yishai Hadas wrote:
> On 9/20/2017 12:18 AM, Jason Gunthorpe wrote:
> > The match step determines if the provider should bind to the sysfs device,
> > and the allocation step creates the verbs_device and cleanly matches the
> > uninit_device step which frees it.
> >
> > This split makes it simpler to factor out all the duplicated code in the
> > match step.
> >
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > ---
> >   libibverbs/driver.h | 21 ++++++++++++++-
> >   libibverbs/init.c   | 74 ++++++++++++++++++++++++++++++++++-------------------
> >   2 files changed, 68 insertions(+), 27 deletions(-)
> >
> > diff --git a/libibverbs/driver.h b/libibverbs/driver.h
> > index f9f5cfa2308c2f..397441f49a0e5a 100644
> > --- a/libibverbs/driver.h
> > +++ b/libibverbs/driver.h
> > @@ -40,6 +40,7 @@
> >   #include <infiniband/kern-abi.h>
> >   #include <ccan/list.h>
> >   #include <config.h>
> > +#include <stdbool.h>
> >   #ifdef __cplusplus
> >   #  define BEGIN_C_DECLS extern "C" {
> > @@ -95,10 +96,27 @@ struct verbs_qp {
> >   	struct verbs_xrcd       *xrcd;
> >   };
> > +/* A rdma device detected in sysfs */
> > +struct verbs_sysfs_dev {
> > +	struct list_node entry;
> > +	void *provider_data;
>
> It looks as this field isn't used in the series, correct ? if this is the
> case better add when it'll become applicable.

Yishai,

Jason is a little bit overwhelmed now and because this series was posted
long time here and got a lot of Acked-by tags, I would be happy to take it
and move forward. Do you see any issues which he can't fix after this
series merged?

Thanks

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnLWYgACgkQ5GN7iDZy
WKft6w//VFYFvxrnuF1lqFP8+37NgnZ3psmTLdv658RjW/7bB/O/PuwO8Xk0ecgb
k5Cj+n6E/pwgJNxLntcAuP9Mh2KfzenXI/Fok9xOezpzt0yQgPT3gC0stP9Kpw0p
a2aChzlHtzSrpDH+wVljyereH/lDcMHbaOwayyTXs/onYkwijWLgYor0HTLfJiqm
g5pTPIbM05FDmAK1zYPSQahs9oPD0qNfd+uXfzkZ6WyikjNRJBw52sxUKoSe87dC
I7hPbzEwGELD/00YgcjhMOX7M+U4WLuhOiRpSBI09M4+wvEoKQIX3p29R6ODRtVC
WTbSXkDX1NC5ZdVgBBhIWTK4Kz42IttxCBKn7k3zSLgyVRqxkVx9Sl2zbdpteF+q
ih+R2zuo2KqHMfqvyPC7o3YqFMlZvcxOteFLDVHE16uD+Itz43+WEHt23fS5zFyj
XgGip4BlBMrJ5IRfqLENNFSX6xNklC8GoBe4rh6a6T/NphIhhVPyZstmJzR0eXZZ
v6ZE63S/ncYYpaYKy3170Wj3va+F/9mofF4z0b6iG0b6d3J9bkRSfQ2SBOYHUzqM
d8yVbwqztHqoFKEHC8TPM7GDikV3/dZ664qyi8QlsPb2XWMZTNe2oYffQYKEw4U7
sK/yN2osG8mPlPD88Vo4LU8TNyCZSEv6forek15yopJh8kOVDc0=
=chIa
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
