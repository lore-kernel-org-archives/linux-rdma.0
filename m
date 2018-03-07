From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] infiniband: qplib_fp: fix pointer cast
Date: Wed, 7 Mar 2018 10:05:05 +0100
Message-ID: <CAK8P3a0mHEm8m8=CfV5Qmw0EcVCc31OetdFXHQ0KEvWk6K40Gw@mail.gmail.com>
References: <20180220205638.1959033-1-arnd@arndb.de> <20180228211514.GC13394@ziepe.ca>
 <CAK8P3a2dsQ7QAb64DCp9Fc2xXjEyHNjBFdRc=y6FanQKsXhADg@mail.gmail.com> <20180306234539.GB1037@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306234539.GB1037@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Eddie Wai <eddie.wai@broadcom.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 7, 2018 at 12:45 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Wed, Mar 07, 2018 at 12:25:14AM +0100, Arnd Bergmann wrote:
>> On Wed, Feb 28, 2018 at 10:15 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>> > On Tue, Feb 20, 2018 at 09:56:26PM +0100, Arnd Bergmann wrote:
>> >> Building for a 32-bit target results in a couple of warnings from casting between
>> >> a 32-bit pointer and a 64-bit integer:
>> >>
>> >> drivers/infiniband/hw/bnxt_re/qplib_fp.c: In function 'bnxt_qplib_service_nq':
>> >> drivers/infiniband/hw/bnxt_re/qplib_fp.c:333:23: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> >>     bnxt_qplib_arm_srq((struct bnxt_qplib_srq *)q_handle,
>> >>                        ^
>> >> drivers/infiniband/hw/bnxt_re/qplib_fp.c:336:12: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> >>             (struct bnxt_qplib_srq *)q_handle,
>> >>             ^
>> >> In file included from include/linux/byteorder/little_endian.h:5,
>> >>                  from arch/arm/include/uapi/asm/byteorder.h:22,
>> >>                  from include/asm-generic/bitops/le.h:6,
>> >>                  from arch/arm/include/asm/bitops.h:342,
>> >>                  from include/linux/bitops.h:38,
>> >>                  from include/linux/kernel.h:11,
>> >>                  from include/linux/interrupt.h:6,
>> >>                  from drivers/infiniband/hw/bnxt_re/qplib_fp.c:39:
>> >> drivers/infiniband/hw/bnxt_re/qplib_fp.c: In function 'bnxt_qplib_create_srq':
>> >> include/uapi/linux/byteorder/little_endian.h:31:43: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>> >>  #define __cpu_to_le64(x) ((__force __le64)(__u64)(x))
>> >>                                            ^
>> >> include/linux/byteorder/generic.h:86:21: note: in expansion of macro '__cpu_to_le64'
>> >>  #define cpu_to_le64 __cpu_to_le64
>> >>                      ^~~~~~~~~~~~~
>> >> drivers/infiniband/hw/bnxt_re/qplib_fp.c:569:19: note: in expansion of macro 'cpu_to_le64'
>> >>   req.srq_handle = cpu_to_le64(srq);
>> >>
>> >> Using a uintptr_t as an intermediate works on all architectures.
>> >>
>> >> Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
>> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> >>  drivers/infiniband/hw/bnxt_re/qplib_fp.c | 4 ++--
>> >>  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > I applied the series to for-next, thanks
>>
>> Hi Jason,
>>
>> kernelci still reports the warning for v4.16-rc, any chance you can also send it
>> as a bugfix for the current release?
>
> As a general rule we haven't been sending sparse cleanups like this to
> -rc which is why it went to -next..
>
> Can you talk about why this is important to kernelci? I'm not familiar
> at all with it.
>
> I'm a little leary to duplicate a commit in both our branches without
> a good reason??

I agree that we shouldn't do this for sparse warnings, but the one I'm
interested in is a compiler warning in the allmodconfig build, as
found by kernelci.org. This is one of only three remaining warnings
that it reports for any of the default builds, see [1] for the overall
build reports on mainline kernels, and [2] for the detailed log of
the arm64 allmodconfig build that shows it.

A small complication is that I wrote the changelog for the build warning
on 32-bit architectures, which is more elaborate. kernelci.org for
some reasons currently skips the allmodconfig build on all 32-bit
architectures (I should ask the kernelci maintainers to change that),
but the same patch I sent also addresses a warning on bit-endian
64-bit architectures:

../drivers/infiniband/hw/bnxt_re/qplib_fp.c: In function
'bnxt_qplib_create_srq':
../include/uapi/linux/byteorder/big_endian.h:31:52: warning: passing
argument 1 of '__fswab64' makes integer from pointer without a cast
[-Wint-conversion]
 #define __cpu_to_le64(x) ((__force __le64)__swab64((x)))
                                                    ^
../include/uapi/linux/swab.h:132:12: note: in definition of macro '__swab64'
  __fswab64(x))
            ^
../include/linux/byteorder/generic.h:86:21: note: in expansion of
macro '__cpu_to_le64'
 #define cpu_to_le64 __cpu_to_le64
                     ^
../drivers/infiniband/hw/bnxt_re/qplib_fp.c:569:19: note: in expansion
of macro 'cpu_to_le64'
  req.srq_handle = cpu_to_le64(srq);
                   ^
../include/uapi/linux/swab.h:65:41: note: expected '__u64 {aka long
long unsigned int}' but argument is of type 'struct bnxt_qplib_srq *'
 static inline __attribute_const__ __u64 __fswab64(__u64 val)

On x86 and on the arm64 defconfig build, the __cpu_to_le64() is defined in
include/uapi/linux/byteorder/little_endian.h and degrades into a __force
cast that happens to avoid this warning, but on arm64 allmodconfig,
we use include/uapi/linux/byteorder/big_endian.h, which passes
the pointer into __swab64() first, and that warns about the type
mismatch.

       Arnd

[1] https://kernelci.org/build/mainline/branch/master/kernel/v4.16-rc4-123-g86f84779d8e9/
[2] https://storage.kernelci.org/mainline/master/v4.16-rc4-123-g86f84779d8e9/arm64/allmodconfig/build.log
