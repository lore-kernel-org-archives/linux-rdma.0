From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/15] IB/rxe: Issue warnings once
Date: Wed, 4 Jan 2017 16:18:55 +0200
Message-ID: <20170104141855.GS12077@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353613.3592.28.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwbb4r/vLufKlfJs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353613.3592.28.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--rwbb4r/vLufKlfJs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2017 at 10:41:40AM +0000, Bart Van Assche wrote:
> It is strongly recommended to report kernel warnings once instead
> of every time a condition is hit. Hence change WARN_ON() into
> WARN_ON_ONCE() / BUILD_BUG_ON() as
> appropriate.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
> =A0drivers/infiniband/sw/rxe/rxe_comp.c |=A0=A02 +-
> =A0drivers/infiniband/sw/rxe/rxe_mr.c=A0=A0=A0|=A0=A06 +++---
> =A0drivers/infiniband/sw/rxe/rxe_resp.c | 11 ++++++-----
> =A03 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw=
/rxe/rxe_comp.c
> index d369f24425f9..e912e5396e8c 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
> @@ -254,7 +254,7 @@ static inline enum comp_state check_ack(struct rxe_qp=
 *qp,
> =A0		}
> =A0		break;
> =A0	default:
> -		WARN_ON(1);
> +		WARN_ON_ONCE(1);
> =A0	}
> =A0
> =A0	/* Check operation validity. */
> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/r=
xe/rxe_mr.c
> index 8ca3acd327b3..8cf38b253c37 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -123,7 +123,7 @@ static int rxe_mem_alloc(struct rxe_dev *rxe, struct =
rxe_mem *mem, int num_buf)
> =A0			goto err2;
> =A0	}
> =A0
> -	WARN_ON(!is_power_of_2(RXE_BUF_PER_MAP));
> +	BUILD_BUG_ON(!is_power_of_2(RXE_BUF_PER_MAP));
> =A0
> =A0	mem->map_shift	=3D ilog2(RXE_BUF_PER_MAP);
> =A0	mem->map_mask	=3D RXE_BUF_PER_MAP - 1;
> @@ -189,7 +189,7 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe=
_pd *pd, u64 start,
> =A0		goto err1;
> =A0	}
> =A0
> -	WARN_ON(!is_power_of_2(umem->page_size));
> +	WARN_ON_ONCE(!is_power_of_2(umem->page_size));
> =A0
> =A0	mem->page_shift		=3D ilog2(umem->page_size);
> =A0	mem->page_mask		=3D umem->page_size - 1;
> @@ -375,7 +375,7 @@ int rxe_mem_copy(struct rxe_mem *mem, u64 iova, void =
*addr, int length,
> =A0		return 0;
> =A0	}
> =A0
> -	WARN_ON(!mem->map);
> +	WARN_ON_ONCE(!mem->map);
> =A0
> =A0	err =3D mem_check_range(mem, iova, length);
> =A0	if (err) {
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw=
/rxe/rxe_resp.c
> index 3435efff8799..6dbd069689fc 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -307,7 +307,7 @@ static enum resp_states check_op_valid(struct rxe_qp =
*qp,
> =A0		break;
> =A0
> =A0	default:
> -		WARN_ON(1);
> +		WARN_ON_ONCE(1);
> =A0		break;
> =A0	}
> =A0
> @@ -495,7 +495,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
> =A0		}
> =A0	}
> =A0
> -	WARN_ON(qp->resp.mr);
> +	WARN_ON_ONCE(qp->resp.mr);
> =A0
> =A0	qp->resp.mr =3D mem;
> =A0	return RESPST_EXECUTE;
> @@ -808,9 +808,10 @@ static enum resp_states execute(struct rxe_qp *qp, s=
truct rxe_pkt_info *pkt)
> =A0		err =3D process_atomic(qp, pkt);
> =A0		if (err)
> =A0			return err;
> -	} else
> +	} else {
> =A0		/* Unreachable */
> -		WARN_ON(1);
> +		WARN_ON_ONCE(1);
> +	}

This function (execute(..)) and the comment looks very suspicious to me.
It seems that the orginal author had intention to check if mask has
specific bit on, but current implmentation allows multiple bits and
has execution priority between bits in mask.

Moni,
Did you do it on purpose?

> =A0
> =A0	/* We successfully processed this new request. */
> =A0	qp->resp.msn++;
> @@ -1396,7 +1397,7 @@ int rxe_responder(void *arg)
> =A0			goto exit;
> =A0
> =A0		default:
> -			WARN_ON(1);
> +			WARN_ON_ONCE(1);
> =A0		}
> =A0	}
> =A0
> --=A0
> 2.11.0

--rwbb4r/vLufKlfJs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhtBE4ACgkQ5GN7iDZy
WKe7qA/9ERNcYOwuNl81y0yRq6CBhLpKk01na0EqlS9gd/xOkEcGYe8JYy91WOa6
mXOE6H1a2HktCgvEBkVmxqRfVZn+1cZyQ9oZ+DV4wL3atfviMzqJxvtBX5xIUS1u
lmYG2CfwG+R+fKM5B7DXGczxfjuQIeKJD8SVmmSz0QeDhtpTFlqJUzFnJ/omcBtU
tc+DVW8FaG/68V2z0E0zOxZx9orTImRZiRmQAujQX78K9DmXp02ErQ8h3ZnianC4
PAEfvyv+3WjG6QWiRf8kELaTOzgSzanV61PdtWBH+urunavQVhqCYUlsMv3Z5cbX
/3Jsu4dgAv+IpW9HfSBKi2AvmTwpXqfx5fd1rwBU4+cSCnvXQgtyH3TBtmJHzyvs
QbfFxl82JFouLz7yI2hBtne6HHVnfjHtZae3QB2iLtddB/FyDzKrYJvSDBsBifSf
BETJSbEf8m4Pb1s6lqAtFhUfw+ePghMLoEJFp9DCxbiWkcC1CmAB+3g11iDAZgWL
c8LNzE2IlxAf8lF7eXPjMJ7PjfBCzUEXXYnlwXnzspz+sjMVkPb4E3TPYkc2TlHf
94VCxaEmGrsbHZx7kIusbXg39/axn39EjyGp76FkjKM0OisiMVo880/qDXRfFDp0
ccgmGNHgWsLDuJ1LJeaVHDJdR8BGjTJAC9LoZQ7IxgRPSVLnBcE=
=dwNl
-----END PGP SIGNATURE-----

--rwbb4r/vLufKlfJs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
