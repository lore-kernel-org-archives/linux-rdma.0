From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] infiniband: mutex header included twice in cxgb4 header
Date: Sat, 30 Oct 2010 15:23:01 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1010301519010.7979@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

drivers/infiniband/hw/cxgb4/iw_cxgb4.h includes 'linux/mutex.h' twice, 
this removes the duplicate.

(please CC me on replies)


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 iw_cxgb4.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 16032cd..42bb575 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -46,7 +46,6 @@
 #include <linux/timer.h>
 #include <linux/io.h>
 #include <linux/kfifo.h>
-#include <linux/mutex.h>
 
 #include <asm/byteorder.h>
 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
