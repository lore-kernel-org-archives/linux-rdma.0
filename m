From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfil: Delete unused bypass flags
Date: Wed, 11 Oct 2017 14:35:10 -0700
Message-ID: <dcb0766e-6960-fd02-089f-fdde83b93df4@intel.com>
References: <1507755409-12280-1-git-send-email-chris.gekas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507755409-12280-1-git-send-email-chris.gekas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christos Gkekas <chris.gekas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 10/11/2017 1:56 PM, Christos Gkekas wrote:
> Clean up unused bypass variables in verbs.
>
> Signed-off-by: Christos Gkekas <chris.gekas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>   drivers/infiniband/hw/hfi1/verbs.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
> index e232f3c..62c3f4e 100644
> --- a/drivers/infiniband/hw/hfi1/verbs.c
> +++ b/drivers/infiniband/hw/hfi1/verbs.c
> @@ -891,14 +891,12 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
>   	u8 sc5 = priv->s_sc;
>   	int ret;
>   	u32 dwords;
> -	bool bypass = false;
>   
>   	if (ps->s_txreq->phdr.hdr.hdr_type) {
>   		u8 extra_bytes = hfi1_get_16b_padding((hdrwords << 2), len);
>   
>   		dwords = (len + extra_bytes + (SIZE_OF_CRC << 2) +
>   			  SIZE_OF_LT) >> 2;
> -		bypass = true;
>   	} else {
>   		dwords = (len + 3) >> 2;
>   	}
> @@ -1034,7 +1032,6 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
>   	int ret = 0;
>   	pio_release_cb cb = NULL;
>   	u32 lrh0_16b;
> -	bool bypass = false;
>   	u8 extra_bytes = 0;
>   
>   	if (ps->s_txreq->phdr.hdr.hdr_type) {
> @@ -1044,7 +1041,6 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
>   		dwords = (len + extra_bytes) >> 2;
>   		hdr = (u32 *)&ps->s_txreq->phdr.hdr.opah;
>   		lrh0_16b = ps->s_txreq->phdr.hdr.opah.lrh[0];
> -		bypass = true;
>   	} else {
>   		dwords = (len + 3) >> 2;
>   		hdr = (u32 *)&ps->s_txreq->phdr.hdr.ibh;
Thanks!  Those were useful at one time. ;-)

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
