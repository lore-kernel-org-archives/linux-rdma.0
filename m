From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/52] IB/qib: add
Date: Thu, 06 May 2010 16:58:51 -0700
Message-ID: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patches introduce an updated and renamed version of
the ipath HCA driver which supports the QLogic PCIe QLE SDR, DDR,
and QDR series of HCAs.
Rather than try to patch the ipath driver to include support for QDR,
multiple ports, bug fixes, and many other structual changes, the
ib_qib driver replaces the ib_ipath driver.

Changes in v3:

Added .xxx = yyy to qib_dma_mapping_ops initializer.
Added ib_post_send(IB_WR_FAST_REG_MR) support.
Changed ib_register_device() to pass a function for creating the
	port sysfs files.
Changed /sys/class/infiniband/qib0/stats to
	/sys/class/infiniband/qib0/ports/1/diag_counters/*
Moved /sys/class/infiniband/qib0/ports/1/linkcontrol/qsfp
	to ipathfs/<N>/qsfp<P>
Removed debug printks until they can be replaced with event tracing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
