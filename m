From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 18/28] verbs: Fix clang 3.6 warning -Wtautological-compare
Date: Mon,  5 Sep 2016 15:08:08 -0600
Message-ID: <1473109698-31408-19-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The signededness of a 'enum X' is undefined in the C standard,
compilers are free to use any type they like. So, coercing -1 into
an enum and expecting '< 0' to work is undefined behaviour, and as
the warning shows at least clang miscompiles this code.

Instead use 0 to indicate undefined MTU from pp_mtu_to_enum,
0 is unused in the mtu enum.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/examples/pingpong.c      | 2 +-
 libibverbs/examples/rc_pingpong.c   | 2 +-
 libibverbs/examples/srq_pingpong.c  | 2 +-
 libibverbs/examples/uc_pingpong.c   | 2 +-
 libibverbs/examples/xsrq_pingpong.c | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libibverbs/examples/pingpong.c b/libibverbs/examples/pingpong.c
index 2fe4a04115fb..f6a50e9c62aa 100644
--- a/libibverbs/examples/pingpong.c
+++ b/libibverbs/examples/pingpong.c
@@ -44,7 +44,7 @@ enum ibv_mtu pp_mtu_to_enum(int mtu)
 	case 1024: return IBV_MTU_1024;
 	case 2048: return IBV_MTU_2048;
 	case 4096: return IBV_MTU_4096;
-	default:   return -1;
+	default:   return 0;
 	}
 }
 
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 967678362833..1fad16a0be7c 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -768,7 +768,7 @@ int main(int argc, char *argv[])
 
 		case 'm':
 			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			if (mtu == 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index a1061c31972d..929b736545c7 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -697,7 +697,7 @@ int main(int argc, char *argv[])
 
 		case 'm':
 			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			if (mtu == 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
index b25d16c79021..3802e3821773 100644
--- a/libibverbs/examples/uc_pingpong.c
+++ b/libibverbs/examples/uc_pingpong.c
@@ -604,7 +604,7 @@ int main(int argc, char *argv[])
 
 		case 'm':
 			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			if (mtu == 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
index ff00180f2644..a7e345f3850c 100644
--- a/libibverbs/examples/xsrq_pingpong.c
+++ b/libibverbs/examples/xsrq_pingpong.c
@@ -906,7 +906,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'm':
 			ctx.mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (ctx.mtu < 0) {
+			if (ctx.mtu == 0) {
 				usage(argv[0]);
 				return 1;
 			}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
