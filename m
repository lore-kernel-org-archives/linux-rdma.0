From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 1/2] IB/uverbs: Add memory type to ib_umem structure
Date: Thu, 02 Dec 2010 13:02:24 -0600
Message-ID: <20101202190224.13657.94704.stgit@build.ogc.int>
References: <20101202190157.13657.58176.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101202190157.13657.58176.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tom-/Yg/VP3ZvrM@public.gmane.org, garlick-i2BcT+NCU+M@public.gmane.org, acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add a memory type field to the ib_umem structure to keep track
of the type of memory registered by the user.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 include/rdma/ib_umem.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 9ee0d2e..566b07f 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -39,8 +39,14 @@
 
 struct ib_ucontext;
 
+enum ib_umem_type {
+	IB_UMEM_MEM_MAP = 0,
+	IB_UMEM_IO_MAP
+};
+
 struct ib_umem {
 	struct ib_ucontext     *context;
+	enum ib_umem_type	type;
 	size_t			length;
 	int			offset;
 	int			page_size;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
