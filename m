From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 15/15] Add a MAINTAINERS file
Date: Mon, 22 Aug 2016 12:13:38 -0600
Message-ID: <1471889618-1605-16-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is in the same format as the Kernel's version of this file
and reflects who is responsible for each portion of the tree.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 MAINTAINERS | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 MAINTAINERS

diff --git a/MAINTAINERS b/MAINTAINERS
new file mode 100644
index 000000000000..8013c42ef245
--- /dev/null
+++ b/MAINTAINERS
@@ -0,0 +1,81 @@
+BUILD SYSTEM
+M:	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
+S:	Supported
+F:	*/CMakeLists.txt
+F:	buildlib/
+
+CXGB3 USERSPACE PROVIDER (for iw_cxgb3.ko)
+M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
+S:	Supported
+F:	providers/cxgb3/
+
+CXGB4 USERSPACE PROVIDER (for iw_cxgb4.ko)
+M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
+S:	Supported
+F:	providers/cxgb4/
+
+HF1 USERSPACE PROVIDER (for hf1.ko)
+M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+L:	intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
+F:	providers/hfi1verbs/
+
+I40IW USERSPACE PROVIDER (for i40iw.ko)
+M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+F:	providers/i40iw/
+
+IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)
+M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+F:	providers/ipathverbs/
+
+LIBIBCM USERSPACE LIBRARY FOR IB CONNECTION MANAGEMENT (/dev/infiniband/ucmX)
+M:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Obsolete
+F:	libibcm/
+
+LIBIBUMAD USERSPACE LIBRARY FOR SMP AND GMP MAD PROCESSING (/dev/infiniband/umadX)
+M:	Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
+S:	Supported
+F:	libibumad/
+
+LIBIBVERBS USERSPACE LIBRARY FOR RDMA VERBS (/dev/infiniband/uverbsX)
+M:	Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+S:	Supported
+F:	libibverbs/
+
+LIBRDMACM USERSPACE LIBRARY FOR RDMA CONNECTION MANAGEMENT (/dev/infiniband/rdma_cm)
+M:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+F:	librdmacm/
+
+MLX4 USERSPACE PROVIDER (for mlx4_ib.ko)
+M:	Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	providers/mlx4/
+
+MLX5 USERSPACE PROVIDER (for mlx5_ib.ko)
+M:	Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	providers/mlx5/
+
+MTHCA USERSPACE PROVIDER (for ib_mthca.ko)
+M:	Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	providers/mthca/
+
+NES USERSPACE PROVIDER (for iw_nes.ko)
+M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+F:	providers/nes/
+
+OCRDMA USERSPACE PROVIDER (for ocrdma.ko)
+M:	Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
+S:	Supported
+F:	providers/ocrdma/
+
+RXE SOFT ROCEE USERSPACE PROVIDER (for rdma_rxe.ko)
+M:	Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	providers/rxe/
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
