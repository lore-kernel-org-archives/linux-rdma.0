From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2 18/18] IB/core: pack struct ib_device a little tighter
Date: Tue, 02 Feb 2010 12:09:16 -0700
Message-ID: <20100202190916.28217.90954.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100202185235.28217.64521.stgit-tBlMHHroXgg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A small change to reduce the size of ib_device to 1112 bytes
(from 1128).

Signed-off-by: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
---

 include/rdma/ib_verbs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09509ed..a585e0f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -984,9 +984,9 @@ struct ib_device {
 	struct list_head              event_handler_list;
 	spinlock_t                    event_handler_lock;
 
+	spinlock_t                    client_data_lock;
 	struct list_head              core_list;
 	struct list_head              client_data_list;
-	spinlock_t                    client_data_lock;
 
 	struct ib_cache               cache;
 	int                          *pkey_tbl_len;
@@ -1144,8 +1144,8 @@ struct ib_device {
 		IB_DEV_UNREGISTERED
 	}                            reg_state;
 
-	u64			     uverbs_cmd_mask;
 	int			     uverbs_abi_ver;
+	u64			     uverbs_cmd_mask;
 
 	char			     node_desc[64];
 	__be64			     node_guid;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
