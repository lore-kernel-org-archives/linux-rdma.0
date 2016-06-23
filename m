From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reset flow support for IB kernel ULPs
Date: Thu, 23 Jun 2016 09:59:04 -0400
Message-ID: <6b87cbef-b123-cd0d-61cd-c55600c067a7@redhat.com>
References: <1466164898-31060-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1Sgij3sSjAqsgejnrUtAwCaAFFFLqMPDT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466164898-31060-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1Sgij3sSjAqsgejnrUtAwCaAFFFLqMPDT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/17/2016 08:01 AM, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The driver exposes interfaces that directly relate to HW state.
> Upon fatal error, consumers of these interfaces (ULPs) that rely
> on completion of all their posted work-request could hang, thereby
> introducing dependencies in shutdown order. To prevent this from
> happening, we manage the relevant resources (CQs, QPs) that are used
> by the device. Upon a fatal error, we now generate simulated
> completions for outstanding WQEs that were not completed at the
> time the HW was reset.
>=20
> It includes invoking the completion event handler for all involved
> CQs so that the ULPs will poll those CQs. When polled we return
> simulated CQEs with IB_WC_WR_FLUSH_ERR return code enabling ULPs
> to clean up their  resources and not wait forever for completions
> upon receiving remove_one.
>=20
> The above change requires an extra check in the data path to make
> sure that when device is in error state, the simulated CQEs will
> be returned and no further WQEs will be posted.
>=20
> Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, this has been accepted for 4.8.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--1Sgij3sSjAqsgejnrUtAwCaAFFFLqMPDT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa+soAAoJELgmozMOVy/deHEQAKYTEGU6oBDfVGceFnhZ+6eZ
Fp4gUEhAp8H1vxOI5m3693+bKlZLw1ouXpZY0+KiXwiCXVnmVSYqvMCEdU7RMzwY
IMZYuuGOFONYwu7LdsiVZEUgDTL707YBe68nft6eeWxW1TxbpEtR8QCUd+IwXHU9
GCag/U3cW/cF/79WaSDoV71BbBakI5Z9681SeZKA80mO9qkO4a0wbidS21bxLsvp
qK27WGbiMoWIr2JV4n+uE0fNaZZLkNzUVtkhEkfyQiYGnuKyzA0sLN0Wc62xt5yc
uGRyEUSTi9C23aIlA5SQrO8H2BlVd+sjNm6/CD3iV4rhbNUC8KaTeZPPC8/XQB1B
28Nww+J/rs1Uvyi9Mzi6SEwiQdqFoQ2xA+pbRi9Ukb5qT5aBdokeGztxcHFYC2HT
M+ITN6t6hLtg5383Fqk7cHZLVjc6SsJ6ZWaiDDP+0oTTydNATF0ldQlD8xdBeIBs
Rs4s5SLQrE+CRkK/H1mAfRR75C5lNDgLhQK2u2s3WVmj1e2CRaGvUhqB1oRpc9LJ
R9NE/oMPovfXZ0BZAF7+PssopJyv5KBKsSR88ZHVVPJb2gkDUMrZ2fO0F0pWUljZ
rB5KKn9UqnPwjfvHOLS01VzG26eb/BcArV4t0AgrmlCJWCMSaAPCj/qGinB9hdaW
oil/Lz+YAya3pT6zYpfh
=tDWu
-----END PGP SIGNATURE-----

--1Sgij3sSjAqsgejnrUtAwCaAFFFLqMPDT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
