From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/core: remove dead code
Date: Mon, 6 Jun 2016 10:22:43 +0300
Message-ID: <20160606072243.GR7477@leon.nu>
References: <1465159552-11833-1-git-send-email-sudipm.mukherjee@gmail.com>
Reply-To: leon@kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZaW/dtY/7oMe/vLp"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465159552-11833-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--ZaW/dtY/7oMe/vLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 05, 2016 at 09:45:52PM +0100, Sudip Mukherjee wrote:
> prot_sg_cnt has been assigned with the value of ret which we have
> already checked to be non-zero so prot_sg_cnt can never be zero at this
> point of the code and hence the else part can never execute.
>=20
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  drivers/infiniband/core/rw.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index 1eb9b12..644589b 100644
> --- a/drivers/infiniband/core/rw.c
> +++ b/drivers/infiniband/core/rw.c
> @@ -398,8 +398,6 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ct=
x, struct ib_qp *qp,
>  		else
>  			prev_wr->next =3D &ctx->sig->prot.reg_wr.wr;
>  		prev_wr =3D &ctx->sig->prot.reg_wr.wr;
> -	} else {
> -		ctx->sig->prot.mr =3D NULL;
>  	}

You need to remove the "if (prot_sg_cnt) {" line too. There is no need
in it after you removed "else" case.

Thanks

> =20
>  	ctx->sig->sig_mr =3D ib_mr_pool_get(qp, &qp->sig_mrs);
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ZaW/dtY/7oMe/vLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVSTDAAoJEORje4g2clinJb0P/3RfE/LqSbnkD5a0KkU32CJ1
zWIaJXcWIU/OBmgpfB2fp2c3qvhH/ihbFXjU49Wf6XtJeOZPpZt4bAJdvJnPeYNG
rUFZS+TFXRko3aBTEDncsEnZsb/IjEwyXupfSuG8aOsjkwEZHqApET63UX71nbzI
2eDKiRhliFerkiZyekqMm/Xip/oWmWNoJQ8OJTe+hZIs0nWm5VOkx7zbuOP1hiRj
mhXkyppWiVfOwM2pGULaEiEjgQPbge2+RYGJ+/pk5tbCA05s7O9RKf6zbHCWotIa
T8MTZCrY3Mc8Ru7QzXbPaIzWB9Pni1ikpk+Q+ofdgNL8q/GDv4pYHC07U6vlfuC6
ARDYIebrgdQ0kgpjE0TTgQfM701MA6tyZvwN0FETIkqXNN2zDAKICEgZtB1ZGz6Y
Tmm6foBzmcPr6UxvxPno2efqacSUkr8n57oFMLYNKluSoGZ6SHT56llc7bYr7gNG
Rfgh1TlUDwLavH46W2KTqSUXfKDbYrj57pExJspZygm5gcmhFRhbYpj7bOugUHeH
FHXw71WV6nS/eX2qUA5LUW5+Bm6qa2zWIsh1uhx7QlMTLTP+qVUybF+MGTLCv2zl
qPsbIoBfTFt2UOmMsSWHPqrsqKJD4C9ANWdjfnuG4QVkGDXjGZ2fGpDqFSFn6oR1
xukX49aDTdUPwAtVd+rN
=Qtpp
-----END PGP SIGNATURE-----

--ZaW/dtY/7oMe/vLp--
