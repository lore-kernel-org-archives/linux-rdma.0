From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/qib: remove redundant setting of any in for-loop
Date: Fri, 10 Nov 2017 13:00:23 -0500
Message-ID: <1510336823.3735.4.camel@redhat.com>
References: <20171020072103.10337-1-colin.king@canonical.com>
         <1508484951.6806.46.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9xmj2oafcTLVi6PoEyKa"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508484951.6806.46.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Colin King <colin.king@canonical.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-9xmj2oafcTLVi6PoEyKa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-10-20 at 00:35 -0700, Joe Perches wrote:
> On Fri, 2017-10-20 at 09:21 +0200, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >=20
> > The variable all is being set but is never read after this
> > hence it can be removed from the for loop initialization.
> > Cleans up clang warning:
>=20
> any is really used as bool and is initialized at function
> entry.  The earlier loop also reinitializes any unnecessarily.

Denny, can you weigh in on what you want in this thread?  Thanks.

> > drivers/infiniband/hw/qib/qib_file_ops.c:640:7: warning: Value
> > stored to 'any' is never read
> >=20
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infinib=
and/hw/qib/qib_file_ops.c
> > index 2d6a191afec0..b5c2e4223ee7 100644
> > --- a/drivers/infiniband/hw/qib/qib_file_ops.c
> > +++ b/drivers/infiniband/hw/qib/qib_file_ops.c
> > @@ -637,7 +637,7 @@ static int qib_set_part_key(struct qib_ctxtdata *rc=
d, u16 key)
> >  		ret =3D -EBUSY;
> >  		goto bail;
> >  	}
> > -	for (any =3D i =3D 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
> > +	for (i =3D 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
> >  		if (!ppd->pkeys[i] &&
> >  		    atomic_inc_return(&ppd->pkeyrefs[i]) =3D=3D 1) {
> >  			rcd->pkeys[pidx] =3D key;
>=20
> Perhaps the function is better written without
> the empty bail: label and without setting ret
> and just using return.
>=20
> Combining the int/bool conversion of any and the
> direct returns seems clearer to me.
>=20
> Something like:
> ---
>  drivers/infiniband/hw/qib/qib_file_ops.c | 70 ++++++++++++--------------=
------
>  1 file changed, 27 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniban=
d/hw/qib/qib_file_ops.c
> index 2d6a191afec0..8078854e1cd6 100644
> --- a/drivers/infiniband/hw/qib/qib_file_ops.c
> +++ b/drivers/infiniband/hw/qib/qib_file_ops.c
> @@ -568,20 +568,17 @@ static int qib_tid_free(struct qib_ctxtdata *rcd, u=
nsigned subctxt,
>  static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
>  {
>  	struct qib_pportdata *ppd =3D rcd->ppd;
> -	int i, any =3D 0, pidx =3D -1;
> +	int i;
> +	bool any =3D false;
> +	int pidx =3D -1;
>  	u16 lkey =3D key & 0x7FFF;
> -	int ret;
> =20
> -	if (lkey =3D=3D (QIB_DEFAULT_P_KEY & 0x7FFF)) {
> -		/* nothing to do; this key always valid */
> -		ret =3D 0;
> -		goto bail;
> -	}
> +	/* nothing to do; this key always valid */
> +	if (lkey =3D=3D (QIB_DEFAULT_P_KEY & 0x7FFF))
> +		return 0;
> =20
> -	if (!lkey) {
> -		ret =3D -EINVAL;
> -		goto bail;
> -	}
> +	if (!lkey)
> +		return -EINVAL;
> =20
>  	/*
>  	 * Set the full membership bit, because it has to be
> @@ -594,18 +591,15 @@ static int qib_set_part_key(struct qib_ctxtdata *rc=
d, u16 key)
>  	for (i =3D 0; i < ARRAY_SIZE(rcd->pkeys); i++) {
>  		if (!rcd->pkeys[i] && pidx =3D=3D -1)
>  			pidx =3D i;
> -		if (rcd->pkeys[i] =3D=3D key) {
> -			ret =3D -EEXIST;
> -			goto bail;
> -		}
> -	}
> -	if (pidx =3D=3D -1) {
> -		ret =3D -EBUSY;
> -		goto bail;
> +		if (rcd->pkeys[i] =3D=3D key)
> +			return -EEXIST;
>  	}
> -	for (any =3D i =3D 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
> +	if (pidx =3D=3D -1)
> +		return -EBUSY;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
>  		if (!ppd->pkeys[i]) {
> -			any++;
> +			any =3D true;
>  			continue;
>  		}
>  		if (ppd->pkeys[i] =3D=3D key) {
> @@ -613,44 +607,34 @@ static int qib_set_part_key(struct qib_ctxtdata *rc=
d, u16 key)
> =20
>  			if (atomic_inc_return(pkrefs) > 1) {
>  				rcd->pkeys[pidx] =3D key;
> -				ret =3D 0;
> -				goto bail;
> -			} else {
> -				/*
> -				 * lost race, decrement count, catch below
> -				 */
> -				atomic_dec(pkrefs);
> -				any++;
> +				return 0;
>  			}
> +			/* lost race, decrement count, catch below */
> +			atomic_dec(pkrefs);
> +			any =3D true;
>  		}
> -		if ((ppd->pkeys[i] & 0x7FFF) =3D=3D lkey) {
> +		if ((ppd->pkeys[i] & 0x7FFF) =3D=3D lkey)
>  			/*
>  			 * It makes no sense to have both the limited and
>  			 * full membership PKEY set at the same time since
>  			 * the unlimited one will disable the limited one.
>  			 */
> -			ret =3D -EEXIST;
> -			goto bail;
> -		}
> -	}
> -	if (!any) {
> -		ret =3D -EBUSY;
> -		goto bail;
> +			return -EEXIST;
>  	}
> -	for (any =3D i =3D 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
> +	if (!any)
> +		return -EBUSY;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
>  		if (!ppd->pkeys[i] &&
>  		    atomic_inc_return(&ppd->pkeyrefs[i]) =3D=3D 1) {
>  			rcd->pkeys[pidx] =3D key;
>  			ppd->pkeys[i] =3D key;
>  			(void) ppd->dd->f_set_ib_cfg(ppd, QIB_IB_CFG_PKEYS, 0);
> -			ret =3D 0;
> -			goto bail;
> +			return 0;
>  		}
>  	}
> -	ret =3D -EBUSY;
> =20
> -bail:
> -	return ret;
> +	return -EBUSY;
>  }
> =20
>  /**

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-9xmj2oafcTLVi6PoEyKa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF6TcACgkQuCajMw5X
L91mNg//bed/I+AlBF64+8JBv1uC/sLb5fn6ZLZt4MW9MnezUj3QUovlXp/rUv1V
4kqY02eWyF2gmCW1zl0v8IXHiyOPkVEeDdwxRibPihzKxYF8qguoRh19ysPNRRzo
Vv80/uB9U9BN15Q2zoHh16HjsNzXveMh0IUYBKQtzBbBC3MpaatIaBpp9SavzMD6
opYjWtuxP7nJPtHsFGO0PUKtYorUdZoSlRP0hCJ1DqlMKDCK6GhhmDq7IV+8sWe8
Dlk6hoL51PWQGURYc9CtpHvO1V6HKkaISUwBpvAXUR5PDm0NGAQFz11q02jBkc8X
sqz2GHc99JeVN4jyhTt3sCZ/ZV7izRW2ygfn8IgfoJymCcg4b37EvLgM/LdYM/9U
JzBMYRUyh+Fp8viJr88oQWox27P8oUzvUYwU2w6oF9v37ZM7V6/nh2ZIGxhjFzbC
yk5MKC0CWGDIoa/21YaE82nc7LOIr4vRpwQ9VpYoWmetShDD7uSzXKqeT1MVDdaf
fVnCEwOfLfrUJS6gcd8AKYRHLW4OPniSOspIFmlJfqd6jwdBXW0VtTY0y8Lz5XQI
Nt5b3rxd+o7GqmbgmBrQjNJUIxsMqxgmyj/E72mKMe4Ao/y8uaTfyAvnicuWNndx
XBjbHwO0j+RaDwDaJqHewhaA687wRL1uVFJgzoUB8s7Ex6c9bfE=
=mSPf
-----END PGP SIGNATURE-----

--=-9xmj2oafcTLVi6PoEyKa--
