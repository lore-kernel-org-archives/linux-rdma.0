From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] util: Add common mmio macros
Date: Tue, 18 Apr 2017 18:52:00 +0300
Message-ID: <b35958cf-5e87-3149-5413-eb754ec89b4d@dev.mellanox.co.il>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1492123127-6266-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492123127-6266-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/14/2017 1:38 AM, Jason Gunthorpe wrote:
> The macros are a mashup of the Mellanox driver macros:
>  - An alternate implementation for S390 is provided
>  - The ia32 XMM based 64 bit store emulation is switched
>    in if supported
>  - The macros are 'relaxed' ordering, so no implicit barrier
>    overheads
>  - If UDMA is not available then MMIO macros are also switched off,
>    this is because the 32 bit emulation relies on the udma barriers.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt                |  16 ++++
>  buildlib/config.h.in          |   2 +
>  buildlib/rdma_functions.cmake |   4 +-
>  util/CMakeLists.txt           |  20 +++-
>  util/dummy.c                  |   0
>  util/mmio.c                   |  83 ++++++++++++++++
>  util/mmio.h                   | 214 ++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 336 insertions(+), 3 deletions(-)
>  create mode 100644 util/dummy.c
>  create mode 100644 util/mmio.c
>  create mode 100644 util/mmio.h
>
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 1ff3189c9d295e..5552872e8ca707 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -181,6 +181,19 @@ set(NO_STRICT_ALIASING_FLAGS "")
>  RDMA_AddOptCFlag(NO_STRICT_ALIASING_FLAGS HAVE_NO_STRICT_ALIASING
>    "-fno-strict-aliasing")
>
> +CHECK_C_SOURCE_COMPILES("
> + #include <unistd.h>
> +
> + void entry(void);
> +
> + static void do_entry(void) {}
> + void entry(void) __attribute__((ifunc(\"resolve_entry\")));
> + static void *resolve_entry(void) {return &do_entry;}
> +
> + int main(int argc,const char *argv[]) { entry(); }"
> +  HAVE_FUNC_ATTRIBUTE_IFUNC
> +  FAIL_REGEX "warning")
> +
>  # The code does not do the racy fcntl if the various CLOEXEC's are not
>  # supported so it really doesn't work right if this isn't available. Thus hard
>  # require it.
> @@ -418,6 +431,9 @@ message(STATUS "Missing Optional Items:")
>  if (NOT HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE)
>    message(STATUS " Compiler attribute always_inline NOT supported")
>  endif()
> +if (NOT HAVE_FUNC_ATTRIBUTE_IFUNC)
> +  message(STATUS " Compiler attribute ifunc NOT supported")
> +endif()
>  if (NOT HAVE_COHERENT_DMA)
>    message(STATUS " Architecture NOT able to do coherent DMA (check util/udma_barrier.h) some providers disabled!")
>  endif()
> diff --git a/buildlib/config.h.in b/buildlib/config.h.in
> index e4e7b9ee70c857..2eb16be764630e 100644
> --- a/buildlib/config.h.in
> +++ b/buildlib/config.h.in
> @@ -28,6 +28,8 @@
>  // FIXME This has been supported in compilers forever, we should just fail to build on such old systems.
>  #cmakedefine HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE 1
>
> +#cmakedefine HAVE_FUNC_ATTRIBUTE_IFUNC 1
> +
>  #cmakedefine HAVE_WORKING_IF_H 1
>
>  @SIZEOF_LONG_CODE@
> diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
> index 01997b51468f55..936e1b256816ef 100644
> --- a/buildlib/rdma_functions.cmake
> +++ b/buildlib/rdma_functions.cmake
> @@ -6,8 +6,8 @@
>  # Global list of pairs of (SHARED STATIC) libary target names
>  set(RDMA_STATIC_LIBS "" CACHE INTERNAL "Doc" FORCE)
>
> -set(COMMON_LIBS_PIC ccan_pic)
> -set(COMMON_LIBS ccan)
> +set(COMMON_LIBS_PIC ccan_pic rdma_util_pic)
> +set(COMMON_LIBS ccan rdma_util)
>
>  # Create a symlink at filename DEST
>  # If the directory containing DEST does not exist then it is created
> diff --git a/util/CMakeLists.txt b/util/CMakeLists.txt
> index 71e33ac3baaa9b..581bf6822ec39f 100644
> --- a/util/CMakeLists.txt
> +++ b/util/CMakeLists.txt
> @@ -1,5 +1,23 @@
>  publish_internal_headers(util
>    compiler.h
> -  udma_barrier.h
>    util.h
>    )
> +
> +# The empty dummy.c is only needed so that cmake always has something to build
> +# into the library.
> +set(C_FILES dummy.c)
> +
> +if (HAVE_COHERENT_DMA)
> +  publish_internal_headers(util
> +    mmio.h
> +    udma_barrier.h
> +    )
> +
> +  set(C_FILES ${C_FILES}
> +    mmio.c
> +    )
> +endif()
> +
> +add_library(rdma_util STATIC ${C_FILES})
> +add_library(rdma_util_pic STATIC ${C_FILES})
> +set_property(TARGET rdma_util_pic PROPERTY POSITION_INDEPENDENT_CODE TRUE)
> diff --git a/util/dummy.c b/util/dummy.c
> new file mode 100644
> index 00000000000000..e69de29bb2d1d6
> diff --git a/util/mmio.c b/util/mmio.c
> new file mode 100644
> index 00000000000000..757a46ce5418d8
> --- /dev/null
> +++ b/util/mmio.c
> @@ -0,0 +1,83 @@
> +/* GPLv2 or OpenIB.org BSD (MIT) See COPYING file */
> +#include <util/mmio.h>
> +#include <util/udma_barrier.h>
> +#include <config.h>
> +
> +#include <pthread.h>
> +#include <stdbool.h>
> +
> +#if SIZEOF_LONG != 8
> +
> +static pthread_spinlock_t mmio_spinlock;
> +
> +static __attribute__((constructor)) void lock_constructor(void)
> +{
> +	pthread_spin_init(&mmio_spinlock, PTHREAD_PROCESS_PRIVATE);
> +}
> +
> +/* When the arch does not have a 32 bit store we provide an emulation that
You mean a 64 bit store, correct ?

> +   does two stores in address ascending order while holding a global
> +   spinlock. */
> +static void pthread_mmio_write64_be(void *addr, __be64 val)
> +{
> +	__be32 first_dword = htobe32(be64toh(val) >> 32);
> +	__be32 second_dword = htobe32(be64toh(val));
> +
> +	/* The WC spinlock, by definition, provides global ordering for all UC
> +	   and WC stores within the critical region. */
> +	mmio_wc_spinlock(&mmio_spinlock);
> +
> +	mmio_write32_be(addr, first_dword);
> +	mmio_write32_be(addr + 4, second_dword);
> +
> +	mmio_wc_spinunlock(&mmio_spinlock);
> +}
> +
> +#if defined(__i386__)
> +#include <xmmintrin.h>
> +#include <cpuid.h>
> +
> +/* For ia32 we have historically emitted movlps SSE instructions to do the 64
> +   bit operations. */
> +static void __attribute__((target("sse")))
> +sse_mmio_write64_be(void *addr, __be64 val)
> +{
> +	__m128 tmp = {};
> +	tmp = _mm_loadl_pi(tmp, (__force __m64 *)&val);
> +	_mm_storel_pi((__m64 *)addr,tmp);
> +}
> +
> +static bool have_sse(void)
> +{
> +	unsigned int ax,bx,cx,dx;
> +
> +	if (!__get_cpuid(1,&ax,&bx,&cx,&dx))
> +		return false;
> +	return dx & bit_SSE;
> +}
> +
> +#endif /* defined(__i386__) */
> +
> +typedef void (*write64_fn_t)(void *, __be64);
> +
> +/* This uses the STT_GNU_IFUNC extension to have the dynamic linker select the
> +   best above implementations at runtime. */
> +#if HAVE_FUNC_ATTRIBUTE_IFUNC
> +void mmio_write64_be(void *addr, __be64 val)
> +    __attribute__((ifunc("resolve_mmio_write64_be")));
> +static write64_fn_t resolve_mmio_write64_be(void);
> +#else
> +__asm__(".type mmio_write64_be, %gnu_indirect_function");
> +write64_fn_t resolve_mmio_write64_be(void) __asm__("mmio_write64_be");
> +#endif
> +
> +write64_fn_t resolve_mmio_write64_be(void)
> +{
> +#if defined(__i386__)
> +	if (have_sse())
> +		return &sse_mmio_write64_be;
> +#endif
> +	return &pthread_mmio_write64_be;

This will bring in 32 bit systems code that uses global spinlock 
comparing current usage where a specific spinlock is used, isn't it ?
see mlx4_write64() which is replaced by that code in downstream patches.

> +}
> +
> +#endif /* SIZEOF_LONG != 8 */
> diff --git a/util/mmio.h b/util/mmio.h
> new file mode 100644
> index 00000000000000..0b89f5fcbe000e
> --- /dev/null
> +++ b/util/mmio.h
> @@ -0,0 +1,214 @@
> +/* GPLv2 or OpenIB.org BSD (MIT) See COPYING file
> +
> +   These accessors always map to PCI-E TLPs in predictable ways. Translation
> +   to other buses should follow similar definitions.
> +
> +   write32(mem, 1)
> +      Produce a 4 byte MemWr TLP with bit 0 of DW byte offset 0 set
> +   write32_be(mem, htobe32(1))
> +      Produce a 4 byte MemWr TLP with bit 0 of DW byte offset 3 set
> +   write32_le(mem, htole32(1))
> +      Produce a 4 byte MemWr TLP with bit 0 of DW byte offset 0 set
> +
> +   For ordering these accessors are similar to the Kernel's concept of
> +   writel_relaxed(). When working with UC memory the following hold:
> +
> +   1) Strong ordering is required when talking to the same device (eg BAR),
> +      and combining is not permitted:
> +
> +       write32(mem, 1);
> +       write32(mem + 4, 1);
> +       write32(mem, 1);
> +
> +      Must produce three TLPs, in order.
> +
> +   2) Ordering ignores all pthread locking:
> +
> +       pthread_spin_lock(&lock);
> +       write32(mem, global++);
> +       pthread_spin_unlock(&lock);
> +
> +      When run concurrently on all CPUs the device must observe all stores,
> +      but the data value will not be strictly increasing.
> +
> +   3) Interaction with DMA is not ordered. Explicit use of a barrier from
> +      udma_barriers is required:
> +
> +	*dma_mem = 1;
> +	udma_to_device_barrier();
> +	write32(mem, GO_DMA);
> +
> +   4) Access out of program order (eg speculation), either by the CPU or
> +      compiler is not permitted:
> +
> +	if (cond)
> +	   read32();
> +
> +      Must not issue a read TLP if cond is false.
> +
> +   If these are used with WC memory then #1 and #4 do not apply, and all WC
> +   accesses must be bracketed with mmio_wc_start() // mmio_flush_writes()
> +*/
> +
> +#ifndef __UTIL_MMIO_H
> +#define __UTIL_MMIO_H
> +
> +#include <linux/types.h>
> +#include <stdatomic.h>
> +#include <stdint.h>
> +#include <endian.h>
> +
> +#include <config.h>
> +#include <util/compiler.h>
> +
> +/* The first step is to define the 'raw' accessors. To make this very safe
> +   with sparse we define two versions of each, a le and a be - however the
> +   code is always identical.
> +*/
> +#ifdef __s390x__
> +#include <unistd.h>
> +#include <sys/syscall.h>
> +
> +/* s390 requires a privileged instruction to access IO memory, these syscalls
> +   perform that instruction using a memory buffer copy semantic.
> +*/
> +static inline void s390_mmio_write(void *mmio_addr, const void *val,
> +				   size_t length)
> +{
> +	// FIXME: Check for error and call abort?
> +	syscall(__NR_s390_pci_mmio_write, mmio_addr, val, length);
> +}
> +
> +static inline void s390_mmio_read(const void *mmio_addr, void *val,
> +				  size_t length)
> +{
> +	// FIXME: Check for error and call abort?
> +	syscall(__NR_s390_pci_mmio_read, mmio_addr, val, length);
> +}
> +
> +#define MAKE_WRITE(_NAME_, _SZ_)                                               \
> +	static inline void _NAME_##_be(void *addr, __be##_SZ_ value)           \
> +	{                                                                      \
> +		s390_mmio_write(addr, &value, sizeof(value));                  \
> +	}                                                                      \
> +	static inline void _NAME_##_le(void *addr, __le##_SZ_ value)           \
> +	{                                                                      \
> +		s390_mmio_write(addr, &value, sizeof(value));                  \
> +	}

I believe that you introduced two different versions (i.e. le/be only 
for semantic reasons as code is really similar, is that correct ?

> +#define MAKE_READ(_NAME_, _SZ_)                                                \
> +	static inline __be##_SZ_ _NAME_##_be(const void *addr)                 \
> +	{                                                                      \
> +		__be##_SZ_ res;                                                \
> +		s390_mmio_read(addr, &res, sizeof(res));                       \
> +		return res;                                                    \
> +	}                                                                      \
> +	static inline __le##_SZ_ _NAME_##_le(const void *addr)                 \
> +	{                                                                      \
> +		__le##_SZ_ res;                                                \
> +		s390_mmio_read(addr, &res, sizeof(res));                       \
> +		return res;                                                    \
> +	}
> +
> +static inline void mmio_read8(void *addr, uint8_t value)

Did you refer here to mmio_write8 ?

> +{
> +	s390_mmio_write(addr, &value, sizeof(value));
> +}
> +
> +static inline uint8_t mmio_read8(const void *addr)

This function was already defined above.

> +{
> +	uint8_t res;
> +	s390_mmio_read(addr, &res, sizeof(res));
> +	return res;
> +}
> +
> +#else /* __s390x__ */
> +
> +#define MAKE_WRITE(_NAME_, _SZ_)                                               \
> +	static inline void _NAME_##_be(void *addr, __be##_SZ_ value)           \
> +	{                                                                      \
> +		atomic_store_explicit((_Atomic(uint##_SZ_##_t) *)addr,         \
> +				      (__force uint##_SZ_##_t)value,           \
> +				      memory_order_relaxed);                   \

Mightn't this code introduce some overhead comparing direct assignment 
which is used (i.e. mlx5_write64) and replaced by that in downstream 
patches ?

This need to be measured and verified as it's used in the data path flows.

> +	}                                                                      \
> +	static inline void _NAME_##_le(void *addr, __le##_SZ_ value)           \
> +	{                                                                      \
> +		atomic_store_explicit((_Atomic(uint##_SZ_##_t) *)addr,         \
> +				      (__force uint##_SZ_##_t)value,           \
> +				      memory_order_relaxed);                   \
> +	}
> +#define MAKE_READ(_NAME_, _SZ_)                                                \
> +	static inline __be##_SZ_ _NAME_##_be(const void *addr)                 \
> +	{                                                                      \
> +		return (__force __be##_SZ_)atomic_load_explicit(               \
> +		    (_Atomic(uint##_SZ_##_t) *)addr, memory_order_relaxed);    \
> +	}                                                                      \
> +	static inline __le##_SZ_ _NAME_##_le(const void *addr)                 \
> +	{                                                                      \
> +		return (__force __le##_SZ_)atomic_load_explicit(               \
> +		    (_Atomic(uint##_SZ_##_t) *)addr, memory_order_relaxed);    \
> +	}
> +
> +static inline void mmio_write8(void *addr, uint8_t value)
> +{
> +	atomic_store_explicit((_Atomic(uint8_t) *)addr, value,
> +			      memory_order_relaxed);
> +}
> +static inline uint8_t mmio_read8(const void *addr)
> +{
> +	return atomic_load_explicit((_Atomic(uint32_t) *)addr,
> +				    memory_order_relaxed);
> +}
> +
> +#endif /* __s390x__ */
> +
> +MAKE_WRITE(mmio_write16, 16)
> +MAKE_WRITE(mmio_write32, 32)
> +
> +MAKE_READ(mmio_read16, 16)
> +MAKE_READ(mmio_read32, 32)
> +
> +#if SIZEOF_LONG == 8
> +MAKE_WRITE(mmio_write64, 64)
> +MAKE_READ(mmio_read64, 64)
> +#else
> +void mmio_write64_be(void *addr, __be64 val);
> +static inline void mmio_write64_le(void *addr, __le64 val)
> +{
> +	mmio_write64_be(addr, (__be64 __force)val);
> +}
> +
> +/* There is no way to do read64 atomically, rather than provide some sketchy
> +   implementation we leave these functions undefined, users should not call
> +   them if SIZEOF_LONG != 8, but instead implement an appropriate version. */
> +__be64 mmio_read64_be(const void *addr);
> +__le64 mmio_read64_le(const void *addr);
> +#endif /* SIZEOF_LONG == 8 */
> +
> +#undef MAKE_WRITE
> +#undef MAKE_READ
> +
> +/* Now we can define the host endian versions of the operator, this just includes
> +   a call to htole. */
> +#define MAKE_WRITE(_NAME_, _SZ_)                                               \
> +	static inline void _NAME_(void *addr, uint##_SZ_##_t value)            \
> +	{                                                                      \
> +		_NAME_##_le(addr, htole##_SZ_(value));                         \
> +	}
> +#define MAKE_READ(_NAME_, _SZ_)                                                \
> +	static inline uint##_SZ_##_t _NAME_(const void *addr)                  \
> +	{                                                                      \
> +		return le##_SZ_##toh(_NAME_##_le(addr));                       \
> +	}
> +
> +MAKE_WRITE(mmio_write16, 16)
> +MAKE_WRITE(mmio_write32, 32)
> +MAKE_WRITE(mmio_write64, 64)
> +
> +MAKE_READ(mmio_read16, 16)
> +MAKE_READ(mmio_read32, 32)
> +MAKE_READ(mmio_read64, 64)
> +
> +#undef MAKE_WRITE
> +#undef MAKE_READ
> +
> +#endif
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
