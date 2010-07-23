From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/6] librdmacm/man: add rdma_get_request man page to release
Date: Thu, 22 Jul 2010 21:08:35 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 4ddbcfa..c752b4f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -70,6 +70,7 @@ man_MANS = \
 	man/rdma_resolve_route.3 \
 	man/rdma_event_str.3 \
 	man/rdma_set_option.3 \
+	man/rdma_get_request.3 \
 	man/rdma_create_ep.3 \
 	man/rdma_destroy_ep.3 \
 	man/rdma_getaddrinfo.3 \


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
