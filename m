From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v8 08/11] cryptouser.h: fix include from userland
Date: Tue, 28 Feb 2017 21:47:34 +0100
Message-ID: <1488314857-28327-9-git-send-email-nicolas.dichtel@6wind.com>
References: <20170228024844.GA28691@altlinux.org>
 <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, mmarek@suse.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch prepares the uapi export by fixing the following error:

.../linux/cryptouser.h:58:16: error: ‘CRYPTO_MAX_ALG_NAME’ undeclared here (not in a function)
  char cru_name[CRYPTO_MAX_ALG_NAME];

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/linux/crypto.h          | 2 +-
 include/uapi/linux/cryptouser.h | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index c0b0cf3d2d2f..4cf29a35bb4b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <uapi/linux/cryptouser.h>
 
 /*
  * Autoloaded crypto modules should only use a prefixed name to avoid allowing
@@ -123,7 +124,6 @@
 /*
  * Miscellaneous stuff.
  */
-#define CRYPTO_MAX_ALG_NAME		64
 
 /*
  * The macro CRYPTO_MINALIGN_ATTR (along with the void * type in the actual
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index c6a09c5261e7..05fcf1393b4d 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -18,6 +18,9 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#ifndef _UAPI_CRYPTOUSER_H
+#define _UAPI_CRYPTOUSER_H
+
 #include <linux/types.h>
 
 /* Netlink configuration messages.  */
@@ -54,6 +57,8 @@ enum crypto_attr_type_t {
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
 };
 
+#define CRYPTO_MAX_ALG_NAME		64
+
 struct crypto_user_alg {
 	char cru_name[CRYPTO_MAX_ALG_NAME];
 	char cru_driver_name[CRYPTO_MAX_ALG_NAME];
@@ -121,3 +126,5 @@ struct crypto_report_acomp {
 
 #define CRYPTO_REPORT_MAXSIZE (sizeof(struct crypto_user_alg) + \
 			       sizeof(struct crypto_report_blkcipher))
+
+#endif /* _UAPI_CRYPTOUSER_H */
-- 
2.8.1
