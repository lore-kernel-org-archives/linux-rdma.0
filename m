From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-rc 5/7] Revert "IB/ipoib: Update broadcast object if
 PKey value was changed in index 0"
Date: Tue, 26 Sep 2017 19:27:29 +0300
Message-ID: <20170926162729.GG6816@mtr-leonro.local>
References: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
 <20170926130620.31476.82301.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kjpMrWxdCilgNbo1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926130620.31476.82301.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--kjpMrWxdCilgNbo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 26, 2017 at 06:06:22AM -0700, Dennis Dalessandro wrote:
> From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> commit 9a9b8112699d will cause core to fail UD QP from being destroyed
> on ipoib unload, therefore cause resources leakage.
> On pkey change event above patch modifies mgid before calling underlying
> driver to detach it from QP. Drivers' detach_mcast() will fail to find
> modified mgid it was never given to attach in a first place.
> Core qp->usecnt will never go down, so ib_destroy_qp() will fail.
>
> IPoIB driver actually does take care of new broadcast mgid based on new
> pkey by destroying an old mcast object in ipoib_mcast_dev_flush())
> ....
> 	if (priv->broadcast) {
> 		rb_erase(&priv->broadcast->rb_node, &priv->multicast_tree);
> 		list_add_tail(&priv->broadcast->list, &remove_list);
> 		priv->broadcast =3D NULL;
> 	}
> ...
>
> then in restarted ipoib_macst_join_task() creating a new broadcast mcast
> object, sending join request and on completion tells the driver to attach
> to reinitialized QP:
> ...
> if (!priv->broadcast) {
> ...
> 	broadcast =3D ipoib_mcast_alloc(dev, 0);
> ...
> 	memcpy(broadcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
> 	       sizeof (union ib_gid));
> 	priv->broadcast =3D broadcast;
> ...
>
> Fixes: 9a9b8112699d ("IB/ipoib: Update broadcast object if PKey value was=
 changed in index 0")
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
>

I consulted with Feras about it and it is his reply.

=46rom Feras:
After applying the patch in question, the following scenario may happens:

    PKEY change event occurs, it calls update_parent_pkey (which updates th=
e device and the priv broadcast)
    and then brings the device down. The flow of taking the device down flu=
shes the multicast groups and
    the broadcast group. Since the patch changes the broadcast address, the=
 flow fails to detach from the
    unattached group causing syndrome.

Mistakenly we thought that that patch will fix other issue with VM migratio=
ns when pkey change in index 0,
in this case the interface state was down so we did not hit this issue.

Anyway, your revert is correct.

Thanks,
Reviewed-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--kjpMrWxdCilgNbo1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnKf+8ACgkQ5GN7iDZy
WKe9HBAAnUQkX0T4v/1wPzfhW9FyA3jtkLRxI2GrqD1/zlN7aA9P0IALwJKhCELk
2LsC3OD5ufi5Mt2oWN9f2m8p+P1RNeL8Fx2ZuTsHXO539Dr74xmtFoeiFMCETOaZ
H4oLw0bMMmJk/0FS6dK6jQU0d/ESZWBNCOCSoAnIIdYneAA/elXWKoC/q85O63fC
KAyMkBZJx6CQiLLLqgB2hhi6Bylv/4mSH9VXzE9R49AO6djy7anPpLW1PKeYigOG
9N/u0Ggz0icdumwNKldS4UeLnojGyQyLD8SmR80Ksx+nYeEARy2kohHgr4YWo2cE
sdfTBUfU7fZ7nwJU3+DGfL+IsDxUSBHWgPTUdDWIKBrjh6ObDT8TLDbNPPh5cuD8
h9kZ+2prBm6Wz7DReJSOoqqKi+WegoauaFreAVi+7GaXUXujo9Vwo2cToJcVvd79
BRdhRq8ZgFbfyMCrChDB4p9GHFugICBE30Om+yRrh3Y8Pto+Rgly8m2lOWg1vhSD
BBw9k/3cd8DAg9Q/HbdUuPfYG+KYK+XM7VbRMVSmUNKewN8hwITSYgPvitR8brM9
Gf71SuergH4L1IIVJFs8Ec+C00I7Hv08dokt3t324G/4T7fjAUPt1Lhawh0Q2nLU
ldbBXYJJ1r16evyyPUbCy/51ehnP5gUEC77CTjXlS/FLxjBdtEM=
=UTwq
-----END PGP SIGNATURE-----

--kjpMrWxdCilgNbo1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
