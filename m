From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] opensm: Remove duplicate definition of
 IB_MAD_STATUS_CLASS_MASK
Date: Thu, 28 Apr 2011 16:21:47 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F4185@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Alex Netes (alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

osmtest includes a duplicate definition.  Remove it.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 osmtest/osmtest.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 osmtest/osmtest.c

diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
old mode 100644
new mode 100755
index 7ecc8ce..9f35d02
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -221,8 +221,6 @@ const osmtest_token_t token_array[] = {
 	{OSMTEST_TOKEN_UNKNOWN, 0, ""}	/* must be last entry */
 };
 
-#define IB_MAD_STATUS_CLASS_MASK       (CL_HTON16(0xFF00))
-
 static const char ib_mad_status_str_busy[] = "IB_MAD_STATUS_BUSY";
 static const char ib_mad_status_str_redirect[] = "IB_MAD_STATUS_REDIRECT";
 static const char ib_mad_status_str_unsup_class_ver[] =


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
