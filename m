From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v15 05/17] arms64: untag user pointers passed to memory
 syscalls
Date: Tue, 28 May 2019 14:05:18 +0100
Message-ID: <20190528130518.GB32006@arrakis.emea.arm.com>
References: <cover.1557160186.git.andreyknvl@google.com>
 <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 06, 2019 at 06:30:51PM +0200, Andrey Konovalov wrote:
>  /*
>   * Wrappers to pass the pt_regs argument.
>   */
>  #define sys_personality		sys_arm64_personality
> +#define sys_mmap_pgoff		sys_arm64_mmap_pgoff
> +#define sys_mremap		sys_arm64_mremap
> +#define sys_munmap		sys_arm64_munmap
> +#define sys_brk			sys_arm64_brk
> +#define sys_get_mempolicy	sys_arm64_get_mempolicy
> +#define sys_madvise		sys_arm64_madvise
> +#define sys_mbind		sys_arm64_mbind
> +#define sys_mlock		sys_arm64_mlock
> +#define sys_mlock2		sys_arm64_mlock2
> +#define sys_munlock		sys_arm64_munlock
> +#define sys_mprotect		sys_arm64_mprotect
> +#define sys_msync		sys_arm64_msync
> +#define sys_mincore		sys_arm64_mincore
> +#define sys_remap_file_pages	sys_arm64_remap_file_pages
> +#define sys_shmat		sys_arm64_shmat
> +#define sys_shmdt		sys_arm64_shmdt

This hunk should be (I sent a separate patch for sys_personality):

@@ -160,23 +163,23 @@ SYSCALL_DEFINE1(arm64_shmdt, char __user *, shmaddr)
 /*
  * Wrappers to pass the pt_regs argument.
  */
-#define sys_personality		sys_arm64_personality
-#define sys_mmap_pgoff		sys_arm64_mmap_pgoff
-#define sys_mremap		sys_arm64_mremap
-#define sys_munmap		sys_arm64_munmap
-#define sys_brk			sys_arm64_brk
-#define sys_get_mempolicy	sys_arm64_get_mempolicy
-#define sys_madvise		sys_arm64_madvise
-#define sys_mbind		sys_arm64_mbind
-#define sys_mlock		sys_arm64_mlock
-#define sys_mlock2		sys_arm64_mlock2
-#define sys_munlock		sys_arm64_munlock
-#define sys_mprotect		sys_arm64_mprotect
-#define sys_msync		sys_arm64_msync
-#define sys_mincore		sys_arm64_mincore
-#define sys_remap_file_pages	sys_arm64_remap_file_pages
-#define sys_shmat		sys_arm64_shmat
-#define sys_shmdt		sys_arm64_shmdt
+#define __arm64_sys_personality		__arm64_sys_arm64_personality
+#define __arm64_sys_mmap_pgoff		__arm64_sys_arm64_mmap_pgoff
+#define __arm64_sys_mremap		__arm64_sys_arm64_mremap
+#define __arm64_sys_munmap		__arm64_sys_arm64_munmap
+#define __arm64_sys_brk			__arm64_sys_arm64_brk
+#define __arm64_sys_get_mempolicy	__arm64_sys_arm64_get_mempolicy
+#define __arm64_sys_madvise		__arm64_sys_arm64_madvise
+#define __arm64_sys_mbind		__arm64_sys_arm64_mbind
+#define __arm64_sys_mlock		__arm64_sys_arm64_mlock
+#define __arm64_sys_mlock2		__arm64_sys_arm64_mlock2
+#define __arm64_sys_munlock		__arm64_sys_arm64_munlock
+#define __arm64_sys_mprotect		__arm64_sys_arm64_mprotect
+#define __arm64_sys_msync		__arm64_sys_arm64_msync
+#define __arm64_sys_mincore		__arm64_sys_arm64_mincore
+#define __arm64_sys_remap_file_pages	__arm64_sys_arm64_remap_file_pages
+#define __arm64_sys_shmat		__arm64_sys_arm64_shmat
+#define __arm64_sys_shmdt		__arm64_sys_arm64_shmdt
 
 asmlinkage long sys_ni_syscall(const struct pt_regs *);
 #define __arm64_sys_ni_syscall	sys_ni_syscall

-- 
Catalin
