From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/2] infiniband: qplib_fp: fix pointer cast
Date: Wed, 28 Feb 2018 14:15:14 -0700
Message-ID: <20180228211514.GC13394@ziepe.ca>
References: <20180220205638.1959033-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180220205638.1959033-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Eddie Wai <eddie.wai@broadcom.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 20, 2018 at 09:56:26PM +0100, Arnd Bergmann wrote:
> Building for a 32-bit target results in a couple of warnings from casting between
> a 32-bit pointer and a 64-bit integer:
> 
> drivers/infiniband/hw/bnxt_re/qplib_fp.c: In function 'bnxt_qplib_service_nq':
> drivers/infiniband/hw/bnxt_re/qplib_fp.c:333:23: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>     bnxt_qplib_arm_srq((struct bnxt_qplib_srq *)q_handle,
>                        ^
> drivers/infiniband/hw/bnxt_re/qplib_fp.c:336:12: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>             (struct bnxt_qplib_srq *)q_handle,
>             ^
> In file included from include/linux/byteorder/little_endian.h:5,
>                  from arch/arm/include/uapi/asm/byteorder.h:22,
>                  from include/asm-generic/bitops/le.h:6,
>                  from arch/arm/include/asm/bitops.h:342,
>                  from include/linux/bitops.h:38,
>                  from include/linux/kernel.h:11,
>                  from include/linux/interrupt.h:6,
>                  from drivers/infiniband/hw/bnxt_re/qplib_fp.c:39:
> drivers/infiniband/hw/bnxt_re/qplib_fp.c: In function 'bnxt_qplib_create_srq':
> include/uapi/linux/byteorder/little_endian.h:31:43: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>  #define __cpu_to_le64(x) ((__force __le64)(__u64)(x))
>                                            ^
> include/linux/byteorder/generic.h:86:21: note: in expansion of macro '__cpu_to_le64'
>  #define cpu_to_le64 __cpu_to_le64
>                      ^~~~~~~~~~~~~
> drivers/infiniband/hw/bnxt_re/qplib_fp.c:569:19: note: in expansion of macro 'cpu_to_le64'
>   req.srq_handle = cpu_to_le64(srq);
> 
> Using a uintptr_t as an intermediate works on all architectures.
> 
> Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I applied the series to for-next, thanks

Jason
