From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v11 08/12] cryptouser.h: fix include from userland
Date: Mon, 27 Mar 2017 14:20:13 +0200
Message-ID: <1490617217-30192-9-git-send-email-nicolas.dichtel@6wind.com>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yamada.masahiro@socionext.com
Cc: arnd@arndb.de, mmarek@suse.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch prepares the uapi export by fixing the following error:

.../linux/cryptouser.h:58:16: error: ‘CRYPTO_MAX_ALG_NAME’ undeclared here (not in a function)
  char cru_name[CRYPTO_MAX_ALG_NAME];

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/linux/crypto.h          |  2 +-
 include/uapi/linux/crypto.h     | 14 ++++++++++++++
 include/uapi/linux/cryptouser.h |  6 ++++++
 3 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/crypto.h

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index c0b0cf3d2d2f..cc2425ba8527 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <uapi/linux/crypto.h>
 
 /*
  * Autoloaded crypto modules should only use a prefixed name to avoid allowing
@@ -123,7 +124,6 @@
 /*
  * Miscellaneous stuff.
  */
-#define CRYPTO_MAX_ALG_NAME		64
 
 /*
  * The macro CRYPTO_MINALIGN_ATTR (along with the void * type in the actual
diff --git a/include/uapi/linux/crypto.h b/include/uapi/linux/crypto.h
new file mode 100644
index 000000000000..e342c5a5ac50
--- /dev/null
+++ b/include/uapi/linux/crypto.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (c) 2017 Nicolas Dichtel <nicolas.dichtel@6wind.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef _UAPI_CRYPTO_H
+#define _UAPI_CRYPTO_H
+
+#define CRYPTO_MAX_ALG_NAME		64
+
+#endif /* _UAPI_CRYPTO_H */
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index c6a09c5261e7..751e7daef54a 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -18,6 +18,10 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#ifndef _UAPI_CRYPTOUSER_H
+#define _UAPI_CRYPTOUSER_H
+
+#include <linux/crypto.h>
 #include <linux/types.h>
 
 /* Netlink configuration messages.  */
@@ -121,3 +125,5 @@ struct crypto_report_acomp {
 
 #define CRYPTO_REPORT_MAXSIZE (sizeof(struct crypto_user_alg) + \
 			       sizeof(struct crypto_report_blkcipher))
+
+#endif /* _UAPI_CRYPTOUSER_H */
-- 
2.8.1
