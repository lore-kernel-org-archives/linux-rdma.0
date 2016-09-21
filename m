From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 02/23] Move the AUTHORS files into MAINTAINERS
Date: Wed, 21 Sep 2016 16:08:28 -0600
Message-ID: <1474495729-17604-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Mark historical past authors using the 'H:' tag. We don't need this
information sprinkled throughout the tree.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 MAINTAINERS           | 13 +++++++++++++
 ibacm/AUTHORS         |  1 -
 iwpmd/AUTHORS         |  2 --
 libcxgb3/AUTHORS      |  1 -
 libcxgb4/AUTHORS      |  1 -
 libhfi1verbs/AUTHORS  |  1 -
 libi40iw/AUTHORS      |  1 -
 libibcm/AUTHORS       |  2 --
 libibumad/AUTHORS     |  3 ---
 libibverbs/AUTHORS    |  4 ----
 libipathverbs/AUTHORS |  1 -
 libmlx4/AUTHORS       |  2 --
 libmlx5/AUTHORS       |  2 --
 libmthca/AUTHORS      |  2 --
 libnes/AUTHORS        |  1 -
 libocrdma/AUTHORS     |  1 -
 librdmacm/AUTHORS     |  1 -
 17 files changed, 13 insertions(+), 26 deletions(-)
 delete mode 100644 ibacm/AUTHORS
 delete mode 100644 iwpmd/AUTHORS
 delete mode 100644 libcxgb3/AUTHORS
 delete mode 100644 libcxgb4/AUTHORS
 delete mode 100644 libhfi1verbs/AUTHORS
 delete mode 100644 libi40iw/AUTHORS
 delete mode 100644 libibcm/AUTHORS
 delete mode 100644 libibumad/AUTHORS
 delete mode 100644 libibverbs/AUTHORS
 delete mode 100644 libipathverbs/AUTHORS
 delete mode 100644 libmlx4/AUTHORS
 delete mode 100644 libmlx5/AUTHORS
 delete mode 100644 libmthca/AUTHORS
 delete mode 100644 libnes/AUTHORS
 delete mode 100644 libocrdma/AUTHORS
 delete mode 100644 librdmacm/AUTHORS

diff --git a/MAINTAINERS b/MAINTAINERS
index 71e8724f87ac..b39529feec9b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11,6 +11,7 @@ Descriptions of section entries:
            F:   providers/*     all files in drivers/net, but not below
            F:   */net/*         all files in "any top level directory"/net
            One pattern per line.  Multiple F: lines acceptable.
+        H: Historical authors
         L: Mailing list that is relevant to this area
         M: Designated reviewer: FullName <address@domain>
            These reviewers should be CCed on patches.
@@ -73,22 +74,30 @@ F:	libipathverbs/
 
 IWARP PORT MAPPER DAEMON (for iwarp kernel providers)
 M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+H:	Robert Sharp <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 S:	Supported
 F:	iwpmd/
 
 LIBIBCM USERSPACE LIBRARY FOR IB CONNECTION MANAGEMENT (/dev/infiniband/ucmX)
 M:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+H:	Libor Michalek <libor-nF87da4h5whBDgjK7y7TUQ@public.gmane.org>
 S:	Obsolete
 F:	libibcm/
 
 LIBIBUMAD USERSPACE LIBRARY FOR SMP AND GMP MAD PROCESSING (/dev/infiniband/umadX)
 M:	Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
+H:	Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
+H:	Shahar Frank <shahar-smomgflXvOZWk0Htik3J/w@public.gmane.org>
 S:	Supported
 F:	libibumad/
 
 LIBIBVERBS USERSPACE LIBRARY FOR RDMA VERBS (/dev/infiniband/uverbsX)
 M:	Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 M:	Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
+H:	Michael S. Tsirkin <mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
+H:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+H:	Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+H:	Roland Dreier <roland-nF87da4h5whBDgjK7y7TUQ@public.gmane.org>
 S:	Supported
 F:	libibverbs/
 
@@ -99,16 +108,20 @@ F:	librdmacm/
 
 MLX4 USERSPACE PROVIDER (for mlx4_ib.ko)
 M:	Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+H:	Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
 S:	Supported
 F:	libmlx4/
 
 MLX5 USERSPACE PROVIDER (for mlx5_ib.ko)
 M:	Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+H:	Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 S:	Supported
 F:	libmlx5/
 
 MTHCA USERSPACE PROVIDER (for ib_mthca.ko)
 M:	Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+H:	Michael S. Tsirkin <mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
+H:	Roland Dreier <roland-nF87da4h5whBDgjK7y7TUQ@public.gmane.org>
 S:	Supported
 F:	libmthca/
 
diff --git a/ibacm/AUTHORS b/ibacm/AUTHORS
deleted file mode 100644
index f76b870b4dba..000000000000
diff --git a/iwpmd/AUTHORS b/iwpmd/AUTHORS
deleted file mode 100644
index 10d4e6567693..000000000000
diff --git a/libcxgb3/AUTHORS b/libcxgb3/AUTHORS
deleted file mode 100644
index 5d9d2e254c6c..000000000000
diff --git a/libcxgb4/AUTHORS b/libcxgb4/AUTHORS
deleted file mode 100644
index 5d9d2e254c6c..000000000000
diff --git a/libhfi1verbs/AUTHORS b/libhfi1verbs/AUTHORS
deleted file mode 100644
index 669766569127..000000000000
diff --git a/libi40iw/AUTHORS b/libi40iw/AUTHORS
deleted file mode 100644
index 64c97fbe1f34..000000000000
diff --git a/libibcm/AUTHORS b/libibcm/AUTHORS
deleted file mode 100644
index a694ab7046b6..000000000000
diff --git a/libibumad/AUTHORS b/libibumad/AUTHORS
deleted file mode 100644
index d09c13fe2781..000000000000
diff --git a/libibverbs/AUTHORS b/libibverbs/AUTHORS
deleted file mode 100644
index fcea3504a516..000000000000
diff --git a/libipathverbs/AUTHORS b/libipathverbs/AUTHORS
deleted file mode 100644
index 48d6abcd54b9..000000000000
diff --git a/libmlx4/AUTHORS b/libmlx4/AUTHORS
deleted file mode 100644
index 4d0f22c2632b..000000000000
diff --git a/libmlx5/AUTHORS b/libmlx5/AUTHORS
deleted file mode 100644
index 11cba6b7cb32..000000000000
diff --git a/libmthca/AUTHORS b/libmthca/AUTHORS
deleted file mode 100644
index 165aea78cd02..000000000000
diff --git a/libnes/AUTHORS b/libnes/AUTHORS
deleted file mode 100644
index 64c97fbe1f34..000000000000
diff --git a/libocrdma/AUTHORS b/libocrdma/AUTHORS
deleted file mode 100644
index b930ad385164..000000000000
diff --git a/librdmacm/AUTHORS b/librdmacm/AUTHORS
deleted file mode 100644
index f76b870b4dba..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
