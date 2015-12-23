From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Replace kfree with kvfree in mlx4_ib_destroy_srq
Date: Wed, 23 Dec 2015 14:35:46 -0500
Message-ID: <567AF792.5050207@redhat.com>
References: <1450320855-4570-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P8WBsD9pBhqfqtm4KFkArj3JxlHw724gh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450320855-4570-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt-goXnUAHYgFxWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P8WBsD9pBhqfqtm4KFkArj3JxlHw724gh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/16/2015 09:54 PM, Wengang Wang wrote:
> Commit 0ef2f05c7e02ff99c0b5b583d7dee2cd12b053f2 uses vmalloc for WR buf=
fers
> when needed and uses kvfree to free the buffers. It missed changing kfr=
ee
> to kvfree in mlx4_ib_destroy_srq().
>=20
> Reported-by: Matthew Finaly <matt-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/srq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/m=
lx4/srq.c
> index 8d133c4..c394376 100644
> --- a/drivers/infiniband/hw/mlx4/srq.c
> +++ b/drivers/infiniband/hw/mlx4/srq.c
> @@ -286,7 +286,7 @@ int mlx4_ib_destroy_srq(struct ib_srq *srq)
>  		mlx4_ib_db_unmap_user(to_mucontext(srq->uobject->context), &msrq->db=
);
>  		ib_umem_release(msrq->umem);
>  	} else {
> -		kfree(msrq->wrid);
> +		kvfree(msrq->wrid);
>  		mlx4_buf_free(dev->dev, msrq->msrq.max << msrq->msrq.wqe_shift,
>  			      &msrq->buf);
>  		mlx4_db_free(dev->dev, &msrq->db);
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--P8WBsD9pBhqfqtm4KFkArj3JxlHw724gh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeveSAAoJELgmozMOVy/dIi0P/00kFM2PqR8CCTiLrfUkEfN/
6CpMg3jtmoGvGgMaF+/214cSIbms++q1mGP18RkdZK6Em1L/HGBjSoWDdHs+C0wW
Z0w+ClWFjUsfe5yIV8n6g5ReBSqJxnx5O+6z9CLH7yauSjUBqOnKiSY3aJu8C2IL
7K6sP+FbAKh1sjRA/KKC2aIohQHQGfdmkIW2JHnXIySIKHMep0q4g0Jh7AbhgbU5
QF0VXfI6/+E1o2G6Ei90Op0sokCe+7U2QS60+96Z/hPnSD6OoyrVPya0Q3bd+BbK
ZBUYY82qEbR+K6SERaSCMf1hdKzknrZ92Daj1L0LPl5TY4v4085mW0yDVRExiJ7X
cQP5bV4dKkxwBNVfcE+3+a4w9uSS8zR/EKHu3qDXFPm3jpJ8tw+zQAlUWu95Zugr
LIO8wZCSbER+gMRPLMc0EvAl2pyHcy5SGpo2RF+zWqmNT+qNgUkICXhzS7qgiDny
2RQ6UntDD0N/LXAAoWQU9qnpEQhrls+AFDon+dsrbxWbrRl7TNYPjbPG+URy21EJ
YL6j20SFpVBLM1yTHEmCJqthMEAK05qQ8iqVOV+Go9hz+dQN50OqRv6i75b0MOpP
VOlYdjpmNGxzGvtXMgtLyvMKcS/Mdq/D5xd98aBkqBTZUMAQeLTnHVFLqI988PKs
H+JEgOxFG0TFri/qV/4a
=S8lD
-----END PGP SIGNATURE-----

--P8WBsD9pBhqfqtm4KFkArj3JxlHw724gh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
