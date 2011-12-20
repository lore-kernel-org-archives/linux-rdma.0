From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/25 v2] ib/sa: Export function to pack a path record into
 wire format
Date: Tue, 20 Dec 2011 21:44:14 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325661B92@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow converting from struct ib_sa_path_rec to the IB defined
SA path record wire format.  This will be used to report path
data from the rdma cm into user space.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |    6 ++++++
 include/rdma/ib_sa.h               |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index fbbfa24..027c797 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -616,6 +616,12 @@ void ib_sa_unpack_path(void *attribute, struct ib_sa_path_rec *rec)
 }
 EXPORT_SYMBOL(ib_sa_unpack_path);
 
+void ib_sa_pack_path(struct ib_sa_path_rec *rec, void *attribute)
+{
+	ib_pack(path_rec_table, ARRAY_SIZE(path_rec_table), rec, attribute);
+}
+EXPORT_SYMBOL(ib_sa_pack_path);
+
 static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 				    int status,
 				    struct ib_sa_mad *mad)
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index d44a563..ade03ca 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -385,4 +385,10 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
  */
 void ib_sa_unpack_path(void *attribute, struct ib_sa_path_rec *rec);
 
+/**
+ * ib_sa_pack_path - Conert a path record from struct ib_sa_path_rec
+ * to IB MAD wire format.
+ */
+void ib_sa_pack_path(struct ib_sa_path_rec *rec, void *attribute);
+
 #endif /* IB_SA_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
