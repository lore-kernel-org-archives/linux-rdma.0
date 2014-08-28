From: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] s390/kernel: add system calls for access PCI memory
Date: Thu, 28 Aug 2014 16:00:20 +0400
Message-ID: <53FF19D4.5020207@linux.vnet.ibm.com>
References: <1409135080-44991-1-git-send-email-aishchuk@linux.vnet.ibm.com> <1409135080-44991-2-git-send-email-aishchuk@linux.vnet.ibm.com> <6B2A6E60C06CCC42AE31809BF572352B010E23CCE5@MTLDAG02.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6B2A6E60C06CCC42AE31809BF572352B010E23CCE5-LSMZvP3E4uyuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Shachar,

Thank you for your comments. Please, find my answers below.

Regards,
Alexey Ishchuk

On 08/27/2014 07:18 PM, Shachar Raindel wrote:
> Hi Alex,
>
> Few comments on your patch below.
>
>
> Thanks,
> --Shachar
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Alexey Ishchuk
>> Sent: Wednesday, August 27, 2014 1:29 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
>> linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org;
>> utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org; martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org;
>> frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org; Alexey Ishchuk
>> Subject: [PATCH] s390/kernel: add system calls for access PCI memory
>>
>> Add the new __NR_s390_pci_mmio_write and __NR_s390_pci_mmio_read
>> system calls to allow user space applications to access device PCI I/O
>
> Why do you need this to be a special syscall for this functionality? If S390 platform supports mapping MMIO pages to the user space? If this must happen in kernel, it should be provided as a device file (probably character), on which writes or ioctls does mmio_write, and reads or ioctl does mmio_reads.
>
The special syscall is needed for this functionality because the s390
platform does not really support MMIO page mappings to user space. The
PCI memory itself on this platform can be accessed only using special
privileged CPU instructions. Because of that the user space program
cannot simply store the data into a mapped memory that belongs to the
PCI memory address space.

To get as close to the programming model used by "normal" architectures
the PCI MMIO address is stored into the page table for the user space
process as if the process could store to the memory. But in fact it can
not, every access to this memory area would create an exception.

To write data to the PCI memory address space  the user space program on
the s390 platform needs to call into the kernel to have these privileged
PCI instructions executed. A system call is a straight-forward way to do
this.

I tried to provide a new Infiniband verb command for data writing to PCI
memory but that approach was rejected by the community. My tests shown
that the syscall approach implementation works noticeably faster than
new verb command way. Concerning the security issues, please, see my
considerations below.

