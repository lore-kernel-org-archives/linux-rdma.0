From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/st.c: fix potential core dumps
Date: Tue, 7 Sep 2010 18:18:41 +0300
Message-ID: <4C8657D1.40900@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If we're out of polynomials, new_size() will return -1
Deal with this in low-level calls.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/st.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/st.c b/opensm/opensm/st.c
index ea76038..469ba9d 100644
--- a/opensm/opensm/st.c
+++ b/opensm/opensm/st.c
@@ -194,6 +194,8 @@ size_t size;
 #endif

 	size = new_size(size);	/* round up to prime number */
+	if (size < 0)
+		return NULL;

 	tbl = alloc(st_table);
 	tbl->type = type;
@@ -351,6 +353,9 @@ register st_table *table;
 	unsigned int hash_val;

 	new_num_bins = new_size(old_num_bins + 1);
+	if (new_num_bins < 0)
+		return;
+
 	new_bins =
 	    (st_table_entry **) Calloc(new_num_bins, sizeof(st_table_entry *));

-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
