From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC 10/12] ib-mgmt: remove duplicate definition of
 IB_MAD_STATUS_CLASS_MASK
Date: Sat, 23 Oct 2010 00:11:37 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7FA@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

osmtest includes a duplicate definition.  Remove it.  The update
to ib_types.h results in a build warning without this fix.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 opensm/osmtest/osmtest.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 opensm/osmtest/osmtest.c

diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
old mode 100644
new mode 100755
index b2ec3fa..47d2368
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
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
