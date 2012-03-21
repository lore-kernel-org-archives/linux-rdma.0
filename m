From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 17:19:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237345197805@ORSMSX101.amr.corp.intel.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
 <24c5b654-d6a5-418d-8187-fba4ad47a3ce@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <24c5b654-d6a5-418d-8187-fba4ad47a3ce-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +struct ocrdma_alloc_ucontext_resp {
> +	u32 dev_id;
> +	u32 wqe_size;
> +	u32 max_inline_data;
> +	u32 dpp_wqe_size;
> +	u64 ah_tbl_page;
> +	u32 ah_tbl_len;
> +	u32 rsvd;
> +	u8 fw_ver[32];
> +	u32 rqe_size;
> +	u64 rsvd1;
> +} __packed;

Is there some reason to pack the structures in this file, rather than just defining things to align on a 64-bit boundary?  The structure above actually ends up sized to a 4-byte boundary, rather than 8-byte, with rsvd1 field misaligned.

> +/* user kernel communication data structures. */
> +struct ocrdma_alloc_pd_ureq {
> +	u64 rsvd1;
> +} __packed;
> +
> +struct ocrdma_alloc_pd_uresp {
> +	u32 id;
> +	u32 dpp_enabled;
> +	u32 dpp_page_addr_hi;
> +	u32 dpp_page_addr_lo;
> +	u64 rsvd1;
> +} __packed;
> +
> +struct ocrdma_create_cq_ureq {
> +	u32 dpp_cq;
> +	u32 rsvd;
> +} __packed;
> +
> +#define MAX_CQ_PAGES 8
> +struct ocrdma_create_cq_uresp {
> +	u32 cq_id;
> +	u32 page_size;
> +	u32 num_pages;
> +	u32 max_hw_cqe;
> +	u64 page_addr[MAX_CQ_PAGES];
> +	u64 db_page_addr;
> +	u32 db_page_size;
> +	u32 phase_change;
> +	u64 rsvd1;
> +	u64 rsvd2;
> +} __packed;

Why the extra reserved space?

> +
> +#define MAX_QP_PAGES 8
> +#define MAX_UD_AV_PAGES 8
> +
> +struct ocrdma_create_qp_ureq {
> +	u8 enable_dpp_cq;
> +	u8 rsvd;
> +	u16 dpp_cq_id;
> +	u32 rsvd1;
> +};
> +
> +struct ocrdma_create_qp_uresp {
> +	u16 qp_id;
> +	u16 sq_dbid;
> +	u16 rq_dbid;
> +	u16 resv0;
> +	u32 sq_page_size;
> +	u32 rq_page_size;
> +	u32 num_sq_pages;
> +	u32 num_rq_pages;
> +	u64 sq_page_addr[MAX_QP_PAGES];
> +	u64 rq_page_addr[MAX_QP_PAGES];
> +	u64 db_page_addr;
> +	u32 db_page_size;
> +	u32 dpp_credit;
> +	u32 dpp_offset;
> +	u32 rsvd1;
> +	u32 num_wqe_allocated;
> +	u32 num_rqe_allocated;
> +	u32 free_wqe_delta;
> +	u32 free_rqe_delta;
> +	u32 db_sq_offset;
> +	u32 db_rq_offset;
> +	u32 db_shift;
> +	u64 rsvd2;
> +	u64 rsvd3;
> +} __packed;

Why the extra reserved space?  rsvd2 & 3 are also misaligned.

> +
> +struct ocrdma_create_srq_uresp {
> +	u16 rq_dbid;
> +	u16 resv0;
> +	u32 resv1;
> +
> +	u32 rq_page_size;
> +	u32 num_rq_pages;
> +
> +	u64 rq_page_addr[MAX_QP_PAGES];
> +	u64 db_page_addr;
> +
> +	u32 db_page_size;
> +	u32 num_rqe_allocated;
> +	u32 db_rq_offset;
> +	u32 db_shift;
> +
> +	u32 free_rqe_delta;
> +	u32 rsvd2;
> +	u64 rsvd3;
> +} __packed;

Why the extra reserved space?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
