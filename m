From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 10/16] Add a MAINTAINERS file
Date: Tue, 20 Sep 2016 16:10:19 -0600
Message-ID: <1474409425-15769-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is in the same format as the Kernel's version of this file
and reflects who is responsible for each portion of the tree.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 MAINTAINERS | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)
 create mode 100644 MAINTAINERS

diff --git a/MAINTAINERS b/MAINTAINERS
new file mode 100644
index 000000000000..22c475d4e0dd
--- /dev/null
+++ b/MAINTAINERS
@@ -0,0 +1,125 @@
+                          List of maintainers
+
+Generally patches should be submitted to the main development mailing list:
+
+linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+
+Descriptions of section entries:
+        F: Files and directories with wildcard patterns.
+           A trailing slash includes all files and subdirectory files.
+           F:   providers/mlx4/ all files in and below providers/mlx4/
+           F:   providers/*     all files in drivers/net, but not below
+           F:   */net/*         all files in "any top level directory"/net
+           One pattern per line.  Multiple F: lines acceptable.
+        L: Mailing list that is relevant to this area
+        M: Designated reviewer: FullName <address@domain>
+           These reviewers should be CCed on patches.
+        S: Status, one of the following:
+           Supported:   Someone is actually paid to look after this.
+           Maintained:  Someone actually looks after it.
+           Odd Fixes:   It has a maintainer but they don't have time to do
+                        much other than throw the odd patch in. See below..
+           Orphan:      No current maintainer [but maybe you could take the
+                        role as you write your new code].
+           Obsolete:    Old code. Something tagged obsolete generally means
+                        it has been replaced by a better system and you
+                        should be using that.
+
+BUILD SYSTEM
+M:	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
+S:	Supported
+F:	*/CMakeLists.txt
+F:	*/lib*.map
+F:	buildlib/
+
+CXGB3 USERSPACE PROVIDER (for iw_cxgb3.ko)
+M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
+S:	Supported
+F:	libcxgb3/
+
+CXGB4 USERSPACE PROVIDER (for iw_cxgb4.ko)
+M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
+S:	Supported
+F:	libcxgb4/
+
+HF1 USERSPACE PROVIDER (for hf1.ko)
+M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+L:	intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
+F:	libhfi1verbs/
+
+I40IW USERSPACE PROVIDER (for i40iw.ko)
+M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+F:	libi40iw/
+
+RDMA Communication Manager Assistant (for librdmacm.so)
+M:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+F:	ibacm/*
+
+IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)
+M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+L:	ibsupport-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
+F:	libipathverbs/
+
+IWARP PORT MAPPER DAEMON (for iwarp kernel providers)
+M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+F:	iwpmd/
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
+F:	libmlx4/
+
+MLX5 USERSPACE PROVIDER (for mlx5_ib.ko)
+M:	Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	libmlx5/
+
+MTHCA USERSPACE PROVIDER (for ib_mthca.ko)
+M:	Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	libmthca/
+
+NES USERSPACE PROVIDER (for iw_nes.ko)
+M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+S:	Supported
+F:	libnes/
+
+OCRDMA USERSPACE PROVIDER (for ocrdma.ko)
+M:	Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	libocrdma/
+
+RXE SOFT ROCEE USERSPACE PROVIDER (for rdma_rxe.ko)
+M:	Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+S:	Supported
+F:	librxe/
+
+SRP DAEMON (for ib_srp.ko)
+M:	Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
+S:	Supported
+F:	srp_daemon/
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
