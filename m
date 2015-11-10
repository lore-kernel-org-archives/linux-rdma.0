From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 09:34:14 -0500
Message-ID: <F60E8BA6-D728-44E4-9331-0C23AB96E634@oracle.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com> <1447152255-28231-3-git-send-email-sagig@mellanox.com> <20151110114145.GA2810@infradead.org> <5641D920.5000409@mellanox.com> <20151110120432.GA8230@infradead.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151110120432.GA8230-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Nov 10, 2015, at 7:04 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
>> On Tue, Nov 10, 2015 at 01:46:40PM +0200, Sagi Grimberg wrote:
>> 
>> 
>>> On 10/11/2015 13:41, Christoph Hellwig wrote:
>>> Oh, and while we're at it.  Can someone explain why we're even
>>> using rdma_read_chunk_frmr for IB?  It seems to work around the
>>> fact tat iWarp only allow a single RDMA READ SGE, but it's used
>>> whenever the device has IB_DEVICE_MEM_MGT_EXTENSIONS, which seems
>>> wrong.
>> 
>> I think Steve can answer it better than I can. I think that it is
>> just to have a single code path for both IB and iWARP. I agree that
>> the condition seems wrong and for small transfers rdma_read_chunk_frmr
>> is really a performance loss.
> 
> Well, the code path already exists, but only is used fi
> IB_DEVICE_MEM_MGT_EXTENSIONS isn't set.  Below is an untested patch
> that demonstrates how I think svcrdma should setup the reads.  Note
> that this also allows to entirely remove it's allphys MR.

Two comments:

1. RFCs and changes in sunrpc must be copied to linux-nfs.

2. Is there a reason IB is not using the allphys MR for RDMA Read?
That would be much more efficient. On the NFS server that MR isn't
exposed, thus it is safe to use.


