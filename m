From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/9] RDMA/nes: Verbs and PHY fixes + misc update
Date: Tue, 1 Dec 2009 16:19:42 -0600
Message-ID: <20091201221942.GA7768@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland,

Patch 1 and 2 are Frank Zago's patches for nes, resubmitted per your request.
Hopefully these will show up on patchwork.

Patch 3 adds send with invalidate and local invalidate support.

Patch 4 corrects fast memory registration, we are now using the
proper interface.

Patch 5 adds additional check and reset to SFP+ PHY code.

Patch 6 adds IB_SIGNAL_ALL_WR support.  Corresponding change to libnes
is available on openfabrics.org.

Patch 7 is cleanup patch for struct nes_qp.

Patch 8 adds max_cqe check to nes_create_cq.

Patch 9 is copyright and branding string update.

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
