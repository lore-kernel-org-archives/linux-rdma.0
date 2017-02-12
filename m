From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 09/10] Move the now private infiniband/arch.h to
 util/udma_barrier.h
Date: Sun, 12 Feb 2017 08:28:26 +0000
Message-ID: <SN1PR07MB22073C217E85FC46622BB9EAF8460@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1486677212-3188-10-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-10-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This header now only contains the DMA barrier macros.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt                 |   2 +-
>  buildlib/travis-build          |   2 +-
>  libibverbs/CMakeLists.txt      |   1 -
>  libibverbs/arch.h              | 135 -----------------------------------=
------
>  providers/cxgb3/iwch.h         |   2 +-
>  providers/cxgb4/libcxgb4.h     |   2 +-
>  providers/hns/hns_roce_u.h     |   2 +-
>  providers/i40iw/i40iw_osdep.h  |   2 +-
>  providers/i40iw/i40iw_uk.c     |   2 +
>  providers/i40iw/i40iw_umain.h  |   2 +-
>  providers/mlx4/mlx4.h          |   2 +-
>  providers/mlx5/mlx5.h          |   2 +-
>  providers/mthca/mthca.h        |   2 +-
>  providers/nes/nes_umain.h      |   2 +-
>  providers/ocrdma/ocrdma_main.h |   2 +-
>  providers/qedr/qelr.h          |   2 +-
>  providers/qedr/qelr_main.h     |   2 +-
>  providers/qedr/qelr_verbs.h    |   2 +-
>  providers/vmw_pvrdma/cq.c      |   2 +-
>  providers/vmw_pvrdma/qp.c      |   2 +-
>  util/CMakeLists.txt            |   1 +
>  util/udma_barrier.h            | 125 +++++++++++++++++++++++++++++++++++=
+++
>  22 files changed, 145 insertions(+), 153 deletions(-)
>  delete mode 100644 libibverbs/arch.h
>  create mode 100644 util/udma_barrier.h
>=20
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 45cbc4e018b296..009d133cf661a9 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -286,7 +286,7 @@ include(RDMA_LinuxHeaders)
>  # arch specific property, but for our purposes arches that do not suppor=
t it
>  # also do not define wmb/etc which breaks our compile.
>  CHECK_C_SOURCE_COMPILES("
> -#include \"${CMAKE_CURRENT_SOURCE_DIR}/libibverbs/arch.h\"
> +#include \"${CMAKE_CURRENT_SOURCE_DIR}/util/udma_barrier.h\"
>   int main(int argc,const char *argv[]) {return 0;}"
>    HAVE_COHERENT_DMA)
>=20
> diff --git a/buildlib/travis-build b/buildlib/travis-build
> index 4fb84e4e70690d..3fe5ff5876df46 100755
> --- a/buildlib/travis-build
> +++ b/buildlib/travis-build
> @@ -26,7 +26,7 @@ ninja
>=20
>  # Test with coherent DMA mode disabled (ie as would be on ARM32, etc)
>  cd ../build-clang
> -echo "#error Fail" >> ../libibverbs/arch.h
> +echo "#error Fail" >> ../util/udma_barrier.h
>  rm CMakeCache.txt
>  CC=3Dclang-3.9 CFLAGS=3D-Werror cmake -GNinja ..
>  ninja
> diff --git a/libibverbs/CMakeLists.txt b/libibverbs/CMakeLists.txt
> index 0c2eb87e2adbe1..7e18a1e3e71d5e 100644
> --- a/libibverbs/CMakeLists.txt
> +++ b/libibverbs/CMakeLists.txt
> @@ -7,7 +7,6 @@ publish_headers(infiniband
>    )
>=20
>  publish_internal_headers(infiniband
> -  arch.h
>    driver.h
>    marshall.h
>    )
> diff --git a/libibverbs/arch.h b/libibverbs/arch.h
> deleted file mode 100644
> index 1c90c26d6f721d..00000000000000
> --- a/libibverbs/arch.h
> +++ /dev/null
> @@ -1,135 +0,0 @@
> -/*
> - * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> - *
> - * This software is available to you under a choice of one of two
> - * licenses.  You may choose to be licensed under the terms of the GNU
> - * General Public License (GPL) Version 2, available from the file
> - * COPYING in the main directory of this source tree, or the
> - * OpenIB.org BSD license below:
> - *
> - *     Redistribution and use in source and binary forms, with or
> - *     without modification, are permitted provided that the following
> - *     conditions are met:
> - *
> - *      - Redistributions of source code must retain the above
> - *        copyright notice, this list of conditions and the following
> - *        disclaimer.
> - *
> - *      - Redistributions in binary form must reproduce the above
> - *        copyright notice, this list of conditions and the following
> - *        disclaimer in the documentation and/or other materials
> - *        provided with the distribution.
> - *
> - * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> - * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> - * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> - * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> - * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> - * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> - * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> - * SOFTWARE.
> - */
> -
> -#ifndef INFINIBAND_ARCH_H
> -#define INFINIBAND_ARCH_H
> -
> -#include <stdint.h>
> -#include <endian.h>
> -
> -#undef htonll
> -#undef ntohll
> -static inline uint64_t htonll(uint64_t x) { return htobe64(x); }
> -static inline uint64_t ntohll(uint64_t x) { return be64toh(x); }
> -#define htonll htonll
> -#define ntohll ntohll
> -
> -/*
> - * Architecture-specific defines.  Currently, an architecture is
> - * required to implement the following operations:
> - *
> - * mb() - memory barrier.  No loads or stores may be reordered across
> - *     this macro by either the compiler or the CPU.
> - * rmb() - read memory barrier.  No loads may be reordered across this
> - *     macro by either the compiler or the CPU.
> - * wmb() - write memory barrier.  No stores may be reordered across
> - *     this macro by either the compiler or the CPU.
> - * wc_wmb() - flush write combine buffers.  No write-combined writes
> - *     will be reordered across this macro by either the compiler or
> - *     the CPU.
> - */
> -
> -#if defined(__i386__)
> -
> -#define mb()	 asm volatile("lock; addl $0,0(%%esp) " ::: "memory")
> -#define rmb()	 mb()
> -#define wmb()	 asm volatile("" ::: "memory")
> -#define wc_wmb() mb()
> -
> -#elif defined(__x86_64__)
> -
> -/*
> - * Only use lfence for mb() and rmb() because we don't care about
> - * ordering against non-temporal stores (for now at least).
> - */
> -#define mb()	 asm volatile("lfence" ::: "memory")
> -#define rmb()	 mb()
> -#define wmb()	 asm volatile("" ::: "memory")
> -#define wc_wmb() asm volatile("sfence" ::: "memory")
> -
> -#elif defined(__PPC64__)
> -
> -#define mb()	 asm volatile("sync" ::: "memory")
> -#define rmb()	 asm volatile("lwsync" ::: "memory")
> -#define wmb()	 mb()
> -#define wc_wmb() wmb()
> -
> -#elif defined(__ia64__)
> -
> -#define mb()	 asm volatile("mf" ::: "memory")
> -#define rmb()	 mb()
> -#define wmb()	 mb()
> -#define wc_wmb() asm volatile("fwb" ::: "memory")
> -
> -#elif defined(__PPC__)
> -
> -#define mb()	 asm volatile("sync" ::: "memory")
> -#define rmb()	 mb()
> -#define wmb()	 mb()
> -#define wc_wmb() wmb()
> -
> -#elif defined(__sparc_v9__)
> -
> -#define mb()	 asm volatile("membar #LoadLoad | #LoadStore | #StoreStore =
| #StoreLoad" ::: "memory")
> -#define rmb()	 asm volatile("membar #LoadLoad" ::: "memory")
> -#define wmb()	 asm volatile("membar #StoreStore" ::: "memory")
> -#define wc_wmb() wmb()
> -
> -#elif defined(__sparc__)
> -
> -#define mb()	 asm volatile("" ::: "memory")
> -#define rmb()	 mb()
> -#define wmb()	 mb()
> -#define wc_wmb() wmb()
> -
> -#elif defined(__s390x__)
> -
> -#define mb()	{ asm volatile("" : : : "memory"); }	/* for s390x */
> -#define rmb()	mb()					/* for s390x */
> -#define wmb()	mb()					/* for s390x */
> -#define wc_wmb() wmb()					/* for s390x */
> -
> -#elif defined(__aarch64__)
> -
> -/* Perhaps dmb would be sufficient? Let us be conservative for now. */
> -#define mb()	{ asm volatile("dsb sy" ::: "memory"); }
> -#define rmb()	{ asm volatile("dsb ld" ::: "memory"); }
> -#define wmb()	{ asm volatile("dsb st" ::: "memory"); }
> -#define wc_wmb() wmb()
> -
> -#else
> -
> -#error No architecture specific memory barrier defines found!
> -
> -#endif
> -
> -#endif /* INFINIBAND_ARCH_H */
> diff --git a/providers/cxgb3/iwch.h b/providers/cxgb3/iwch.h
> index a27c5f884a1a92..9ea58b73036f43 100644
> --- a/providers/cxgb3/iwch.h
> +++ b/providers/cxgb3/iwch.h
> @@ -37,7 +37,7 @@
>  #include <stddef.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  #include "cxio_wr.h"
>=20
> diff --git a/providers/cxgb4/libcxgb4.h b/providers/cxgb4/libcxgb4.h
> index 3b756616f9b903..b64b33564c76e5 100644
> --- a/providers/cxgb4/libcxgb4.h
> +++ b/providers/cxgb4/libcxgb4.h
> @@ -40,7 +40,7 @@
>  #include <sys/errno.h>
>  #include <sys/time.h>
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>  #include <ccan/list.h>
>  #include "t4.h"
>=20
> diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
> index 8483d349e4281b..cb2f26060711dd 100644
> --- a/providers/hns/hns_roce_u.h
> +++ b/providers/hns/hns_roce_u.h
> @@ -37,7 +37,7 @@
>  #include <util/compiler.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>  #include <infiniband/verbs.h>
>  #include <ccan/container_of.h>
>=20
> diff --git a/providers/i40iw/i40iw_osdep.h b/providers/i40iw/i40iw_osdep.=
h
> index e4e84e950c14bc..fddedf40dd8ae2 100644
> --- a/providers/i40iw/i40iw_osdep.h
> +++ b/providers/i40iw/i40iw_osdep.h
> @@ -38,7 +38,7 @@
>  #include <stdbool.h>
>  #include <stdio.h>
>  #include <string.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>  #include <linux/types.h>
>  typedef unsigned char u8;
>  typedef unsigned long long u64;
> diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
> index ea3255f753e59d..d3e4fec7d8515b 100644
> --- a/providers/i40iw/i40iw_uk.c
> +++ b/providers/i40iw/i40iw_uk.c
> @@ -32,6 +32,8 @@
>  *
>  ************************************************************************=
*******/
>=20
> +#include <stdint.h>
> +
>  #include "i40iw_osdep.h"
>  #include "i40iw_status.h"
>  #include "i40iw_d.h"
> diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.=
h
> index 4ca605797a9c04..1f86c8f90b10d9 100644
> --- a/providers/i40iw/i40iw_umain.h
> +++ b/providers/i40iw/i40iw_umain.h
> @@ -41,7 +41,7 @@
>  #include <util/compiler.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  #include "i40iw_osdep.h"
>  #include "i40iw_d.h"
> diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
> index bde1b33db176bb..aae50a80926f95 100644
> --- a/providers/mlx4/mlx4.h
> +++ b/providers/mlx4/mlx4.h
> @@ -39,7 +39,7 @@
>  #include <util/compiler.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>  #include <infiniband/verbs.h>
>=20
>  #define MLX4_PORTS_NUM 2
> diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
> index 3f89f4be91c5f5..58d622620a1f7b 100644
> --- a/providers/mlx5/mlx5.h
> +++ b/providers/mlx5/mlx5.h
> @@ -38,7 +38,7 @@
>  #include <util/compiler.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>  #include "mlx5-abi.h"
>  #include <ccan/list.h>
>  #include "bitmap.h"
> diff --git a/providers/mthca/mthca.h b/providers/mthca/mthca.h
> index b4b0b6a8a9d4ee..61ee92807fcb86 100644
> --- a/providers/mthca/mthca.h
> +++ b/providers/mthca/mthca.h
> @@ -37,7 +37,7 @@
>  #include <stddef.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  #include <valgrind/memcheck.h>
>=20
> diff --git a/providers/nes/nes_umain.h b/providers/nes/nes_umain.h
> index c10c4fe0b3eb3d..6a4366802db209 100644
> --- a/providers/nes/nes_umain.h
> +++ b/providers/nes/nes_umain.h
> @@ -40,7 +40,7 @@
>  #include <util/compiler.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  #define PFX	"libnes: "
>=20
> diff --git a/providers/ocrdma/ocrdma_main.h b/providers/ocrdma/ocrdma_mai=
n.h
> index b8be6e514c72c7..6c74545d08df2d 100644
> --- a/providers/ocrdma/ocrdma_main.h
> +++ b/providers/ocrdma/ocrdma_main.h
> @@ -40,7 +40,7 @@
>  #include <endian.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  #include <ccan/list.h>
>=20
> diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
> index e2a92489d2c147..e887d9f8e4713a 100644
> --- a/providers/qedr/qelr.h
> +++ b/providers/qedr/qelr.h
> @@ -39,7 +39,7 @@
>  #include <ccan/minmax.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  #define writel(b, p) (*(uint32_t *)(p) =3D (b))
>  #define writeq(b, p) (*(uint64_t *)(p) =3D (b))
> diff --git a/providers/qedr/qelr_main.h b/providers/qedr/qelr_main.h
> index 1f65be6156db7c..88d52b7aed2b66 100644
> --- a/providers/qedr/qelr_main.h
> +++ b/providers/qedr/qelr_main.h
> @@ -38,7 +38,7 @@
>  #include <endian.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  struct ibv_device *qelr_driver_init(const char *, int);
>=20
> diff --git a/providers/qedr/qelr_verbs.h b/providers/qedr/qelr_verbs.h
> index b73ae9e0adac34..28ad18c8885e46 100644
> --- a/providers/qedr/qelr_verbs.h
> +++ b/providers/qedr/qelr_verbs.h
> @@ -38,7 +38,7 @@
>  #include <endian.h>
>=20
>  #include <infiniband/driver.h>
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  int qelr_query_device(struct ibv_context *context,
>  		      struct ibv_device_attr *attr);
> diff --git a/providers/vmw_pvrdma/cq.c b/providers/vmw_pvrdma/cq.c
> index 0c7dcf67b54d30..f24d80742678bd 100644
> --- a/providers/vmw_pvrdma/cq.c
> +++ b/providers/vmw_pvrdma/cq.c
> @@ -43,7 +43,7 @@
>   * OF THE POSSIBILITY OF SUCH DAMAGE.
>   */
>=20
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  #include "pvrdma.h"
>=20
> diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
> index 1b013592304d01..d2e2189fda6de4 100644
> --- a/providers/vmw_pvrdma/qp.c
> +++ b/providers/vmw_pvrdma/qp.c
> @@ -43,7 +43,7 @@
>   * OF THE POSSIBILITY OF SUCH DAMAGE.
>   */
>=20
> -#include <infiniband/arch.h>
> +#include <util/udma_barrier.h>
>=20
>  #include "pvrdma.h"
>=20
> diff --git a/util/CMakeLists.txt b/util/CMakeLists.txt
> index c0ad5861d189ee..71e33ac3baaa9b 100644
> --- a/util/CMakeLists.txt
> +++ b/util/CMakeLists.txt
> @@ -1,4 +1,5 @@
>  publish_internal_headers(util
>    compiler.h
> +  udma_barrier.h
>    util.h
>    )
> diff --git a/util/udma_barrier.h b/util/udma_barrier.h
> new file mode 100644
> index 00000000000000..57ab0f76cbe33e
> --- /dev/null
> +++ b/util/udma_barrier.h
> @@ -0,0 +1,125 @@
> +/*
> + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef __UTIL_UDMA_BARRIER_H
> +#define __UTIL_UDMA_BARRIER_H
> +
> +/*
> + * Architecture-specific defines.  Currently, an architecture is
> + * required to implement the following operations:
> + *
> + * mb() - memory barrier.  No loads or stores may be reordered across
> + *     this macro by either the compiler or the CPU.
> + * rmb() - read memory barrier.  No loads may be reordered across this
> + *     macro by either the compiler or the CPU.
> + * wmb() - write memory barrier.  No stores may be reordered across
> + *     this macro by either the compiler or the CPU.
> + * wc_wmb() - flush write combine buffers.  No write-combined writes
> + *     will be reordered across this macro by either the compiler or
> + *     the CPU.
> + */
> +
> +#if defined(__i386__)
> +
> +#define mb()	 asm volatile("lock; addl $0,0(%%esp) " ::: "memory")
> +#define rmb()	 mb()
> +#define wmb()	 asm volatile("" ::: "memory")
> +#define wc_wmb() mb()
> +
> +#elif defined(__x86_64__)
> +
> +/*
> + * Only use lfence for mb() and rmb() because we don't care about
> + * ordering against non-temporal stores (for now at least).
> + */
> +#define mb()	 asm volatile("lfence" ::: "memory")
> +#define rmb()	 mb()
> +#define wmb()	 asm volatile("" ::: "memory")
> +#define wc_wmb() asm volatile("sfence" ::: "memory")
> +
> +#elif defined(__PPC64__)
> +
> +#define mb()	 asm volatile("sync" ::: "memory")
> +#define rmb()	 asm volatile("lwsync" ::: "memory")
> +#define wmb()	 mb()
> +#define wc_wmb() wmb()
> +
> +#elif defined(__ia64__)
> +
> +#define mb()	 asm volatile("mf" ::: "memory")
> +#define rmb()	 mb()
> +#define wmb()	 mb()
> +#define wc_wmb() asm volatile("fwb" ::: "memory")
> +
> +#elif defined(__PPC__)
> +
> +#define mb()	 asm volatile("sync" ::: "memory")
> +#define rmb()	 mb()
> +#define wmb()	 mb()
> +#define wc_wmb() wmb()
> +
> +#elif defined(__sparc_v9__)
> +
> +#define mb()	 asm volatile("membar #LoadLoad | #LoadStore | #StoreStore =
| #StoreLoad" ::: "memory")
> +#define rmb()	 asm volatile("membar #LoadLoad" ::: "memory")
> +#define wmb()	 asm volatile("membar #StoreStore" ::: "memory")
> +#define wc_wmb() wmb()
> +
> +#elif defined(__sparc__)
> +
> +#define mb()	 asm volatile("" ::: "memory")
> +#define rmb()	 mb()
> +#define wmb()	 mb()
> +#define wc_wmb() wmb()
> +
> +#elif defined(__s390x__)
> +
> +#define mb()	{ asm volatile("" : : : "memory"); }	/* for s390x */
> +#define rmb()	mb()					/* for s390x */
> +#define wmb()	mb()					/* for s390x */
> +#define wc_wmb() wmb()					/* for s390x */
> +
> +#elif defined(__aarch64__)
> +
> +/* Perhaps dmb would be sufficient? Let us be conservative for now. */
> +#define mb()	{ asm volatile("dsb sy" ::: "memory"); }
> +#define rmb()	{ asm volatile("dsb ld" ::: "memory"); }
> +#define wmb()	{ asm volatile("dsb st" ::: "memory"); }
> +#define wc_wmb() wmb()
> +
> +#else
> +
> +#error No architecture specific memory barrier defines found!
> +
> +#endif
> +
> +#endif
> --
> 2.7.4
>=20

Looks good.

Reviewed-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
