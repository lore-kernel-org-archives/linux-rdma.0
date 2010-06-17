From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/7] IB/qib: clear eager buffer memory for each new process
Date: Thu, 17 Jun 2010 16:13:59 -0700
Message-ID: <20100617231359.8006.29104.stgit@chromite.mv.qlogic.com>
References: <20100617231338.8006.18131.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100617231338.8006.18131.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The eager buffers are not being cleared before being mmapped into a new
user address space. This is a potential security risk and should be fixed.
Note that the eager header queue is already being cleared OK.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 2589599..1d4db4b 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1472,6 +1472,9 @@ int qib_setup_eagerbufs(struct qib_ctxtdata *rcd)
 		dma_addr_t pa = rcd->rcvegrbuf_phys[chunk];
 		unsigned i;
 
+		/* clear for security and sanity on each use */
+		memset(rcd->rcvegrbuf[chunk], 0, size);
+
 		for (i = 0; e < egrcnt && i < egrperchunk; e++, i++) {
 			dd->f_put_tid(dd, e + egroff +
 					  (u64 __iomem *)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
