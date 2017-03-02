From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v9 01/11] h8300: put bitsperlong.h in uapi
Date: Thu,  2 Mar 2017 17:56:32 +0100
Message-ID: <1488473802-13354-2-git-send-email-nicolas.dichtel@6wind.com>
References: <20170301045241.GB9156@gondor.apana.org.au>
 <1488473802-13354-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1488473802-13354-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: arnd@arndb.de, mmarek@suse.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This header file is exported, thus move it to uapi.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 arch/h8300/include/asm/bitsperlong.h      | 14 --------------
 arch/h8300/include/uapi/asm/bitsperlong.h | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)
 delete mode 100644 arch/h8300/include/asm/bitsperlong.h
 create mode 100644 arch/h8300/include/uapi/asm/bitsperlong.h

diff --git a/arch/h8300/include/asm/bitsperlong.h b/arch/h8300/include/asm/bitsperlong.h
deleted file mode 100644
index e140e46729ac..000000000000
--- a/arch/h8300/include/asm/bitsperlong.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef __ASM_H8300_BITS_PER_LONG
-#define __ASM_H8300_BITS_PER_LONG
-
-#include <asm-generic/bitsperlong.h>
-
-#if !defined(__ASSEMBLY__)
-/* h8300-unknown-linux required long */
-#define __kernel_size_t __kernel_size_t
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-#endif
-
-#endif /* __ASM_H8300_BITS_PER_LONG */
diff --git a/arch/h8300/include/uapi/asm/bitsperlong.h b/arch/h8300/include/uapi/asm/bitsperlong.h
new file mode 100644
index 000000000000..e56cf72369b6
--- /dev/null
+++ b/arch/h8300/include/uapi/asm/bitsperlong.h
@@ -0,0 +1,14 @@
+#ifndef _UAPI_ASM_H8300_BITS_PER_LONG
+#define _UAPI_ASM_H8300_BITS_PER_LONG
+
+#include <asm-generic/bitsperlong.h>
+
+#if !defined(__ASSEMBLY__)
+/* h8300-unknown-linux required long */
+#define __kernel_size_t __kernel_size_t
+typedef unsigned long	__kernel_size_t;
+typedef long		__kernel_ssize_t;
+typedef long		__kernel_ptrdiff_t;
+#endif
+
+#endif /* _UAPI_ASM_H8300_BITS_PER_LONG */
-- 
2.8.1

