From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: preserve long_opts global for use in
 ibdiag_show_usage
Date: Tue, 17 Apr 2012 11:01:25 -0700
Message-ID: <20120417110125.7980ff8b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


	Calling ibdiag_show_usage after ibdiag_process_opts will result in
	using free'd memory.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibdiag_common.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 5752f95..d53398b 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -74,7 +74,7 @@ uint32_t ibd_ibnetdisc_flags = IBND_CONFIG_MLX_EPI;
 static const char *prog_name;
 static const char *prog_args;
 static const char **prog_examples;
-static struct option *long_opts;
+static struct option *long_opts = NULL;
 static const struct ibdiag_opt *opts_map[256];
 
 const static char *get_build_version(void)
@@ -357,6 +357,9 @@ int ibdiag_process_opts(int argc, char *const argv[], void *cxt,
 	prog_args = usage_args;
 	prog_examples = usage_examples;
 
+	if (long_opts)
+		free(long_opts);
+
 	long_opts = make_long_opts(exclude_common_str, custom_opts, opts_map);
 	if (!long_opts)
 		return -1;
@@ -380,8 +383,6 @@ int ibdiag_process_opts(int argc, char *const argv[], void *cxt,
 			ibdiag_show_usage();
 	}
 
-	free(long_opts);
-
 	return 0;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
