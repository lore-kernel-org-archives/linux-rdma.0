From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: Trivial function comment corrected.
Date: Mon, 3 Oct 2016 10:55:56 -0400
Message-ID: <506c9cb3-7183-1341-05de-875438f62c96@redhat.com>
References: <1473775850-11991-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bsuftgx1kWGgJbuitqJB93AviabVhHFJx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473775850-11991-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bsuftgx1kWGgJbuitqJB93AviabVhHFJx
Content-Type: multipart/mixed; boundary="Mm3JG3RPm8EiE5HdAAN2cglXvH9oSeJ0W";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <506c9cb3-7183-1341-05de-875438f62c96-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: Trivial function comment corrected.
References: <1473775850-11991-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1473775850-11991-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--Mm3JG3RPm8EiE5HdAAN2cglXvH9oSeJ0W
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/13/2016 10:10 AM, Parav Pandit wrote:
> Corrected function name in comment from qib_ to rvt_.
>=20
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/=
rdmavt/qp.c
> index bdb540f..40186ca 100644
> --- a/drivers/infiniband/sw/rdmavt/qp.c
> +++ b/drivers/infiniband/sw/rdmavt/qp.c
> @@ -996,7 +996,7 @@ static void rvt_insert_qp(struct rvt_dev_info *rdi,=
 struct rvt_qp *qp)
>  }
> =20
>  /**
> - * qib_modify_qp - modify the attributes of a queue pair
> + * rvt_modify_qp - modify the attributes of a queue pair
>   * @ibqp: the queue pair who's attributes we're modifying
>   * @attr: the new attributes
>   * @attr_mask: the mask of attributes to modify
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Mm3JG3RPm8EiE5HdAAN2cglXvH9oSeJ0W--

--bsuftgx1kWGgJbuitqJB93AviabVhHFJx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8nF8AAoJELgmozMOVy/dOXcQAItcOwIZ8c0EB8isKMIXq23Z
J3aDaqtXq5W5e4SumBy+G54Vg4Gyuy0P2uT1QY4hEgjimVCL5rUQKKHeOcTzsNUR
y0azWHQYeLlNgDU6gyQgqF79JuveItvxZDPGC1vxuv48JQvtWPrhWmRj6Girz7aS
O9cUQtAeZ9gsIAEbFjzajg3M37f26fZ33lUI2rTsJk/mw8b9PqG7i10j/zNRdd/7
4LEnuj83unpqES24jYIDAq2YLTRlgtC6JHC09BQ5k3B5eUwmYNgiWYUf1Eqyvmx7
OxeDJRVKV64xZX5plNvGmYbH1Wd+gt8e3AQ65ocobgCjtnI/dfrTmPANJuEP+R+4
tQHkAvRQH3RN8wMopmWlmEcNbcGzlt6uTJ2MoAz7hv6aCQJz6QD6rIX1/H9Zlho4
YdLA7AiMHYI3YWRCKOmvAERZlutgJxvdhjIuLFkIQELz6/khvChTPttzJwK4KmLW
J9I9zOMVZTHEtY3hx1BIIiAyl0P0Qm4QQ1pK1MWX/CBvh4ZSor0tPJCToFKSbRRC
4F+5D4LkwBL4rB2Tdy4aclgBQvhBH9d7CgCaH8cg+3HGPSrDdnnzKx/2+7ltCEGu
G8EJZba4Tyb0IWr4SD8mlpC0wWJLDMwdkTHbqFCoNCG59vVv1vj7zHLNhUF2uVn+
h+cd82VGdsdCMOqvIh1w
=vWdy
-----END PGP SIGNATURE-----

--bsuftgx1kWGgJbuitqJB93AviabVhHFJx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
