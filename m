From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: RDMA/ocrdma: Add support for fast register work requests (FRWR)
Date: Sat, 19 Oct 2013 11:54:09 +0300
Message-ID: <20131019085409.GB9312@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Naresh Gottumukkala,

The patch 7c33880c3cb2: "RDMA/ocrdma: Add support for fast register 
work requests (FRWR)" from Aug 26, 2013, leads to the following 
warning:
"drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1986 ocrdma_build_fr()
	 warn: impossible condition '(wr->wr.fast_reg.length > 4294967295) => (0-u32max > u32max)'"

drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
  1974  static int ocrdma_build_fr(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
  1975                             struct ib_send_wr *wr)
  1976  {
  1977          u64 fbo;
  1978          struct ocrdma_ewqe_fr *fast_reg = (struct ocrdma_ewqe_fr *)(hdr + 1);
  1979          struct ocrdma_mr *mr;
  1980          u32 wqe_size = sizeof(*fast_reg) + sizeof(*hdr);
  1981  
  1982          wqe_size = roundup(wqe_size, OCRDMA_WQE_ALIGN_BYTES);
  1983  
  1984          if ((wr->wr.fast_reg.page_list_len >
  1985                  qp->dev->attr.max_pages_per_frmr) ||
  1986                  (wr->wr.fast_reg.length > 0xffffffffULL))
			 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This condition can never be true.

  1987                  return -EINVAL;
  1988  
  1989          hdr->cw |= (OCRDMA_FR_MR << OCRDMA_WQE_OPCODE_SHIFT);
  1990          hdr->cw |= ((wqe_size / OCRDMA_WQE_STRIDE) << OCRDMA_WQE_SIZE_SHIFT);
  1991  

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
