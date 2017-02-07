From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc] RDMA: Remove kernel private defines and reference to header from UAPI
Date: Tue,  7 Feb 2017 19:46:00 +0200
Message-ID: <20170207174600.27218-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove references to private kernel header and defines from exported
ib_user_verb.h file.

The code snippet below is used to reproduce the issue:

 #include <stdio.h>
 #include <rdma/ib_user_verb.h>

 int main(void)
 {
	printf("IB_USER_VERBS_ABI_VERSION = %d\n", IB_USER_VERBS_ABI_VERSION);
	return 0;
 }

It fails during compilation phase with an error:
➜  /tmp gcc main.c
main.c:2:31: fatal error: rdma/ib_user_verb.h: No such file or directory
 #include <rdma/ib_user_verb.h>
                               ^
compilation terminated.

Fixes: 189aba99e700 ("IB/uverbs: Extend modify_qp and support packet pacing")
CC: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reported-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/ib_user_verbs.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index dfdfe4e92d31..c56f525b041d 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -37,7 +37,6 @@
 #define IB_USER_VERBS_H

 #include <linux/types.h>
-#include <rdma/ib_verbs.h>

 /*
  * Increment this value if any changes that break userspace ABI
@@ -548,11 +547,11 @@ enum {
 };

 enum {
-	IB_USER_LEGACY_LAST_QP_ATTR_MASK = IB_QP_DEST_QPN
+	IB_USER_LEGACY_LAST_QP_ATTR_MASK = 1ULL << 20,
 };

 enum {
-	IB_USER_LAST_QP_ATTR_MASK = IB_QP_RATE_LIMIT
+	IB_USER_LAST_QP_ATTR_MASK = 1ULL << 25,
 };

 struct ib_uverbs_ex_create_qp {
--
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
