From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [infiniband:for-next 45/63] drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:2030:7:
 warning: cast to pointer from integer of different size
Date: Mon, 17 Mar 2014 23:17:37 -0700
Message-ID: <CAL1RGDWzEgbbrqB_dFe6mOVmg1NU7peSLkkLhCLgnUJocBC2xg@mail.gmail.com>
References: <5327e216.M3hL1E84bxffArYd%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5327e216.M3hL1E84bxffArYd%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Devesh Sharma <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Devesh,

Not sure why you made the "clean up" patch that changed
ocrdma_dev.stag_arr from an array of ocrdma_mr* to an array of u64
(which doesn't seem to accomplish anything but make the code messier
and use more memory on 32-bit archs), but trusting that you have some
reason for that, I'll add the following on top to fix the compiler
warnings:

    RDMA/ocrdma: Fix warnings about pointer <-> integer casts

    We should cast pointers to and from unsigned long to turn them into ints.

    Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 71e879908d27..875c16f60376 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2027,8 +2027,8 @@ static int ocrdma_build_fr(struct ocrdma_qp *qp,
struct ocrdma_hdr_wqe *hdr,
        fast_reg->num_sges = wr->wr.fast_reg.page_list_len;
        fast_reg->size_sge =
                get_encoded_page_size(1 << wr->wr.fast_reg.page_shift);
-       mr = (struct ocrdma_mr *)qp->dev->stag_arr[(hdr->lkey >> 8) &
-               (OCRDMA_MAX_STAG - 1)];
+       mr = (struct ocrdma_mr *) (unsigned long)
+               qp->dev->stag_arr[(hdr->lkey >> 8) & (OCRDMA_MAX_STAG - 1)];
        build_frmr_pbes(wr, mr->hwmr.pbl_table, &mr->hwmr);
        return 0;
 }
@@ -2862,7 +2862,8 @@ struct ib_mr *ocrdma_alloc_frmr(struct ib_pd
*ibpd, int max_page_list_len)
                goto mbx_err;
        mr->ibmr.rkey = mr->hwmr.lkey;
        mr->ibmr.lkey = mr->hwmr.lkey;
-       dev->stag_arr[(mr->hwmr.lkey >> 8) & (OCRDMA_MAX_STAG - 1)] = (u64)mr;
+       dev->stag_arr[(mr->hwmr.lkey >> 8) & (OCRDMA_MAX_STAG - 1)] =
+               (unsigned long) mr;
        return &mr->ibmr;
 mbx_err:
        ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);

On Mon, Mar 17, 2014 at 11:05 PM, kbuild test robot
<fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
> head:   9fc4580d3abdaca6c1d7d54f7f697308af0dc438
> commit: 8c2e221bbbbc071aa0e04acad1cc09d947fe40e1 [45/63] RDMA/ocrdma: Code clean-up
> config: make ARCH=i386 allyesconfig
>
> All warnings:
>
>    drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: In function 'ocrdma_build_fr':
>>> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:2030:7: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      mr = (struct ocrdma_mr *)qp->dev->stag_arr[(hdr->lkey >> 8) &
>           ^
>    drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: In function 'ocrdma_alloc_frmr':
>>> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:2865:53: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      dev->stag_arr[(mr->hwmr.lkey >> 8) & (OCRDMA_MAX_STAG - 1)] = (u64)mr;
>                                                         ^
>
> vim +2030 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>
>   2014                  hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_WR;
>   2015          if (wr->wr.fast_reg.access_flags & IB_ACCESS_REMOTE_READ)
>   2016                  hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_RD;
>   2017          hdr->lkey = wr->wr.fast_reg.rkey;
>   2018          hdr->total_len = wr->wr.fast_reg.length;
>   2019
>   2020          fbo = wr->wr.fast_reg.iova_start -
>   2021              (wr->wr.fast_reg.page_list->page_list[0] & PAGE_MASK);
>   2022
>   2023          fast_reg->va_hi = upper_32_bits(wr->wr.fast_reg.iova_start);
>   2024          fast_reg->va_lo = (u32) (wr->wr.fast_reg.iova_start & 0xffffffff);
>   2025          fast_reg->fbo_hi = upper_32_bits(fbo);
>   2026          fast_reg->fbo_lo = (u32) fbo & 0xffffffff;
>   2027          fast_reg->num_sges = wr->wr.fast_reg.page_list_len;
>   2028          fast_reg->size_sge =
>   2029                  get_encoded_page_size(1 << wr->wr.fast_reg.page_shift);
>> 2030          mr = (struct ocrdma_mr *)qp->dev->stag_arr[(hdr->lkey >> 8) &
>   2031                  (OCRDMA_MAX_STAG - 1)];
>   2032          build_frmr_pbes(wr, mr->hwmr.pbl_table, &mr->hwmr);
>   2033          return 0;
>   2034  }
>   2035
>   2036  static void ocrdma_ring_sq_db(struct ocrdma_qp *qp)
>   2037  {
>   2038          u32 val = qp->sq.dbid | (1 << OCRDMA_DB_SQ_SHIFT);
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
