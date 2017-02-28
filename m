From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v8 06/11] uapi: includes linux/types.h before exporting files
Date: Tue, 28 Feb 2017 21:47:32 +0100
Message-ID: <1488314857-28327-7-git-send-email-nicolas.dichtel@6wind.com>
References: <20170228024844.GA28691@altlinux.org>
 <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: arnd@arndb.de, mmarek@suse.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Some files will be exported after the next patch. 0-day tests report the
following warning/error:
./usr/include/linux/bcache.h:8: include of <linux/types.h> is preferred over <asm/types.h>
./usr/include/linux/bcache.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/linux/qrtr.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/linux/cryptouser.h:39: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/linux/pr.h:14: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/linux/btrfs_tree.h:337: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/rdma/bnxt_re-abi.h:45: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/uapi/linux/bcache.h     | 2 +-
 include/uapi/linux/btrfs_tree.h | 2 ++
 include/uapi/linux/cryptouser.h | 2 ++
 include/uapi/linux/pr.h         | 2 ++
 include/uapi/linux/qrtr.h       | 1 +
 include/uapi/rdma/bnxt_re-abi.h | 2 ++
 6 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 22b6ad31c706..e3bb0635e94a 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -5,7 +5,7 @@
  * Bcache on disk data structures
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define BITMASK(name, type, field, offset, size)		\
 static inline __u64 name(const type *k)				\
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index d5ad15a106a7..6a261cb52d95 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1,6 +1,8 @@
 #ifndef _BTRFS_CTREE_H_
 #define _BTRFS_CTREE_H_
 
+#include <linux/types.h>
+
 /*
  * This header contains the structure definitions and constants used
  * by file system objects that can be retrieved using
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 11d21fce14d6..c6a09c5261e7 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -18,6 +18,8 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/types.h>
+
 /* Netlink configuration messages.  */
 enum {
 	CRYPTO_MSG_BASE = 0x10,
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index 57d7c0f916b6..645ef3cf3dd0 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -1,6 +1,8 @@
 #ifndef _UAPI_PR_H
 #define _UAPI_PR_H
 
+#include <linux/types.h>
+
 enum pr_type {
 	PR_WRITE_EXCLUSIVE		= 1,
 	PR_EXCLUSIVE_ACCESS		= 2,
diff --git a/include/uapi/linux/qrtr.h b/include/uapi/linux/qrtr.h
index 66c0748d26e2..b14ee91ec387 100644
--- a/include/uapi/linux/qrtr.h
+++ b/include/uapi/linux/qrtr.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_QRTR_H
 #define _LINUX_QRTR_H
 
+#include <linux/types.h>
 #include <linux/socket.h>
 
 struct sockaddr_qrtr {
diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_re-abi.h
index e2c8a3f0ccec..74018bd18d72 100644
--- a/include/uapi/rdma/bnxt_re-abi.h
+++ b/include/uapi/rdma/bnxt_re-abi.h
@@ -39,6 +39,8 @@
 #ifndef __BNXT_RE_UVERBS_ABI_H__
 #define __BNXT_RE_UVERBS_ABI_H__
 
+#include <linux/types.h>
+
 #define BNXT_RE_ABI_VERSION	1
 
 struct bnxt_re_uctx_resp {
-- 
2.8.1

