From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors: Fix realloc size to prevent
 core
Date: Tue, 3 Nov 2009 13:20:03 -0800
Message-ID: <20091103132003.112e10b0.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Nov 2009 13:19:33 -0800
Subject: [PATCH] infiniband-diags/ibqueryerrors: Fix realloc size to prevent core

	Realloc size was wrong causing a core when enough errors were
	suppressed.  Reproduced by running:

	ibqueryerrors -c -s RcvSwRelayErrors,LinkDowned,VL15Dropped,XmtWait,SymbolErrors,LinkRecovers,RcvErrors

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index f83f29e..aac7087 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -381,7 +381,8 @@ void print_node(ibnd_node_t * node, void *user_data)
 
 static void add_suppressed(enum MAD_FIELDS field)
 {
-	suppressed_fields = realloc(suppressed_fields, sizeof(enum MAD_FIELDS));
+	suppressed_fields = realloc(suppressed_fields,
+				    (sup_total+1)*sizeof(enum MAD_FIELDS));
 	suppressed_fields[sup_total] = field;
 	sup_total++;
 }
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
