From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v11 12/12] arch/include: remove empty Kbuild files
Date: Mon, 27 Mar 2017 14:20:17 +0200
Message-ID: <1490617217-30192-13-git-send-email-nicolas.dichtel@6wind.com>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-arch-owner@vger.kernel.org
To: yamada.masahiro@socionext.com
Cc: arnd@arndb.de, mmarek@suse.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 arch/cris/include/arch-v10/arch/Kbuild | 1 -
 arch/cris/include/arch-v32/arch/Kbuild | 1 -
 arch/tile/include/arch/Kbuild          | 1 -
 3 files changed, 3 deletions(-)
 delete mode 100644 arch/cris/include/arch-v10/arch/Kbuild
 delete mode 100644 arch/cris/include/arch-v32/arch/Kbuild
 delete mode 100644 arch/tile/include/arch/Kbuild

diff --git a/arch/cris/include/arch-v10/arch/Kbuild b/arch/cris/include/arch-v10/arch/Kbuild
deleted file mode 100644
index 1f0fc7a66f5f..000000000000
--- a/arch/cris/include/arch-v10/arch/Kbuild
+++ /dev/null
@@ -1 +0,0 @@
-# CRISv10 arch
diff --git a/arch/cris/include/arch-v32/arch/Kbuild b/arch/cris/include/arch-v32/arch/Kbuild
deleted file mode 100644
index 2fd65c7e15c9..000000000000
--- a/arch/cris/include/arch-v32/arch/Kbuild
+++ /dev/null
@@ -1 +0,0 @@
-# CRISv32 arch
diff --git a/arch/tile/include/arch/Kbuild b/arch/tile/include/arch/Kbuild
deleted file mode 100644
index 3751c9fabcf2..000000000000
--- a/arch/tile/include/arch/Kbuild
+++ /dev/null
@@ -1 +0,0 @@
-# Tile arch headers
-- 
2.8.1
