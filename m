From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mthca: Fix how mthca_map_user_db() calls gup
Date: Thu, 25 Jan 2018 11:34:23 -0500
Message-ID: <1516898063.27592.136.camel@redhat.com>
References: <20180123205459.432-1-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-51VuIibPf54zlRZ/lY0I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123205459.432-1-dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-51VuIibPf54zlRZ/lY0I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-23 at 12:54 -0800, Davidlohr Bueso wrote:
> mthca_map_user_db() has two problems regarding the call to
> get_user_pages():
>=20
> (i) It is not done under mmap_sem.
>=20
> (ii) It is done under the db_table mutex, which protects all
> database related operations. Should any of these be called
> under mmap_sem, we get an ABBA deadlock. In addition, gup can
> be performance intensive, which could contend other mapping/
> unmapping ops.
>=20
> To fix this, we can drop the mutex while doing a gup_fast(),
> once done, recheck to see the page was mapped while we didn't
> hold the mutex, and exit out with the corresponding housekeeping.
>=20
> Suggested-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Signed-off-by: Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
> ---
>=20
> - Compile tested only.

Jason and I talked about this offline a bit.  We're concerned about
taking a patch like this into an ancient, unmaintained, but working
driver.  Especially when it's only compile tested.  I have mthca
hardware on hand and I can test it, but in this case, testing your patch
would require triggering a race condition that we really don't have a
way to test.

> - Should I be wrong about no callers already holding mmap_sem,
>   I still think calling gup without the mutex makes sense for
>   improved paralellism. Now, if callers can hold the mmap_sem,
>   it's wrong to do copy_from_user right before calling mthca_map_user_db.

So, if I understand you correctly, we (well, you and Al would be more
correct, we haven't looked into the situation yet, so Mellanox people
that worked on this in the day might now, or someone taking the time to
research it could find out) don't have a clear understanding of all the
conditions this function is called under, and so we actually don't know
what the best way forward is to fix it?

>=20
>  drivers/infiniband/hw/mthca/mthca_memfree.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infini=
band/hw/mthca/mthca_memfree.c
> index c6fe89d79248..046871878a02 100644
> --- a/drivers/infiniband/hw/mthca/mthca_memfree.c
> +++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
> @@ -472,9 +472,27 @@ int mthca_map_user_db(struct mthca_dev *dev, struct =
mthca_uar *uar,
>  		goto out;
>  	}
> =20
> -	ret =3D get_user_pages(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages, NULL);
> +	mutex_unlock(&db_tab->mutex);
> +
> +	ret =3D get_user_pages_fast(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages);
>  	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&db_tab->mutex);
> +
> +	if (db_tab->page[i].refcount >=3D MTHCA_DB_REC_PER_PAGE ||
> +	    (db_tab->page[i].uvirt && db_tab->page[i].uvirt !=3D uaddr)) {
> +		put_page(pages[0]);
> +		ret =3D -EINVAL;
>  		goto out;
> +	}
> +
> +	/* page was already mapped by another task while we were doing gup */
> +	if (db_tab->page[i].refcount) {
> +		put_page(pages[0]);
> +		++db_tab->page[i].refcount;
> +		goto out;
> +	}
> =20
>  	sg_set_page(&db_tab->page[i].mem, pages[0], MTHCA_ICM_PAGE_SIZE,
>  			uaddr & ~PAGE_MASK);

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-51VuIibPf54zlRZ/lY0I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpqBw8ACgkQuCajMw5X
L91p/Q//WH3kmpy7ALnuTsHePayW70IfTG9ipOs5k5+0ixHrVRP3QKqVqzUSI9Xs
YbbodVVCS1fXnCHG5dwV4nRo74KVrX688fTUApS2IJ8SNESKnQl/Fjtzo0gYBSPs
1xNiRMvd2PCjbQqqGBJ0heAx1PT8iWNdoD0wBiBy8siIxWhxp/AipWroeMo3KdhR
AOsfNZZdoU2r8kkY5eFT6cxYSp7FIboE+IQ//OEgPh2HvC76HYDx+F1T3N0ZZ/9o
v5C2/TCwFjemjhvrqZLMETlBTZtgmgEb7NV+KuRAvkfZR+r2DPUjFuqVfWjxx3mN
xmM4ybMMsNyE8/eLywiAhCfkpUlIZZNC4AceoLKcm6AQTDMkWa+PkKCbhRDsRdmw
JkELmtVCfYyj7cDfSmS0Bc7h5ocHz398VECUwcEROq0NH2Du6MUvCfU1UsPoO7ZE
sz3BumX/kdMOjL7AxknXQZxkrcrXSSKQ76Lpo7rylMkGGNvfPgK1JlGymuSaTPZJ
Oj+pcR6S0hs9SpRIn7Ara3QPFmHsI6vAB0GXEZb5HOfbRuosi02UsOFJP7ciM7Bq
poZ4mZxV+gTKluXnbwEAI6X6w1MGu5zTq39SgMDMFift0utakcw06J12+oWBNCOX
+NKC+DbxvTqO7h3BSPZ0o47Rv68YdOk5h6UWLnGa0SEJf05qGtc=
=WT2Y
-----END PGP SIGNATURE-----

--=-51VuIibPf54zlRZ/lY0I--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
