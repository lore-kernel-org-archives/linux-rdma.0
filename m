From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 16/16] IB/ipoib: Fix for potential no-carrier
 state
Date: Fri, 26 Jan 2018 12:00:11 -0500
Message-ID: <1516986011.27592.207.camel@redhat.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
         <20180126143323.6868.89162.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-/VQrhUabGTxQt9ACcsGm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126143323.6868.89162.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-/VQrhUabGTxQt9ACcsGm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-26 at 06:33 -0800, Dennis Dalessandro wrote:
> From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> On reboot SM can program port pkey table before ipoib registered its
> event handler, which could result in missing pkey event and leave root
> interface with initial pkey value from index 0.
>=20
> Since OPA port starts with invalid pkey in index 0, root interface will
> fail to initialize and stay down with no-carrier flag.
>=20
> For IB ipoib interface may end up with pkey different from value
> opensm put in pkey table idx 0, resulting in connectivity issues
> (different mcast groups, for example).
>=20
> Close the window by calling event handler after registration
> to make sure ipoib pkey is in sync with port pkey table.
>=20
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_main.c
> index 5930c7d..161ba8c 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -2306,6 +2306,9 @@ void ipoib_set_dev_features(struct ipoib_dev_priv *=
priv, struct ib_device *hca)
>  			      priv->ca, ipoib_event);
>  	ib_register_event_handler(&priv->event_handler);
> =20
> +	/* call event handler to ensure pkey in sync */
> +	queue_work(ipoib_workqueue, &priv->flush_heavy);
> +

This seems like a bit of a sledgehammer to the issue.  Looking through
ipoib_add_port(), the real race is that we have to call ib_query_pkey()
early in the init sequence as some of the later steps need it to be set
(ipoib_dev_init() must have it already set for one), but since we don't
setup our event handler until after we've finished setting up the
device, there is that window from our first ib_query_pkey call until we
complete the ib_register_event_handler() call for the pkey to change.=20
Instead of throwing the flush regardless, it might be nicer to do:

	{
		u16 new_pkey;

		ib_query_pkey(hca, port, 0, &new_pkey);
		if (priv->pkey !=3D (new_pkey | 0x8000))
			/* The pkey changed between when we
			 * read it and now, flush the device
			 */
			queue_work(ipoib_workqueue, &priv->flush_heavy);
	}

>  	result =3D register_netdev(priv->dev);
>  	if (result) {
>  		pr_warn("%s: couldn't register ipoib port %d; error %d\n",
>=20

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-/VQrhUabGTxQt9ACcsGm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlprXpsACgkQuCajMw5X
L90zxA//VvfHoJsaidrPV6eh68Q2LyJY22+F0Oxt0sZ2MtVI+fVv1HQzuN5wOf82
i5aHRLQu7yTeEVBDmIKlkzbAYtgW438qgdIR755oavWU/kKcmtgFeNUj1eklelXl
gM1aOSbVyxsJBrVUUjttrpniDjVNlN8DnaoMDirGZlGnRo2WFc25aGmSZl7USecE
UGHXaPiD5DnbplI9h/pzlc90T9grLtmGW5+WiDVCYFS5bZoUQQVfij2r8f0Qg8DD
sAJ4LWmSYVTfw6vdUuxLRju3JS8T1cYavWsOFHn/LtdQxBd+tS4lj8qYU3PGAkrw
biWGpVeLejfMhdNKbEZogYPYApTBGrG6dzcitP11HYpRYo8XXYotsJtqY+64Id5Z
2f5KkeF3VDLo28kL4LthDP9+yhBoBLn+ZMSee0N2A7lds3yt4alnk9q8YmRtNapW
jenpg7hjfbK/bf0fkhCnkjCbV9IMrXA51RhC9ibKKS3sNMlIJFlcBxHFkpWDYX73
UKgEg3caUQztw098vh6H6c0CDEbcWXKD/+6iyR6QvLtPb9g4WKcj5cgGs9pAcCDv
jVQsgvy1xW+HxBB2hSDgvPkXA1B0hpZi8qsI/oC9XiqAaEX5Whzh6cFWzO5rtVVE
NlIsWvTq/zWL4nlUqbgwTe6Xm/6wBud2VTT3IfNX15vA0Ypd3LE=
=bZy+
-----END PGP SIGNATURE-----

--=-/VQrhUabGTxQt9ACcsGm--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
