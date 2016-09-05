From: Ana Guerrero =?iso-8859-1?Q?L=F3pez?= <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
Subject: [infiniband-diags PATCH 3/4] Update the shebang to point to /bin/bash
Date: Mon, 5 Sep 2016 23:49:02 +0200
Message-ID: <20160905214902.GA9765@pryan.ekaia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The script contains a few bashims and it won't run in systems such as Debian
and Ubuntu where /bin/sh is not a symlink to /bin/bash

Signed-off-by: Ana Guerrero López <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
---
 doc/generate | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/generate b/doc/generate
index 816b66f..b1339f8 100755
--- a/doc/generate
+++ b/doc/generate
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 docdir=`dirname $0`
 mode=$1
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