> Note that as a followon this would also allow to remove the
> non-READ_W_INV code path from rdma_read_chunk_frmr as a future
> step.
> 
> 
> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
> index f869807..35fa638 100644
> --- a/include/linux/sunrpc/svc_rdma.h
> +++ b/include/linux/sunrpc/svc_rdma.h
> @@ -147,7 +147,6 @@ struct svcxprt_rdma {
>    struct ib_qp         *sc_qp;
>    struct ib_cq         *sc_rq_cq;
>    struct ib_cq         *sc_sq_cq;
> -    struct ib_mr         *sc_phys_mr;    /* MR for server memory */
>    int             (*sc_reader)(struct svcxprt_rdma *,
>                      struct svc_rqst *,
>                      struct svc_rdma_op_ctxt *,
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> index ff4f01e..a410cb6 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> @@ -160,7 +160,7 @@ int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
>            goto err;
>        atomic_inc(&xprt->sc_dma_used);
> 
> -        /* The lkey here is either a local dma lkey or a dma_mr lkey */
> +        /* The lkey here is the local dma lkey */
>        ctxt->sge[pno].lkey = xprt->sc_dma_lkey;
>        ctxt->sge[pno].length = len;
>        ctxt->count++;
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> index 9f3eb89..2780da4 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -887,8 +887,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
>    struct ib_cq_init_attr cq_attr = {};
>    struct ib_qp_init_attr qp_attr;
>    struct ib_device *dev;
> -    int uninitialized_var(dma_mr_acc);
> -    int need_dma_mr = 0;
>    int ret = 0;
>    int i;
> 
> @@ -986,68 +984,41 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
>    }
>    newxprt->sc_qp = newxprt->sc_cm_id->qp;
> 
> -    /*
> -     * Use the most secure set of MR resources based on the
> -     * transport type and available memory management features in
> -     * the device. Here's the table implemented below:
> -     *
> -     *        Fast    Global    DMA    Remote WR
> -     *        Reg    LKEY    MR    Access
> -     *        Sup'd    Sup'd    Needed    Needed
> -     *
> -     * IWARP    N    N    Y    Y
> -     *        N    Y    Y    Y
> -     *        Y    N    Y    N
> -     *        Y    Y    N    -
> -     *
> -     * IB        N    N    Y    N
> -     *        N    Y    N    -
> -     *        Y    N    Y    N
> -     *        Y    Y    N    -
> -     *
> -     * NB:    iWARP requires remote write access for the data sink
> -     *    of an RDMA_READ. IB does not.
> -     */
> -    newxprt->sc_reader = rdma_read_chunk_lcl;
> -    if (dev->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
> -        newxprt->sc_frmr_pg_list_len =
> -            dev->max_fast_reg_page_list_len;
> -        newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_FAST_REG;
> -        newxprt->sc_reader = rdma_read_chunk_frmr;
> -    }
> +    if (rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num)) {
> +        /*
> +         * iWARP requires remote write access for the data sink, and
> +         * only supports a single SGE for RDMA_READ requests, so we'll
> +         * have to use a memory registration for each RDMA_READ.
> +         */
> +        if (!(dev->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS)) {
> +            /*
> +             * We're an iWarp device but don't support FRs.
> +             * Tought luck, better exit early as we have little
> +             * chance of doing something useful.
> +             */
> +            goto errout;
> +        }
> 
> -    /*
> -     * Determine if a DMA MR is required and if so, what privs are required
> -     */
> -    if (!rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num) &&
> -        !rdma_ib_or_roce(dev, newxprt->sc_cm_id->port_num))
> +        newxprt->sc_frmr_pg_list_len = dev->max_fast_reg_page_list_len;
> +        newxprt->sc_dev_caps =
> +             SVCRDMA_DEVCAP_FAST_REG |
> +             SVCRDMA_DEVCAP_READ_W_INV;
> +        newxprt->sc_reader = rdma_read_chunk_frmr;
> +    } else if (rdma_ib_or_roce(dev, newxprt->sc_cm_id->port_num)) {
> +        /*
> +         * For IB or RoCE life is easy, no unsafe write access is
> +         * required and multiple SGEs are supported, so we don't need
> +         * to use MRs.
> +         */
> +        newxprt->sc_reader = rdma_read_chunk_lcl;
> +    } else {
> +        /*
> +         * Neither iWarp nor IB-ish, we're out of luck.
> +         */
>        goto errout;
> -
> -    if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG) ||
> -        !(dev->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
> -        need_dma_mr = 1;
> -        dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
> -        if (rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num) &&
> -            !(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG))
> -            dma_mr_acc |= IB_ACCESS_REMOTE_WRITE;
>    }
> 
> -    if (rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num))
> -        newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_READ_W_INV;
> -
> -    /* Create the DMA MR if needed, otherwise, use the DMA LKEY */
> -    if (need_dma_mr) {
> -        /* Register all of physical memory */
> -        newxprt->sc_phys_mr =
> -            ib_get_dma_mr(newxprt->sc_pd, dma_mr_acc);
> -        if (IS_ERR(newxprt->sc_phys_mr)) {
> -            dprintk("svcrdma: Failed to create DMA MR ret=%d\n",
> -                ret);
> -            goto errout;
> -        }
> -        newxprt->sc_dma_lkey = newxprt->sc_phys_mr->lkey;
> -    } else
> -        newxprt->sc_dma_lkey = dev->local_dma_lkey;
> +    newxprt->sc_dma_lkey = dev->local_dma_lkey;
> 
>    /* Post receive buffers */
>    for (i = 0; i < newxprt->sc_max_requests; i++) {
> @@ -1203,9 +1174,6 @@ static void __svc_rdma_free(struct work_struct *work)
>    if (rdma->sc_rq_cq && !IS_ERR(rdma->sc_rq_cq))
>        ib_destroy_cq(rdma->sc_rq_cq);
> 
> -    if (rdma->sc_phys_mr && !IS_ERR(rdma->sc_phys_mr))
> -        ib_dereg_mr(rdma->sc_phys_mr);
> -
>    if (rdma->sc_pd && !IS_ERR(rdma->sc_pd))
>        ib_dealloc_pd(rdma->sc_pd);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
