From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v8 07/11] btrfs_tree.h: fix include from userland
Date: Tue, 28 Feb 2017 21:47:33 +0100
Message-ID: <1488314857-28327-8-git-send-email-nicolas.dichtel@6wind.com>
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

This patch prepares the uapi export by fixing the following errors:

.../linux/btrfs_tree.h:283:2: error: #error "UUID items require BTRFS_UUID_SIZE == 16!"
 #error "UUID items require BTRFS_UUID_SIZE == 16!"

.../linux/btrfs_tree.h:390:12: error: ‘BTRFS_UUID_SIZE’ undeclared here (not in a function)
  __u8 uuid[BTRFS_UUID_SIZE];
            ^
.../linux/btrfs_tree.h:796:16: error: ‘BTRFS_DEV_STAT_VALUES_MAX’ undeclared here (not in a function)
  __le64 values[BTRFS_DEV_STAT_VALUES_MAX];

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/uapi/linux/btrfs_tree.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 6a261cb52d95..6a754ada59af 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -2,6 +2,7 @@
 #define _BTRFS_CTREE_H_
 
 #include <linux/types.h>
+#include <linux/btrfs.h>
 
 /*
  * This header contains the structure definitions and constants used
-- 
2.8.1