>> memory pages on s390x platform.
>>
>> Signed-off-by: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   arch/s390/include/uapi/asm/unistd.h |   4 +-
>>   arch/s390/kernel/Makefile           |   1 +
>>   arch/s390/kernel/entry.h            |   4 +
>>   arch/s390/kernel/pci_mmio.c         | 197
>> ++++++++++++++++++++++++++++++++++++
>>   arch/s390/kernel/syscalls.S         |   2 +
>>   5 files changed, 207 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/s390/kernel/pci_mmio.c
>>
>> diff --git a/arch/s390/include/uapi/asm/unistd.h
>> b/arch/s390/include/uapi/asm/unistd.h
>> index 3802d2d..ab49d1d 100644
>> --- a/arch/s390/include/uapi/asm/unistd.h
>> +++ b/arch/s390/include/uapi/asm/unistd.h
>> @@ -283,7 +283,9 @@
>>   #define __NR_sched_setattr	345
>>   #define __NR_sched_getattr	346
>>   #define __NR_renameat2		347
>> -#define NR_syscalls 348
>> +#define __NR_s390_pci_mmio_write	348
>> +#define __NR_s390_pci_mmio_read		349
>> +#define NR_syscalls 350
>>
>>   /*
>>    * There are some system calls that are not present on 64 bit, some
>> diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
>> index 8c2518f..44e8fbb 100644
>> --- a/arch/s390/kernel/Makefile
>> +++ b/arch/s390/kernel/Makefile
>> @@ -62,6 +62,7 @@ ifdef CONFIG_64BIT
>>   obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o perf_cpum_cf.o
>> perf_cpum_sf.o \
>>   						perf_cpum_cf_events.o
>>   obj-y				+= runtime_instr.o cache.o
>> +obj-y				+= pci_mmio.o
>>   endif
>>
>>   # vdso
>> diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
>> index 6ac7819..a36b6f9 100644
>> --- a/arch/s390/kernel/entry.h
>> +++ b/arch/s390/kernel/entry.h
>> @@ -70,4 +70,8 @@ struct old_sigaction;
>>   long sys_s390_personality(unsigned int personality);
>>   long sys_s390_runtime_instr(int command, int signum);
>>
>> +long sys_s390_pci_mmio_write(const unsigned long mmio_addr,
>> +			     const void *user_buffer, const size_t length);
>> +long sys_s390_pci_mmio_read(const unsigned long mmio_addr,
>> +			    void *user_buffer, const size_t length);
>>   #endif /* _ENTRY_H */
>> diff --git a/arch/s390/kernel/pci_mmio.c b/arch/s390/kernel/pci_mmio.c
>> new file mode 100644
>> index 0000000..4539d23
>> --- /dev/null
>> +++ b/arch/s390/kernel/pci_mmio.c
>> @@ -0,0 +1,197 @@
>> +/*
>> + * Copyright IBM Corp. 2014
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/syscalls.h>
>> +#include <linux/init.h>
>> +#include <linux/mm.h>
>> +#include <linux/errno.h>
>> +#include <linux/pci.h>
>> +
>> +union value_buffer {
>> +	u8 buf8;
>> +	u16 buf16;
>> +	u32 buf32;
>> +	u64 buf64;
>> +	u8 buf_large[64];
>> +};
>> +
>> +static long get_pfn(const unsigned long user_addr,
>> +		    const unsigned long access,
>> +		    unsigned long *pfn)
>> +{
>> +	struct vm_area_struct *vma = NULL;
>> +
>> +	if (!pfn)
>> +		return -EINVAL;
>> +
>> +	vma = find_vma(current->mm, user_addr);
>> +	if (!vma)
>> +		return -EINVAL;
>> +	if (!(vma->vm_flags & access))
>> +		return -EACCES;
>> +
>> +	return follow_pfn(vma, user_addr, pfn);
>> +}
>> +
>> +static inline int verify_page_addr(const unsigned long page_addr)
>> +{
>> +	return !(page_addr < ZPCI_IOMAP_ADDR_BASE ||
>> +	    page_addr > (ZPCI_IOMAP_ADDR_BASE |
>> ZPCI_IOMAP_ADDR_IDX_MASK));
>> +}
>> +
>> +static long choose_buffer(const size_t length,
>> +			  union value_buffer *value,
>> +			  void **buf)
>> +{
>> +	long ret = 0UL;
>> +
>> +	if (length > sizeof(value->buf_large)) {
>> +		*buf = kmalloc(length, GFP_KERNEL);
>> +		if (!*buf)
>> +			return -ENOMEM;
>> +		ret = 1;
>> +	} else {
>> +		*buf = value->buf_large;
>> +	}
>> +	return ret;
>> +}
>> +
>> +SYSCALL_DEFINE3(s390_pci_mmio_write,
>> +		const unsigned long, mmio_addr,
>> +		const void __user *, user_buffer,
>> +		const size_t, length)
>> +{
>
> You need some security check in the flow here (i.e. capability or root).
> If you don't do that, any user can do mmio to any address in the system, which seems like a very bad idea.
>
An additional security check on the MMIO address given with the syscall
is not required because it uses the address of a previously mapped
MMIO area. That area should be mapped only by a process that has
the appropriate permissions for working with the uverbs file. When the
syscall receives the user space address it tries to find corresponding
vma and checks required access to it, and if vma cannot be found or
access mode is invalid syscall returns an  error code. After the vma is
found, syscall verifies that the memory area belongs to the PCI memory
address space, and only if a correct address is received it writes the
data using the specified address. Therefore, as the address should be
previously mapped for a correct file and belong to the PCI memory
address space, the syscall does not work with any user space address,
and will work only with the addresses mapped from correct uverbs file
that belong to the PCI memory address space.

Compare it with a "normal" architecture, there is no additional security
check either, the user space process simply access the MMIO area
with read/write instructions directly. All required checks need to go
into the code that establishes the mapping.
>
>> +	long ret = 0L;
>> +	void *buf = NULL;
>> +	long buf_allocated = 0;
>> +	void __iomem *io_addr = NULL;
>> +	unsigned long pfn = 0UL;
>> +	unsigned long offset = 0UL;
>> +	unsigned long page_addr = 0UL;
>> +	union value_buffer value;
>> +
>> +	if (!length)
>> +		return -EINVAL;
>> +	if (!zpci_is_enabled())
>> +		return -ENODEV;
>> +
>> +	ret = get_pfn(mmio_addr, VM_WRITE, &pfn);
>> +	if (ret)
>> +		return ret;
>> +
>> +	page_addr = pfn << PAGE_SHIFT;
>> +	if (!verify_page_addr(page_addr))
>> +		return -EFAULT;
>> +
>> +	offset = mmio_addr & ~PAGE_MASK;
>> +	if (offset + length > PAGE_SIZE)
>> +		return -EINVAL;
>> +	io_addr = (void *)(page_addr | offset);
>> +
>> +	buf_allocated = choose_buffer(length, &value, &buf);
>> +	if (buf_allocated < 0L)
>> +		return -ENOMEM;
>> +
>> +	switch (length) {
>> +	case 1:
>> +		ret = get_user(value.buf8, ((u8 *)user_buffer));
>> +		break;
>> +	case 2:
>> +		ret = get_user(value.buf16, ((u16 *)user_buffer));
>> +		break;
>> +	case 4:
>> +		ret = get_user(value.buf32, ((u32 *)user_buffer));
>> +		break;
>> +	case 8:
>> +		ret = get_user(value.buf64, ((u64 *)user_buffer));
>> +		break;
>> +	default:
>> +		ret = copy_from_user(buf, user_buffer, length);
>> +	}
>> +	if (ret)
>> +		goto out;
>> +
>> +	switch (length) {
>> +	case 1:
>> +		__raw_writeb(value.buf8, io_addr);
>> +		break;
>> +	case 2:
>> +		__raw_writew(value.buf16, io_addr);
>> +		break;
>> +	case 4:
>> +		__raw_writel(value.buf32, io_addr);
>> +		break;
>> +	case 8:
>> +		__raw_writeq(value.buf64, io_addr);
>> +		break;
>> +	default:
>> +		memcpy_toio(io_addr, buf, length);
>> +	}
>> +out:
>> +	if (buf_allocated > 0L)
>> +		kfree(buf);
>> +	return ret;
>> +}
>> +
>> +SYSCALL_DEFINE3(s390_pci_mmio_read,
>> +		const unsigned long, mmio_addr,
>> +		void __user *, user_buffer,
>> +		const size_t, length)
>> +{
>> +	long ret = 0L;
>> +	void *buf = NULL;
>> +	long buf_allocated = 0L;
>> +	void __iomem *io_addr = NULL;
>> +	unsigned long pfn = 0UL;
>> +	unsigned long offset = 0UL;
>> +	unsigned long page_addr = 0UL;
>> +	union value_buffer value;
>> +
>> +	if (!length)
>> +		return -EINVAL;
>> +	if (!zpci_is_enabled())
>> +		return -ENODEV;
>> +
>> +	ret = get_pfn(mmio_addr, VM_READ, &pfn);
>> +	if (ret)
>> +		return ret;
>> +
>> +	page_addr = pfn << PAGE_SHIFT;
>> +	if (!verify_page_addr(page_addr))
>> +		return -EFAULT;
>> +
>> +	offset = mmio_addr & ~PAGE_MASK;
>> +	if (offset + length > PAGE_SIZE)
>> +		return -EINVAL;
>> +	io_addr = (void *)(page_addr | offset);
>> +
>> +	buf_allocated = choose_buffer(length, &value, &buf);
>> +	if (buf_allocated < 0L)
>> +		return -ENOMEM;
>> +
>> +	switch (length) {
>> +	case 1:
>> +		value.buf8 = __raw_readb(io_addr);
>> +		ret = put_user(value.buf8, ((u8 *)user_buffer));
>> +		break;
>> +	case 2:
>> +		value.buf16 = __raw_readw(io_addr);
>> +		ret = put_user(value.buf16, ((u16 *)user_buffer));
>> +		break;
>> +	case 4:
>> +		value.buf32 = __raw_readl(io_addr);
>> +		ret = put_user(value.buf32, ((u32 *)user_buffer));
>> +		break;
>> +	case 8:
>> +		value.buf64 = __raw_readq(io_addr);
>> +		ret = put_user(value.buf64, ((u64 *)user_buffer));
>> +		break;
>> +	default:
>> +		memcpy_fromio(buf, io_addr, length);
>> +		ret = copy_to_user(user_buffer, buf, length);
>> +	}
>> +	if (buf_allocated > 0L)
>> +		kfree(buf);
>> +	return ret;
>> +}
>> diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
>> index fe5cdf2..1faa942 100644
>> --- a/arch/s390/kernel/syscalls.S
>> +++ b/arch/s390/kernel/syscalls.S
>> @@ -356,3 +356,5 @@
>> SYSCALL(sys_finit_module,sys_finit_module,compat_sys_finit_module)
>>   SYSCALL(sys_sched_setattr,sys_sched_setattr,compat_sys_sched_setattr)
>> /* 345 */
>>   SYSCALL(sys_sched_getattr,sys_sched_getattr,compat_sys_sched_getattr)
>>   SYSCALL(sys_renameat2,sys_renameat2,compat_sys_renameat2)
>> +SYSCALL(sys_ni_syscall,sys_s390_pci_mmio_write,sys_ni_syscall)
>> +SYSCALL(sys_ni_syscall,sys_s390_pci_mmio_read,sys_ni_syscall)
>> --
>> 1.8.5.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
