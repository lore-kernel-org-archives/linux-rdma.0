From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] remove unused headers in
	libibnetdiscover
Date: Tue, 03 Nov 2009 10:37:29 -0800
Message-ID: <1257273449.580.54.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-pk/phXkOh4xcEnOLvqPK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-pk/phXkOh4xcEnOLvqPK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

Just noticed it.  Left over/cut and pasted from the original
ibnetdiscover tool code or no longer necessary due to recent changes.
This patch is independent of the other patches I recently posted.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-pk/phXkOh4xcEnOLvqPK
Content-Disposition: attachment; filename=0001-remove-unused-headers.patch
Content-Type: text/plain; name=0001-remove-unused-headers.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Nov 2009 10:33:08 -0800
Subject: [PATCH] remove unused headers


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index ebc45ba..bd28ba7 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -41,10 +41,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <stdarg.h>
-#include <time.h>
 #include <string.h>
-#include <getopt.h>
 #include <errno.h>
 #include <inttypes.h>
 
-- 
1.5.4.5


--=-pk/phXkOh4xcEnOLvqPK--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
