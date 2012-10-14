From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch libibverbs 2/5] Don't allow port == 0 as an option
Date: Sun, 14 Oct 2012 13:03:00 -0400
Message-ID: <c04e55cf1596cd2ac81de4d58b1e8f8b36b52bca.1350234101.git.dledford@redhat.com>
References: <cover.1350234101.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We special case port == 0 to mean all ports, and it's the default,
so if a user passes in 0, they likely meant 1 instead.  Throw an
error because they probably didn't mean to specify the default
behavior of scan all ports.  Path of least surprise and all that.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 examples/devinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index b1a3b2e..d6e9218 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -385,7 +385,7 @@ int main(int argc, char *argv[])
 
 		case 'i':
 			ib_port = strtol(optarg, NULL, 0);
-			if (ib_port < 0) {
+			if (ib_port <= 0) {
 				usage(argv[0]);
 				return 1;
 			}
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
