From: Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH v15 05/17] arms64: untag user pointers passed to memory
 syscalls
Date: Mon,  6 May 2019 18:30:51 +0200
Message-ID: <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
References: <cover.1557160186.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1557160186.git.andreyknvl@google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kostya Serebryany <kcc@google.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Lee Smith <Lee.Smith@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>, Jens Wiklander <jens.wiklander@linaro.org>, Ramana
List-Id: linux-rdma@vger.kernel.org

This patch is a part of a series that extends arm64 kernel ABI to allow to
pass tagged user pointers (with the top byte set to something else other
than 0x00) as syscall arguments.

This patch allows tagged pointers to be passed to the following memory
syscalls: brk, get_mempolicy, madvise, mbind, mincore, mlock, mlock2,
mmap, mmap_pgoff, mprotect, mremap, msync, munlock, munmap,
remap_file_pages, shmat and shmdt.

This is done by untagging pointers passed to these syscalls in the
prologues of their handlers.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 arch/arm64/kernel/sys.c | 128 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 127 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index b44065fb1616..933bb9f3d6ec 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -35,10 +35,33 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 {
 	if (offset_in_page(off) != 0)
 		return -EINVAL;
-
+	addr = untagged_addr(addr);
 	return ksys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
 }
 
+SYSCALL_DEFINE6(arm64_mmap_pgoff, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, pgoff)
+{
+	addr = untagged_addr(addr);
+	return ksys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
+}
+
+SYSCALL_DEFINE5(arm64_mremap, unsigned long, addr, unsigned long, old_len,
+		unsigned long, new_len, unsigned long, flags,
+		unsigned long, new_addr)
+{
+	addr = untagged_addr(addr);
+	new_addr = untagged_addr(new_addr);
+	return ksys_mremap(addr, old_len, new_len, flags, new_addr);
+}
+
+SYSCALL_DEFINE2(arm64_munmap, unsigned long, addr, size_t, len)
+{
+	addr = untagged_addr(addr);
+	return ksys_munmap(addr, len);
+}
+
 SYSCALL_DEFINE1(arm64_personality, unsigned int, personality)
 {
 	if (personality(personality) == PER_LINUX32 &&
@@ -47,10 +70,113 @@ SYSCALL_DEFINE1(arm64_personality, unsigned int, personality)
 	return ksys_personality(personality);
 }
 
+SYSCALL_DEFINE1(arm64_brk, unsigned long, brk)
+{
+	brk = untagged_addr(brk);
+	return ksys_brk(brk);
+}
+
+SYSCALL_DEFINE5(arm64_get_mempolicy, int __user *, policy,
+		unsigned long __user *, nmask, unsigned long, maxnode,
+		unsigned long, addr, unsigned long, flags)
+{
+	addr = untagged_addr(addr);
+	return ksys_get_mempolicy(policy, nmask, maxnode, addr, flags);
+}
+
+SYSCALL_DEFINE3(arm64_madvise, unsigned long, start,
+		size_t, len_in, int, behavior)
+{
+	start = untagged_addr(start);
+	return ksys_madvise(start, len_in, behavior);
+}
+
+SYSCALL_DEFINE6(arm64_mbind, unsigned long, start, unsigned long, len,
+		unsigned long, mode, const unsigned long __user *, nmask,
+		unsigned long, maxnode, unsigned int, flags)
+{
+	start = untagged_addr(start);
+	return ksys_mbind(start, len, mode, nmask, maxnode, flags);
+}
+
+SYSCALL_DEFINE2(arm64_mlock, unsigned long, start, size_t, len)
+{
+	start = untagged_addr(start);
+	return ksys_mlock(start, len, VM_LOCKED);
+}
+
+SYSCALL_DEFINE2(arm64_mlock2, unsigned long, start, size_t, len)
+{
+	start = untagged_addr(start);
+	return ksys_mlock(start, len, VM_LOCKED);
+}
+
+SYSCALL_DEFINE2(arm64_munlock, unsigned long, start, size_t, len)
+{
+	start = untagged_addr(start);
+	return ksys_munlock(start, len);
+}
+
+SYSCALL_DEFINE3(arm64_mprotect, unsigned long, start, size_t, len,
+		unsigned long, prot)
+{
+	start = untagged_addr(start);
+	return ksys_mprotect_pkey(start, len, prot, -1);
+}
+
+SYSCALL_DEFINE3(arm64_msync, unsigned long, start, size_t, len, int, flags)
+{
+	start = untagged_addr(start);
+	return ksys_msync(start, len, flags);
+}
+
+SYSCALL_DEFINE3(arm64_mincore, unsigned long, start, size_t, len,
+		unsigned char __user *, vec)
+{
+	start = untagged_addr(start);
+	return ksys_mincore(start, len, vec);
+}
+
+SYSCALL_DEFINE5(arm64_remap_file_pages, unsigned long, start,
+		unsigned long, size, unsigned long, prot,
+		unsigned long, pgoff, unsigned long, flags)
+{
+	start = untagged_addr(start);
+	return ksys_remap_file_pages(start, size, prot, pgoff, flags);
+}
+
+SYSCALL_DEFINE3(arm64_shmat, int, shmid, char __user *, shmaddr, int, shmflg)
+{
+	shmaddr = untagged_addr(shmaddr);
+	return ksys_shmat(shmid, shmaddr, shmflg);
+}
+
+SYSCALL_DEFINE1(arm64_shmdt, char __user *, shmaddr)
+{
+	shmaddr = untagged_addr(shmaddr);
+	return ksys_shmdt(shmaddr);
+}
+
 /*
  * Wrappers to pass the pt_regs argument.
  */
 #define sys_personality		sys_arm64_personality
+#define sys_mmap_pgoff		sys_arm64_mmap_pgoff
+#define sys_mremap		sys_arm64_mremap
+#define sys_munmap		sys_arm64_munmap
+#define sys_brk			sys_arm64_brk
+#define sys_get_mempolicy	sys_arm64_get_mempolicy
+#define sys_madvise		sys_arm64_madvise
+#define sys_mbind		sys_arm64_mbind
+#define sys_mlock		sys_arm64_mlock
+#define sys_mlock2		sys_arm64_mlock2
+#define sys_munlock		sys_arm64_munlock
+#define sys_mprotect		sys_arm64_mprotect
+#define sys_msync		sys_arm64_msync
+#define sys_mincore		sys_arm64_mincore
+#define sys_remap_file_pages	sys_arm64_remap_file_pages
+#define sys_shmat		sys_arm64_shmat
+#define sys_shmdt		sys_arm64_shmdt
 
 asmlinkage long sys_ni_syscall(const struct pt_regs *);
 #define __arm64_sys_ni_syscall	sys_ni_syscall
-- 
2.21.0.1020.gf2820cf01a-goog
