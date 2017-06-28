From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Add wait/retry version of ibnl_unicast
Date: Wed, 28 Jun 2017 18:36:39 +0300
Message-ID: <20170628153639.GF1248@mtr-leonro.local>
References: <1498658565-3408-1-git-send-email-mustafa.ismail@intel.com>
 <20170628141211.GA16312@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sAD49wDt4u2G8n56"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628141211.GA16312-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--sAD49wDt4u2G8n56
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 09:12:11AM -0500, Chien Tin Tung wrote:
> On Wed, Jun 28, 2017 at 09:02:45AM -0500, Mustafa Ismail wrote:
> > Add a wait/retry version of ibnl_unicast, ibnl_unicast_wait,
> > and modify ibnl_unicast to not wait/retry.  This eliminates
> > the undesirable wait for future users of ibnl_unicast.
> >
> > Change Portmapper calls originating from kernel to user-space
> > to use ibnl_unicast_wait and take advantage of the wait/retry
> > logic in netlink_unicast.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/iwpm_msg.c |  6 +++---
> >  drivers/infiniband/core/netlink.c  | 12 +++++++++++-
> >  include/rdma/rdma_netlink.h        | 10 ++++++++++
> >  3 files changed, 24 insertions(+), 4 deletions(-)
>
> Please apply this patch instead of Leon's patch to revert
> "IB/core: Add flow control to the portmapper netlink calls".
>
> Leon, we can work out names and parameters if this works for you.

Chien,

The names are less my worries with this patch. First of all, it misleads
by using wait/retry naming, because it blocks and not waits. The second,
I disagree with solution in kernel for user space application which can't
handle the netlink errors. Can you please explain why the kernel fix is
unavoidable and the bug in the user space application is not needed to
be fixed?

Thanks

>
> Chien

--sAD49wDt4u2G8n56
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllTzQcACgkQ5GN7iDZy
WKePpg//U1UxWvHKkFa4e1JrlMbijRtmDeQIS+vomHWfKP1o9HHGzn76LChydo+y
Z8kBuyYFMeczbY3Vsyx84Ijqe6GCS3YWhRrRbvw2QEon7Ey/fiQop0pwhHxA9n37
qgd/lbfRyQfPFFSIqooNX+z+9kTmeNnmexYfyAjGoHGapeTJeNsurjxaiYXQi2i1
bxvd3GflOda6P2OQh37AGECykAvThyGQ8ldoN2fyV6w2ismAK98h0nBV1n05G7nJ
6DqHxiS7tCmroIBwFBlc0Hi81dUr76lxFIl4gIIxD4kdW0nx8EqRFmOYDSVlI7Fq
vl45sU9Om2lmtNMN/6dsDNVQ4F46Pxhb4z9lJHpiZHGvVwDR9ZPAnYXbEY25M4oP
sZ4yV3wgrcvIW3MZfaAemadtdj9C3OMk38kR/yv/RVJChGUfieAqWwPeH16drPE+
UsdezmgP1GgCAC/LIijslm/Gqw4hKINpTAKaO3fK3sQM+fc86+2C+ylIlYR73Kv8
MRQJa9SPiNiGurjqqkIvfABruzGAR5FAeEL75ey1reJel+/pO4ZE8ZhAPeRxqTQX
wW7QW37bQNLNP4n+FBXaFN/eeGcdYEqPqe/zmagSM3dnwBoJl8xcq/1tdaAIm7c7
hII8P3LuDhNYlON66nR9gET5W7sZnVJPb2XTxe9F+VsiHSTUtAw=
=Lddl
-----END PGP SIGNATURE-----

--sAD49wDt4u2G8n56--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
