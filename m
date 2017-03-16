From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-core v3 4/9] libbnxt_re: Add support for posting and polling
Date: Thu, 16 Mar 2017 08:34:12 +0530
Message-ID: <CANjDDBh9JP-0W4NDW4p-Jx2fivcSKS9ZAt5AdLRdQPXH8WxxCw@mail.gmail.com>
References: <1489574253-20300-1-git-send-email-devesh.sharma@broadcom.com>
 <1489574253-20300-5-git-send-email-devesh.sharma@broadcom.com> <20170315163454.GD29562@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170315163454.GD29562-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 15, 2017 at 10:04 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Mar 15, 2017 at 06:37:28AM -0400, Devesh Sharma wrote:
>> +
>> +     pthread_spin_lock(&dpi->db_lock);
>> +     *dbval = htole64(*dbval);
>> +     udma_ordering_write_barrier();
>
> The ordering_write_barrier is basically an equivalent barrier to a
> spinlock, so this is an unnecessary pattern.
>
> However, you still always need udma_to_device_barrier before
> triggering chip DMA.

I will change this in V4.

>
> There is also no udma_from_device_barrier() in this driver, which
> can't be right, please add one around bnxt_re_is_cqe_valid most
> likely.

Ok, I will put it in next version.

>
> Your github branch doesn't compile, btw.
>
> I ran it through sparse, this is what I suggest..

Thanks for the suggestion, I will run sparse and try to fix all of it.

>
> diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
> index 8dbb7b985fa0cd..8fcb2517a23028 100644
> --- a/providers/bnxt_re/bnxt_re-abi.h
> +++ b/providers/bnxt_re/bnxt_re-abi.h
> @@ -243,7 +243,7 @@ struct bnxt_re_req_cqe {
>
>  struct bnxt_re_rc_cqe {
>         __u32 length;
> -       __u32 imm_key;
> +       __be32 imm_key;
>         __u64 qp_handle;
>         __u64 mr_handle;
>  };
> @@ -282,7 +282,7 @@ struct bnxt_re_bsqe {
>  };
>
>  struct bnxt_re_psns {
> -       __u32 opc_spsn;
> +       __le32 opc_spsn;
>         __u32 flg_npsn;
>  };
>
> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
> index dafe55b74aefe8..3e31845b4d6b47 100644
> --- a/providers/bnxt_re/verbs.c
> +++ b/providers/bnxt_re/verbs.c
> @@ -581,9 +581,10 @@ static int bnxt_re_poll_flush_wcs(struct bnxt_re_queue *que,
>                 wrid = &wridp[head];
>                 if (wrid->psns) {
>                         psns = wrid->psns;
> -                       opcode = (psns->opc_spsn >> BNXT_RE_PSNS_OPCD_SHIFT) &
> -                                 BNXT_RE_PSNS_OPCD_MASK;
> -               }
> +                        opcode = (le32toh(psns->opc_spsn) >>
> +                                  BNXT_RE_PSNS_OPCD_SHIFT) &
> +                                 BNXT_RE_PSNS_OPCD_MASK;
> +                }
>
>                 ibvwc->status = IBV_WC_WR_FLUSH_ERR;
>                 ibvwc->opcode = opcode;
> @@ -1032,10 +1033,11 @@ static void bnxt_re_fill_psns(struct bnxt_re_qp *qp, struct bnxt_re_psns *psns,
>                               uint8_t opcode, uint32_t len)
>  {
>         uint32_t pkt_cnt = 0, nxt_psn;
> +       uint32_t opc_spsn = 0;
>
>         memset(psns, 0, sizeof(*psns));
>         if (qp->qptyp == IBV_QPT_RC) {
> -               psns->opc_spsn = qp->sq_psn & BNXT_RE_PSNS_SPSN_MASK;
> +               opc_spsn = qp->sq_psn & BNXT_RE_PSNS_SPSN_MASK;
>                 pkt_cnt = (len / qp->mtu);
>                 if (len % qp->mtu)
>                         pkt_cnt++;
> @@ -1044,9 +1046,9 @@ static void bnxt_re_fill_psns(struct bnxt_re_qp *qp, struct bnxt_re_psns *psns,
>                 qp->sq_psn = nxt_psn;
>         }
>         opcode = bnxt_re_ibv_wr_to_wc_opcd(opcode);
> -       psns->opc_spsn |= ((opcode & BNXT_RE_PSNS_OPCD_MASK) <<
> -                           BNXT_RE_PSNS_OPCD_SHIFT);
> -       *(uint64_t *)psns = htole64(*(uint64_t *)psns);
> +        opc_spsn |=
> +            ((opcode & BNXT_RE_PSNS_OPCD_MASK) << BNXT_RE_PSNS_OPCD_SHIFT);
> +        psns->opc_spsn = htole32(opc_spsn);
>  }
>
>  static void bnxt_re_fill_wrid(struct bnxt_re_wrid *wrid, struct ibv_send_wr *wr,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
