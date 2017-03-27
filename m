From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v11 03/12] x86: stop exporting msr-index.h to userland
Date: Mon, 27 Mar 2017 14:20:08 +0200
Message-ID: <1490617217-30192-4-git-send-email-nicolas.dichtel@6wind.com>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yamada.masahiro@socionext.com
Cc: arnd@arndb.de, mmarek@suse.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Even if this file was not in an uapi directory, it was exported because
it was listed in the Kbuild file.

Fixes: b72e7464e4cf ("x86/uapi: Do not export <asm/msr-index.h> as part of the user API headers")
Suggested-by: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/uapi/asm/Kbuild | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/Kbuild b/arch/x86/include/uapi/asm/Kbuild
index 3dec769cadf7..1c532b3f18ea 100644
--- a/arch/x86/include/uapi/asm/Kbuild
+++ b/arch/x86/include/uapi/asm/Kbuild
@@ -27,7 +27,6 @@ header-y += ldt.h
 header-y += mce.h
 header-y += mman.h
 header-y += msgbuf.h
-header-y += msr-index.h
 header-y += msr.h
 header-y += mtrr.h
 header-y += param.h
-- 
2.8.1
