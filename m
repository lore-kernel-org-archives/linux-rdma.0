From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v15 05/17] arms64: untag user pointers passed to memory
 syscalls
Date: Fri, 24 May 2019 16:41:44 +0100
Message-ID: <20190524154143.GG8268@e119886-lin.cambridge.arm.com>
References: <cover.1557160186.git.andreyknvl@google.com>
 <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kostya Serebryany <kcc@google.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 06, 2019 at 06:30:51PM +0200, Andrey Konovalov wrote:
> This patch is a part of a series that extends arm64 kernel ABI to allow to
> pass tagged user pointers (with the top byte set to something else other
> than 0x00) as syscall arguments.
> 
> This patch allows tagged pointers to be passed to the following memory
> syscalls: brk, get_mempolicy, madvise, mbind, mincore, mlock, mlock2,
> mmap, mmap_pgoff, mprotect, mremap, msync, munlock, munmap,
> remap_file_pages, shmat and shmdt.
> 
> This is done by untagging pointers passed to these syscalls in the
> prologues of their handlers.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---


> +SYSCALL_DEFINE2(arm64_mlock, unsigned long, start, size_t, len)
> +{
> +	start = untagged_addr(start);
> +	return ksys_mlock(start, len, VM_LOCKED);
> +}
> +
> +SYSCALL_DEFINE2(arm64_mlock2, unsigned long, start, size_t, len)
> +{
> +	start = untagged_addr(start);
> +	return ksys_mlock(start, len, VM_LOCKED);
> +}

I think this may be a copy/paste error...

Shouldn't mlock2 have a third 'flags' argument to distinguish is from mlock?

Thanks,

Andrew Murray

> +
> +SYSCALL_DEFINE2(arm64_munlock, unsigned long, start, size_t, len)
> +{
> +	start = untagged_addr(start);
> +	return ksys_munlock(start, len);
> +}
> +
> +SYSCALL_DEFINE3(arm64_mprotect, unsigned long, start, size_t, len,
> +		unsigned long, prot)
> +{
> +	start = untagged_addr(start);
> +	return ksys_mprotect_pkey(start, len, prot, -1);
> +}
> +
> +SYSCALL_DEFINE3(arm64_msync, unsigned long, start, size_t, len, int, flags)
> +{
> +	start = untagged_addr(start);
> +	return ksys_msync(start, len, flags);
> +}
> +
> +SYSCALL_DEFINE3(arm64_mincore, unsigned long, start, size_t, len,
> +		unsigned char __user *, vec)
> +{
> +	start = untagged_addr(start);
> +	return ksys_mincore(start, len, vec);
> +}
> +
> +SYSCALL_DEFINE5(arm64_remap_file_pages, unsigned long, start,
> +		unsigned long, size, unsigned long, prot,
> +		unsigned long, pgoff, unsigned long, flags)
> +{
> +	start = untagged_addr(start);
> +	return ksys_remap_file_pages(start, size, prot, pgoff, flags);
> +}
> +
> +SYSCALL_DEFINE3(arm64_shmat, int, shmid, char __user *, shmaddr, int, shmflg)
> +{
> +	shmaddr = untagged_addr(shmaddr);
> +	return ksys_shmat(shmid, shmaddr, shmflg);
> +}
> +
> +SYSCALL_DEFINE1(arm64_shmdt, char __user *, shmaddr)
> +{
> +	shmaddr = untagged_addr(shmaddr);
> +	return ksys_shmdt(shmaddr);
> +}
> +
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
>  
>  asmlinkage long sys_ni_syscall(const struct pt_regs *);
>  #define __arm64_sys_ni_syscall	sys_ni_syscall
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
