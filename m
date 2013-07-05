From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags: umad_init needs to be called before
 sa_get_handle
Date: Fri, 5 Jul 2013 08:39:36 -0700
Message-ID: <20130705083936.f8337074e5e868730069b4ff@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/ibdiag_sa.h |    1 +
 src/saquery.c       |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/ibdiag_sa.h b/include/ibdiag_sa.h
index 41b4a4c..368a829 100644
--- a/include/ibdiag_sa.h
+++ b/include/ibdiag_sa.h
@@ -58,6 +58,7 @@ struct sa_query_result {
 	void *p_result_madw;
 };
 
+/* NOTE: umad_init must be called prior to sa_get_handle */
 struct sa_handle * sa_get_handle(void);
 void sa_free_handle(struct sa_handle * h);
 
diff --git a/src/saquery.c b/src/saquery.c
index 2ee29ad..b27686b 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1842,6 +1842,9 @@ int main(int argc, char **argv)
 		ibdiag_show_usage();
 	}
 
+	if (umad_init())
+		IBERROR("Failed to initialized umad library");
+
 	h = sa_get_handle();
 	if (!h)
 		IBPANIC("Failed to bind to the SA");
@@ -1894,6 +1897,7 @@ error:
 	if (src_lid)
 		free(src_lid);
 	sa_free_handle(h);
+	umad_done();
 	close_node_name_map(node_name_map);
 	return (status);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
