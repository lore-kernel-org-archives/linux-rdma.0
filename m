From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH v2 01/26] rculist: introduce list_next_or_null_rr_rcu()
Date: Fri, 18 May 2018 15:03:48 +0200
Message-ID: <20180518130413.16997-2-roman.penyaev@profitbricks.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, Swapnil Ingle <swapnil.ingle@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>, Roman Pen <roman.penyaev@profitbricks.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Function is going to be used in transport over RDMA module
in subsequent patches.

Function returns next element in round-robin fashion,
i.e. head will be skipped.  NULL will be returned if list
is observed as empty.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/rculist.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 127f534fec94..b0840d5ab25a 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -339,6 +339,25 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
 })
 
 /**
+ * list_next_or_null_rr_rcu - get next list element in round-robin fashion.
+ * @head:	the head for the list.
+ * @ptr:        the list head to take the next element from.
+ * @type:       the type of the struct this is embedded in.
+ * @memb:       the name of the list_head within the struct.
+ *
+ * Next element returned in round-robin fashion, i.e. head will be skipped,
+ * but if list is observed as empty, NULL will be returned.
+ *
+ * This primitive may safely run concurrently with the _rcu list-mutation
+ * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
+ */
+#define list_next_or_null_rr_rcu(head, ptr, type, memb) \
+({ \
+	list_next_or_null_rcu(head, ptr, type, memb) ?: \
+		list_next_or_null_rcu(head, READ_ONCE((ptr)->next), type, memb); \
+})
+
+/**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
-- 
2.13.1
