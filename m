From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/52] IB/qib: add
Date: Tue, 18 May 2010 17:26:48 -0700
Message-ID: <20100519002647.11950.62870.stgit@chromite.mv.qlogic.com>
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

Changes in v4:

Change qib_sd7220.c to not use atomic_inc_return() - it wasn't needed.
Change qib_iba7322.c to replace the "bogus" QMH/QME module parameters.
Update copyrights to 2010.
Fix for CQ completion callbacks which could be out-of-order.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
