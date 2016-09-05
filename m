From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 27/28] Avoid clang 3.6 warning -Wmissing-field-initializers
Date: Mon,  5 Sep 2016 15:08:17 -0600
Message-ID: <1473109698-31408-28-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The canonical way to zero fill a struct is {}.

Sometimes people will write this as {0} which does the same thing
if the first struct member is integral.

However the preference for {} is because it allows the compiler to see
that the intent is for every member to be zero, and this is not an
inadvertent incomplete initialization of an array or struct.

We have a random jumble of both styles, so lets prefer {} since
it avoids a useful warning.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/examples/asyncwatch.c    | 2 +-
 libibverbs/examples/rc_pingpong.c   | 2 +-
 libibverbs/examples/srq_pingpong.c  | 2 +-
 libibverbs/examples/uc_pingpong.c   | 2 +-
 libibverbs/examples/ud_pingpong.c   | 4 ++--
 libibverbs/examples/xsrq_pingpong.c | 2 +-
 libmlx5/src/verbs.c                 | 4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/libibverbs/examples/asyncwatch.c b/libibverbs/examples/asyncwatch.c
index df1261503b7d..c78994d24bed 100644
--- a/libibverbs/examples/asyncwatch.c
+++ b/libibverbs/examples/asyncwatch.c
@@ -105,7 +105,7 @@ int main(int argc, char *argv[])
 		static struct option long_options[] = {
 			{ .name = "ib-dev",    .has_arg = 1, .val = 'd' },
 			{ .name = "help",      .has_arg = 0, .val = 'h' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "d:h", long_options, NULL);
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 7bcc413a0f1d..9054a68b7eb5 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -731,7 +731,7 @@ int main(int argc, char *argv[])
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
 			{ .name = "odp",      .has_arg = 0, .val = 'o' },
 			{ .name = "ts",       .has_arg = 0, .val = 't' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:ot",
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index e6492dc553fd..f17972580b57 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -665,7 +665,7 @@ int main(int argc, char *argv[])
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:m:q:r:n:l:eg:",
diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
index d132de98694a..7d982d36a5ef 100644
--- a/libibverbs/examples/uc_pingpong.c
+++ b/libibverbs/examples/uc_pingpong.c
@@ -568,7 +568,7 @@ int main(int argc, char *argv[])
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:",
diff --git a/libibverbs/examples/ud_pingpong.c b/libibverbs/examples/ud_pingpong.c
index 67da4bd90f32..deefb9b81013 100644
--- a/libibverbs/examples/ud_pingpong.c
+++ b/libibverbs/examples/ud_pingpong.c
@@ -324,7 +324,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	}
 
 	{
-		struct ibv_port_attr port_info = { 0 };
+		struct ibv_port_attr port_info = {};
 		int mtu;
 
 		if (ibv_query_port(ctx->context, port, &port_info)) {
@@ -588,7 +588,7 @@ int main(int argc, char *argv[])
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:r:n:l:eg:",
diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
index a7e345f3850c..903548ed6824 100644
--- a/libibverbs/examples/xsrq_pingpong.c
+++ b/libibverbs/examples/xsrq_pingpong.c
@@ -875,7 +875,7 @@ int main(int argc, char *argv[])
 			{ .name = "sl",        .has_arg = 1, .val = 'l' },
 			{ .name = "events",    .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",   .has_arg = 1, .val = 'g' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:m:c:n:l:eg:", long_options,
diff --git a/libmlx5/src/verbs.c b/libmlx5/src/verbs.c
index a76821e6f695..054633cbed29 100644
--- a/libmlx5/src/verbs.c
+++ b/libmlx5/src/verbs.c
@@ -1561,8 +1561,8 @@ mlx5_open_xrcd(struct ibv_context *context,
 {
 	int err;
 	struct verbs_xrcd *xrcd;
-	struct ibv_open_xrcd cmd = {0};
-	struct ibv_open_xrcd_resp resp = {0};
+	struct ibv_open_xrcd cmd = {};
+	struct ibv_open_xrcd_resp resp = {};
 
 	xrcd = calloc(1, sizeof(*xrcd));
 	if (!xrcd)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
