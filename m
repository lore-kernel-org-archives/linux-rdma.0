From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-rc] RDMA/vmw_pvrdma: Report CQ missed events
Date: Thu, 10 Aug 2017 14:15:57 +0300
Message-ID: <20170810111557.GT1423@mtr-leonro.local>
References: <1502351175-1762-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4dIe/AmYstFUGHTF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502351175-1762-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4dIe/AmYstFUGHTF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 10, 2017 at 12:46:15AM -0700, Adit Ranadive wrote:
> From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>
> There is a chance of a race between arming the CQ and receiving
> completions. By reporting CQ missed events any ULPs should poll
> again to get the completions.
>
> Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> Acked-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> index 69bda61..f4ab5fa 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> @@ -65,12 +65,27 @@ int pvrdma_req_notify_cq(struct ib_cq *ibcq,
>  	struct pvrdma_dev *dev = to_vdev(ibcq->device);
>  	struct pvrdma_cq *cq = to_vcq(ibcq);
>  	u32 val = cq->cq_handle;
> +	unsigned long flags;
>
>  	val |= (notify_flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
>  		PVRDMA_UAR_CQ_ARM_SOL : PVRDMA_UAR_CQ_ARM;
>
> +	spin_lock_irqsave(&cq->cq_lock, flags);
> +
>  	pvrdma_write_uar_cq(dev, val);
>
> +	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
> +		unsigned int head;
> +
> +		if (pvrdma_idx_ring_has_data(&cq->ring_state->rx,
> +					     cq->ibcq.cqe, &head)) {

The pvrdma_idx_ring_has_data function can return PVRDMA_INVALID_IDX (-1).

> +			spin_unlock_irqrestore(&cq->cq_lock, flags);
> +			return 1;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&cq->cq_lock, flags);
> +
>  	return 0;
>  }
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4dIe/AmYstFUGHTF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmMQG0ACgkQ5GN7iDZy
WKcpTw//RB1GBjF69SfSWB8p0ceQ1OUjWQtNcnP6AmW9yUQA6Fh19i4Rm8A3Dy7s
5xv8apOvbDbxc3oeGE/g4fcOJkVokM/FNNef/i4q4PDVxp+p5GeEprytWxVtRhR7
ianA+tf5PjxifMenQhIO370N4LyIg4yKS6IvB5tsVUDypC0Map22TDv5x3EXJXIZ
FO0EcNH+6RdsigSwYT+kw4+BJ1xB2ilfDFWBmTptBQLG45AKjp1l2RLNdwreXHs2
SnC2ac4e9jaUTme9MU2FsU68JEFD6ol5v9oaB3MQDX1NAfHwepg9w5T5DuHth51N
nnBac/ouvfc4b052aum8F0lM7PuJBayUfnjgqwHCeUwOPsakbh/PVj4p8NZKzHoZ
821oaRy9Uy2e7ot+h5KaNSUBN6aKNWJ6Owac17R1uMoTy9j4hIF2ZDV0ZJOwlvr4
1KkMZgiS1d1vaidYzLjtnmjxUKqnUtoWt+PuxALf2/7RckTodFrV3SBrF3BWG+/w
fZi9F8r29ZBd5iAyCxcqJOf+2BzAtWMAcljLaCK0NezorA9VtG7w5rDUw6js/ieO
1TUbzjmn0kzm9oC12gnuuaS1x9ZbVFaaTqhhevybRdCo83EtXGy/ZPgDO8qZ/83c
qjUEdImnppcRQIWfliEG8UbQxvjDToxcQ8Quo4IrBUqE82dYUVI=
=QB81
-----END PGP SIGNATURE-----

--4dIe/AmYstFUGHTF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
