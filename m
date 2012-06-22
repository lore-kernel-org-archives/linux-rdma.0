From: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: FW: [PATCH] RDS: correct ib api use with sg_dma_address/sg_dma_len
Date: Fri, 22 Jun 2012 14:35:25 -0500
Message-ID: <4FE4C8FD.2050700@oracle.com>
References: <20120419161517.713.76674.stgit@kop-dev-sles11-04.qlogic.org> <32E1700B9017364D9B60AED9960492BC0D457CBA@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D457CBA-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Mascarenhas, Edward" <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/22/2012 1:24 PM, Marciniszyn, Mike wrote:
> I haven=E2=80=99t seen this patch get upstream.
>
> Is there something I should do to help?
>
> Mike
>
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.=
kernel.org] On Behalf Of Mike Marciniszyn
> Sent: Thursday, April 19, 2012 12:15 PM
> To: venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
> Subject: [PATCH] RDS: correct ib api use with sg_dma_address/sg_dma_l=
en
>
> From: Mike Marciniszyn<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>
> 0b088e00 ("RDS: Use page_remainder_alloc() for recv bufs") added uses=
 of sg_dma_len() and sg_dma_address().
>
> IB ulps should use ib_sg_dma_len() and ib_sg_dma_address respectively=
 since some HCAs overload ib_sg_dma* operations.
>
> Signed-off-by: Mike Marciniszyn<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
> ---
>   net/rds/ib_recv.c |    9 ++++++---
>   1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c index 8d19491..cd4=
4ed3 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -339,8 +339,8 @@ static int rds_ib_recv_refill_one(struct rds_conn=
ection *conn,
>   	sge->length =3D sizeof(struct rds_header);
>
>   	sge =3D&recv->r_sge[1];
> -	sge->addr =3D sg_dma_address(&recv->r_frag->f_sg);
> -	sge->length =3D sg_dma_len(&recv->r_frag->f_sg);
> +	sge->addr =3D ib_sg_dma_address(ic->i_cm_id->device,&recv->r_frag->=
f_sg);
> +	sge->length =3D ib_sg_dma_len(ic->i_cm_id->device,&recv->r_frag->f_=
sg);
>
>   	ret =3D 0;
>   out:
> @@ -381,7 +381,10 @@ void rds_ib_recv_refill(struct rds_connection *c=
onn, int prefill)
>   		ret =3D ib_post_recv(ic->i_cm_id->qp,&recv->r_wr,&failed_wr);
>   		rdsdebug("recv %p ibinc %p page %p addr %lu ret %d\n", recv,
>   			 recv->r_ibinc, sg_page(&recv->r_frag->f_sg),
> -			 (long) sg_dma_address(&recv->r_frag->f_sg), ret);
> +			 (long) ib_sg_dma_address(
> +				ic->i_cm_id->device,
> +				&recv->r_frag->f_sg),
> +			ret);
>   		if (ret) {
>   			rds_ib_conn_error(conn, "recv post on "
>   			       "%pI4 returned %d, disconnecting and "
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo i=
nfo at  http://vger.kernel.org/majordomo-info.html
>
>
I had Acked it according to my April 19th email. ;-)

Venkat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
