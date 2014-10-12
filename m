From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 1/3] s390/kernel: add system calls for access PCI memory
Date: Sun, 12 Oct 2014 11:52:55 +0000
Message-ID: <f061a36c713c42c9b71530183a6e8644@AMSPR05MB422.eurprd05.prod.outlook.com>
References: <1412933657-52641-1-git-send-email-aishchuk@linux.vnet.ibm.com>
 <1412933657-52641-2-git-send-email-aishchuk@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412933657-52641-2-git-send-email-aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Alexey Ishchuk
> Sent: Friday, October 10, 2014 12:34 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org; schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org;
> gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org; utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Yishai
> Hadas; Alexey Ishchuk; Alexey Ishchuk
> Subject: [PATCH 1/3] s390/kernel: add system calls for access PCI memory
> 
> Add the new __NR_s390_pci_mmio_write and __NR_s390_pci_mmio_read
> system calls to allow user space applications to access device PCI I/O
> memory pages on s390x platform.
> 
> Signed-off-by: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/s390/include/uapi/asm/unistd.h |   4 +-
>  arch/s390/kernel/Makefile           |   1 +
>  arch/s390/kernel/entry.h            |   4 +
>  arch/s390/kernel/pci_mmio.c         | 207
> ++++++++++++++++++++++++++++++++++++
>  arch/s390/kernel/syscalls.S         |   2 +
>  5 files changed, 217 insertions(+), 1 deletion(-)
>  create mode 100644 arch/s390/kernel/pci_mmio.c
> 
> diff --git a/arch/s390/include/uapi/asm/unistd.h
> b/arch/s390/include/uapi/asm/unistd.h
> index 3802d2d..ab49d1d 100644
> --- a/arch/s390/include/uapi/asm/unistd.h
> +++ b/arch/s390/include/uapi/asm/unistd.h
> @@ -283,7 +283,9 @@
>  #define __NR_sched_setattr	345
>  #define __NR_sched_getattr	346
>  #define __NR_renameat2		347
> -#define NR_syscalls 348
> +#define __NR_s390_pci_mmio_write	348
> +#define __NR_s390_pci_mmio_read		349
> +#define NR_syscalls 350
> 
>  /*
>   * There are some system calls that are not present on 64 bit, some
> diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
> index 33225e8..3e71b7e 100644
> --- a/arch/s390/kernel/Makefile
> +++ b/arch/s390/kernel/Makefile
> @@ -60,6 +60,7 @@ ifdef CONFIG_64BIT
>  obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o perf_cpum_cf.o perf_cpum_sf.o
> \
>  						perf_cpum_cf_events.o
>  obj-y				+= runtime_instr.o cache.o
> +obj-y				+= pci_mmio.o
>  endif
> 
>  # vdso
> diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
> index 6ac7819..a36b6f9 100644
> --- a/arch/s390/kernel/entry.h
> +++ b/arch/s390/kernel/entry.h
> @@ -70,4 +70,8 @@ struct old_sigaction;
>  long sys_s390_personality(unsigned int personality);
>  long sys_s390_runtime_instr(int command, int signum);
> 
> +long sys_s390_pci_mmio_write(const unsigned long mmio_addr,
> +			     const void *user_buffer, const size_t length);
> +long sys_s390_pci_mmio_read(const unsigned long mmio_addr,
> +			    void *user_buffer, const size_t length);
>  #endif /* _ENTRY_H */
> diff --git a/arch/s390/kernel/pci_mmio.c b/arch/s390/kernel/pci_mmio.c
> new file mode 100644
> index 0000000..f318207
> --- /dev/null
> +++ b/arch/s390/kernel/pci_mmio.c
> @@ -0,0 +1,207 @@
> +/*
> + * Access to PCI I/O memory from user space programs.
> + *
> + * Copyright IBM Corp. 2014
> + * Author(s): Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> + */
> +#include <linux/kernel.h>
> +#include <linux/syscalls.h>
> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include <linux/errno.h>
> +#include <linux/pci.h>
> +
> +union value_buffer {
> +	u8 buf8;
> +	u16 buf16;
> +	u32 buf32;
> +	u64 buf64;
> +	u8 buf_large[64];
> +};
> +
> +static long get_pfn(const unsigned long user_addr,
> +		    const unsigned long access,
> +		    unsigned long *pfn)
> +{
> +	struct vm_area_struct *vma = NULL;
> +	long ret = 0L;
> +
> +	if (!pfn)
> +		return -EINVAL;
> +
> +	down_read(&current->mm->mmap_sem);
> +	vma = find_vma(current->mm, user_addr);
> +	if (vma) {
> +		if (!(vma->vm_flags & access))
> +			ret = -EACCES;
> +		else
> +			ret = follow_pfn(vma, user_addr, pfn);
> +	} else {
> +		ret = -EINVAL;
> +	}
> +	up_read(&current->mm->mmap_sem);
> +
> +	return ret;
> +}
> +
> +static inline int verify_page_addr(const unsigned long page_addr)
> +{
> +	return !(page_addr < ZPCI_IOMAP_ADDR_BASE ||
> +	    page_addr > (ZPCI_IOMAP_ADDR_BASE | ZPCI_IOMAP_ADDR_IDX_MASK));
> +}
> +
> +static long choose_buffer(const size_t length,
> +			  union value_buffer *value,
> +			  void **buf)
> +{
> +	long ret = 0L;
> +
> +	if (length > sizeof(value->buf_large)) {
> +		*buf = kmalloc(length, GFP_KERNEL);
> +		if (!*buf)
> +			return -ENOMEM;
> +		ret = 1;
> +	} else {
> +		*buf = value->buf_large;
> +	}
> +	return ret;
> +}
> +
> +SYSCALL_DEFINE3(s390_pci_mmio_write,
> +		const unsigned long, mmio_addr,
> +		const void __user *, user_buffer,
> +		const size_t, length)
> +{
> +	long ret = 0L;
> +	void *buf = NULL;
> +	long buf_allocated = 0;
> +	void __iomem *io_addr = NULL;
> +	unsigned long pfn = 0UL;
> +	unsigned long offset = 0UL;
> +	unsigned long page_addr = 0UL;
> +	union value_buffer value;
> +
> +	if (!length)
> +		return -EINVAL;
> +	if (!zpci_is_enabled())
> +		return -ENODEV;
> +
> +	ret = get_pfn(mmio_addr, VM_WRITE, &pfn);
> +	if (ret)
> +		return ret;
> +
> +	page_addr = pfn << PAGE_SHIFT;
> +	if (!verify_page_addr(page_addr))
> +		return -EFAULT;
> +
> +	offset = mmio_addr & ~PAGE_MASK;
> +	if (offset + length > PAGE_SIZE)
> +		return -EINVAL;
> +	io_addr = (void *)(page_addr | offset);
> +
> +	buf_allocated = choose_buffer(length, &value, &buf);
> +	if (buf_allocated < 0L)
> +		return -ENOMEM;
> +
> +	switch (length) {
> +	case 1:
> +		ret = get_user(value.buf8, ((u8 *)user_buffer));

This cast (and similar casts across the code) kills the __user annotation of the user buffer pointer.
First - fix this to help various static verification tools such as sparse work on your code.
Second - are you sure this switch-case block achieves any performance gain compared to always using copy_from_user?
If so, why not just push it into the S390 copy from user code?

> +		break;
> +	case 2:
> +		ret = get_user(value.buf16, ((u16 *)user_buffer));
> +		break;
> +	case 4:
> +		ret = get_user(value.buf32, ((u32 *)user_buffer));
> +		break;
> +	case 8:
> +		ret = get_user(value.buf64, ((u64 *)user_buffer));
> +		break;
> +	default:
> +		ret = copy_from_user(buf, user_buffer, length);
> +	}
> +	if (ret)
> +		goto out;
> +
> +	switch (length) {
> +	case 1:
> +		__raw_writeb(value.buf8, io_addr);
> +		break;
> +	case 2:
> +		__raw_writew(value.buf16, io_addr);
> +		break;
> +	case 4:
> +		__raw_writel(value.buf32, io_addr);
> +		break;
> +	case 8:
> +		__raw_writeq(value.buf64, io_addr);
> +		break;
> +	default:
> +		memcpy_toio(io_addr, buf, length);
> +	}
> +out:
> +	if (buf_allocated > 0L)
> +		kfree(buf);
> +	return ret;
> +}
> +
> +SYSCALL_DEFINE3(s390_pci_mmio_read,
> +		const unsigned long, mmio_addr,
> +		void __user *, user_buffer,
> +		const size_t, length)
> +{
> +	long ret = 0L;
> +	void *buf = NULL;
> +	long buf_allocated = 0L;
> +	void __iomem *io_addr = NULL;
> +	unsigned long pfn = 0UL;
> +	unsigned long offset = 0UL;
> +	unsigned long page_addr = 0UL;
> +	union value_buffer value;
> +
> +	if (!length)
> +		return -EINVAL;
> +	if (!zpci_is_enabled())
> +		return -ENODEV;
> +
> +	ret = get_pfn(mmio_addr, VM_READ, &pfn);
> +	if (ret)
> +		return ret;
> +
> +	page_addr = pfn << PAGE_SHIFT;
> +	if (!verify_page_addr(page_addr))
> +		return -EFAULT;
> +
> +	offset = mmio_addr & ~PAGE_MASK;
> +	if (offset + length > PAGE_SIZE)
> +		return -EINVAL;
> +	io_addr = (void *)(page_addr | offset);
> +
> +	buf_allocated = choose_buffer(length, &value, &buf);
> +	if (buf_allocated < 0L)
> +		return -ENOMEM;
> +
> +	switch (length) {
> +	case 1:
> +		value.buf8 = __raw_readb(io_addr);
> +		ret = put_user(value.buf8, ((u8 *)user_buffer));

Add __user annotations in this code block as well.

> +		break;
> +	case 2:
> +		value.buf16 = __raw_readw(io_addr);
> +		ret = put_user(value.buf16, ((u16 *)user_buffer));
> +		break;
> +	case 4:
> +		value.buf32 = __raw_readl(io_addr);
> +		ret = put_user(value.buf32, ((u32 *)user_buffer));
> +		break;
> +	case 8:
> +		value.buf64 = __raw_readq(io_addr);
> +		ret = put_user(value.buf64, ((u64 *)user_buffer));
> +		break;
> +	default:
> +		memcpy_fromio(buf, io_addr, length);
> +		ret = copy_to_user(user_buffer, buf, length);
> +	}
> +	if (buf_allocated > 0L)
> +		kfree(buf);
> +	return ret;
> +}
> diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
> index fe5cdf2..1faa942 100644
> --- a/arch/s390/kernel/syscalls.S
> +++ b/arch/s390/kernel/syscalls.S
> @@ -356,3 +356,5 @@
> SYSCALL(sys_finit_module,sys_finit_module,compat_sys_finit_module)
>  SYSCALL(sys_sched_setattr,sys_sched_setattr,compat_sys_sched_setattr)
> /* 345 */
>  SYSCALL(sys_sched_getattr,sys_sched_getattr,compat_sys_sched_getattr)
>  SYSCALL(sys_renameat2,sys_renameat2,compat_sys_renameat2)
> +SYSCALL(sys_ni_syscall,sys_s390_pci_mmio_write,sys_ni_syscall)
> +SYSCALL(sys_ni_syscall,sys_s390_pci_mmio_read,sys_ni_syscall)

Generally speaking, looks OK once the __user annotation is added.

I suspect you might need ack/review from the S390 maintainer as well for this to be pushed, as the syscall is generic to the entire S390 subsystem.

--Shachar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
