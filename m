From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/core: Add inline function to validate port
Date: Thu, 26 Jan 2017 14:59:56 +0200
Message-ID: <20170126125956.GW6005@mtr-leonro.local>
References: <1485362497-18723-1-git-send-email-yuval.shaia@oracle.com>
 <20170125165022.GQ6005@mtr-leonro.local>
 <20170126081534.GC3939@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qa1NXTiqN6KSzHv0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170126081534.GC3939-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qa1NXTiqN6KSzHv0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2017 at 10:15:35AM +0200, Yuval Shaia wrote:
> On Wed, Jan 25, 2017 at 06:50:22PM +0200, Leon Romanovsky wrote:
> > On Wed, Jan 25, 2017 at 06:41:37PM +0200, Yuval Shaia wrote:
> > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/cache.c  | 18 ++++++++----------
> > >  drivers/infiniband/core/cma.c    |  6 ++----
> > >  drivers/infiniband/core/device.c |  4 ++--
> > >  drivers/infiniband/core/verbs.c  |  3 +--
> > >  include/rdma/ib_verbs.h          |  7 +++++++
> > >  5 files changed, 20 insertions(+), 18 deletions(-)
> >
> > Nice change, however all places are pretended with "!".
> > Can we change the name of function to something like
> > "rdma_is_port_invalid"?
>
> As a matter of fact this thought cross my mind as usually callers cares more
> about 'invalid port' and not 'valid port' because it is used as exit criteria
> from a function. But as Bart mentioned in other reply, positive looks
> better that negative.

I'm fine with both options.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--qa1NXTiqN6KSzHv0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliJ8swACgkQ5GN7iDZy
WKdGlw/9FO63Q/JDpGgj7E5IrDUIGcIE0YilmSK6xgBZiGBcN/aojutSYbs4rog5
gcCC/p5By4GWH6op9ifect3I0QjdzXeSaF1j3EdQGer2Y3LgwlkVgD0srh43/6aJ
nz0esWNml58m1HUOF4ZxNDV705a2letRG6NWlNf3T/Vto2/v8PJ8YRyqAAzngoWt
TBVwGa2t6QJzL9vrfEK3AQOdoyGXXjfiyXJBhSrAAb4rtAjKJvgrN6iEo9WG4znG
Sy0TZM6+U23k6uW4NSwqR/K7tdM4M93Dms1v1GWKZyB6T+84g07AK9Woi4IAdXfT
hQ3yeAqKtMhz2AQDXQYGQN9L6WNGoeo3VvvhQoNTtnlahMQFXOw2Eciz40eFuMC7
3ntASCLImVlITW9f+QiULfMsr5WEeewvyXIvdZjaJVP+55jehykFX8hzBzAV19N5
KZ/Zi2HX73EfWEJNFhmyPouYdajFzXesSq0TDa0Z9c7Y07ahySJmoHsHW5tCs7gn
dMUu7BJrZYV2Ls/ckmeSpivLXGO5pJb/SR193UehhdNf5UXpu/3+tWBRIjY06UbV
gZDjsKMO412mhtHoyHmgwmDRFRC/JCRELjAD0bKaEDE9uQuC9cbL2wyuPyxJt6YC
Mj+J7yL57g7tGI3+n6NzFw0iODx5j0V86R0+8rALFAWMm5pv7xc=
=vAaH
-----END PGP SIGNATURE-----

--qa1NXTiqN6KSzHv0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
