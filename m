From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [patch] IB/rxe: Remove unneeded cast in rxe_srq_from_attr()
Date: Thu, 17 Nov 2016 13:49:31 +0200
Message-ID: <20161117114931.GL4240@leon.nu>
References: <20161117110005.GB32143@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AQYPrgrEUc/1pSX1"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161117110005.GB32143@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--AQYPrgrEUc/1pSX1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 17, 2016 at 02:00:05PM +0300, Dan Carpenter wrote:
> It makes me nervous when we cast pointer parameters.  I would estimate
> that around 50% of the time, it indicates a bug.  Here the cast is not
> needed becaue u32 and and unsigned int are the same thing.  Removing the
> cast makes the code more robust and future proof in case any of the
> types change.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

>
> diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
> index 2a6e3cd..efc832a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_srq.c
> +++ b/drivers/infiniband/sw/rxe/rxe_srq.c
> @@ -169,7 +169,7 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
>  			}
>  		}
>
> -		err = rxe_queue_resize(q, (unsigned int *)&attr->max_wr,
> +		err = rxe_queue_resize(q, &attr->max_wr,
>  				       rcv_wqe_size(srq->rq.max_sge),
>  				       srq->rq.queue->ip ?
>  						srq->rq.queue->ip->context :
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--AQYPrgrEUc/1pSX1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYLZlLAAoJEORje4g2clin0sYP/0N0fzoG/9pWL0mULSTdiaUy
iJyMjiiF9Aq41KctHFjGH4YrKBxLcmt0DfBS43VCsAOfkvIQGZrmYTDRNvmHQVQ2
MQ8Wfvtu6kgUYeNp2ofg9UjPUXONXEReuhMZv68UgCugDhfv4cN8QcO1QHrdqL79
yfHEsuDnfJ9yibD3ZtS7Cte7rGGyF4SAuCL8DEOXYxJF5MPcCr8BPQ6M9aAysNs2
RLFEw2ejsTnhStPTrMFQWHylE1c1AhDakjxb44MPewhvwYdwiB1kjDTHMf3IKPiJ
+gZNpoxj2r2m4/yhxoAf/jThS/XCK9XhpiWqyzmQgOJKw1a9Eaf/GLpGduIWEm/s
EiX21oxJqKk4xLDC6MY7iZvkVrU8z3WRcKHCmoef+jhtNRug5vD9dEcHfkRjh3PV
FRuXdnwjQ5B9MEqIOjlbzXmI1S94WSSJ5ni2FjZnck+Jl9EaGSFW3jt7HIe7DMBH
4QEP6r9N0Y8zk5l8dWquYgEVsCGJbquzcDdJfC+3Xuou9ku2ifPI7kHWr6sCbS/S
KxG9dtr5NLqWYS3IZVPeA/PSr1Ob2sTSxvNODtTFwmU+Y+6LdRJtpsfGA1zbUaSi
/JZMve9Ltkah7ZyDQg9LLfSN4TFPLWX/WoaUxAbHEoy1r+FPPF3Yo/Xyb49c842S
Urho7DUfdPUHJfT67JIx
=84Ka
-----END PGP SIGNATURE-----

--AQYPrgrEUc/1pSX1--
