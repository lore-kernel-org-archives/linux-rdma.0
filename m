From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 7/7] IB/core: pack struct ib_device a little tighter
Date: Fri, 29 Jan 2010 14:45:33 -0700
Message-ID: <20100129214533.17745.73219.stgit@bob.kio>
References: <20100129214039.17745.38679.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755562Ab0A2Vps@vger.kernel.org>
In-Reply-To: <20100129214039.17745.38679.stgit@bob.kio>
Sender: linux-kernel-owner@vger.kernel.org
To: rdreier@cisco.com
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

A small change to reduce the size of ib_device to 1112 bytes
(from 1128).

Signed-off-by: Alex Chiang <achiang@hp.com>
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
