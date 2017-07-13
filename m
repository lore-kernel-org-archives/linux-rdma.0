From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] bnxt_re: Fix -Wimplicit-fallthrough
 warnings in GCC 7.1
Date: Thu, 13 Jul 2017 18:49:45 +0300
Message-ID: <20170713154945.GP1528@mtr-leonro.local>
References: <20170713154722.10294-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AGpuFv5M2awwCL1A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713154722.10294-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--AGpuFv5M2awwCL1A
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Something was broken in my scripts, it should be rdma-core and not rdma-nex=
t.

Sorry.

On Thu, Jul 13, 2017 at 06:47:22PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> [59/189] Building C object providers/bnxt_re/CMakeFiles/bnxt_re-rdmav2.di=
r/verbs.c.o
> ../providers/bnxt_re/verbs.c: In function =E2=80=98bnxt_re_post_send=E2=
=80=99:
> ../providers/bnxt_re/verbs.c:1222:18: warning: this statement may fall th=
rough [-Wimplicit-fallthrough=3D]
>     hdr->key_immd =3D htole32(be32toh(wr->imm_data));
>                   ^
> ../providers/bnxt_re/verbs.c:1223:3: note: here
>    case IBV_WR_SEND:
>    ^~~~
> ../providers/bnxt_re/verbs.c:1232:18: warning: this statement may fall th=
rough [-Wimplicit-fallthrough=3D]
>     hdr->key_immd =3D htole32(be32toh(wr->imm_data));
>                   ^
> ../providers/bnxt_re/verbs.c:1233:3: note: here
>    case IBV_WR_RDMA_WRITE:
>
> Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changelog from v0:
>  * Used commonly used in rdma-core annotation to mark fail through.
> ---
>  providers/bnxt_re/verbs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
> index 1fe79671..b89bcbaa 100644
> --- a/providers/bnxt_re/verbs.c
> +++ b/providers/bnxt_re/verbs.c
> @@ -1220,6 +1220,7 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct =
ibv_send_wr *wr,
>  			 * LE platform be32toh will do the job.
>  			 */
>  			hdr->key_immd =3D htole32(be32toh(wr->imm_data));
> +			/* fall through */
>  		case IBV_WR_SEND:
>  			if (qp->qptyp =3D=3D IBV_QPT_UD)
>  				bytes =3D bnxt_re_build_ud_sqe(qp, sqe, wr,
> @@ -1230,6 +1231,7 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct =
ibv_send_wr *wr,
>  			break;
>  		case IBV_WR_RDMA_WRITE_WITH_IMM:
>  			hdr->key_immd =3D htole32(be32toh(wr->imm_data));
> +			/* fall through */
>  		case IBV_WR_RDMA_WRITE:
>  			bytes =3D bnxt_re_build_rdma_sqe(qp, sqe, wr, is_inline);
>  			break;
> --
> 2.13.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--AGpuFv5M2awwCL1A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllnlpgACgkQ5GN7iDZy
WKdgYQ//ZlKsWC3HmneeP8wKyKaqpymHixsBnVq2dEFr4UCQhWsQZS3gyunJryga
BgimziTat08XQhSeY9c0v+WuWSA418iVe7N0sj8C86RPZEsa3r3+sLNMu7ClbcGW
ZLa3Krd8QfWkt9LfZHX0hYqf/CmItXDOiGBwZ4ctxAHWMnMv7dZEzLzIkVdKDqGE
cNNJEBpsoXr5zdN25kxNRw/d6Vb5hFzaePGuPmRduYd02dNPBBHL/2WEWjg+9rNM
711NDspCcOhWQMym67Dw3aYdHak9CT6HROGTF0p2GRTz8Ad4AVAM2I93Bb1p/aID
Ze/J1r6wG/y95VDwy7nJeVxf8pqC0zuk2xvrMC2KvHellPKDR8xfTlHdON5WJZhG
bGhgR+J5rUYdcWi5oXgdNCTI7/bCWBl3gnYCSgQRLPB5qLOJh5eMwiI8v1PStcLH
gvy3q+mVVCywiSDEfVTPqo6y7RNAMYgGfaV4jRy0S9hJp7sUH4GNwDlXHMSNmGLw
HnLjcuJn8mayqfqeB8ZZTKn00Nu3KcIQ2rTKt0Mlj2UvqYL/RN66afuHx3jPxaNs
JEq+laJ81rWNPlnYUZubhnDBf8SwRQqI6raFlVhyV8q+jQ1S4H0xPVxZNKowSmJF
eQqpWtozdaCAXllxX4wRy7fqS363P0xEJPv9Azc/Ra1UiOYcE7I=
=xF/e
-----END PGP SIGNATURE-----

--AGpuFv5M2awwCL1A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
