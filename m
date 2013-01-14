From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [librdmacm] rsockets: Add support for existing UDP apps
Date: Mon, 14 Jan 2013 16:30:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237357D3993D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support for existing UDP applications is done via the rspreload
library.  However, when the preload library is loaded, socket
calls used by rsockets get intercepted and converted into
rsocket calls.

The preload library was able to handle this for TCP rsockets
by using a per thread variable and checking for recursive calls
coming from rsockets back into the preload library.  The preload
library would direct such calls to the real socket calls.

The problem is more complex for UDP rsockets, which can invoke
socket calls from an internal rsocket thread.  The result is that
the preload library intercepts socket calls that originate from
the rsocket library which are not recursive.

Although, this is really a problem with the preload library,
the simplest solution is for rsockets to fully initialize the
library when allocating the first rsocket, versus deferring
initialization until required.  The preload library can then
detect the recursive calls.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 7be42ca..9b6c667 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2008-2013 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -452,6 +452,10 @@ void rs_configure(void)
 	if (init)
 		goto out;
 
+	if (ucma_init())
+		goto out;
+	ucma_ib_init();
+
 	if ((f = fopen(RS_CONF_DIR "/polling_time", "r"))) {
 		(void) fscanf(f, "%u", &polling_time);
 		fclose(f);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
