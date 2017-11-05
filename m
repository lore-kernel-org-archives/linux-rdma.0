From: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] travis: Test Debian packaging under Artful
 container
Date: Sun, 5 Nov 2017 15:30:01 +0200
Message-ID: <f6a250cd-dd4f-5dbe-4b1d-53f2b1f87b32@dev.mellanox.co.il>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-6-leon@kernel.org> <20171102170554.GO18874@ziepe.ca>
 <20171102173255.GC16127@mtr-leonro.local> <20171102175522.GR18874@ziepe.ca>
 <2e2d65c2-845e-13ad-1022-a859b2fef6a7@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2e2d65c2-845e-13ad-1022-a859b2fef6a7-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/11/2017 12:00, Alaa Hleihel wrote:
>
> On 02/11/2017 19:55, Jason Gunthorpe wrote:
>> On Thu, Nov 02, 2017 at 07:32:55PM +0200, Leon Romanovsky wrote:
>>> On Thu, Nov 02, 2017 at 11:05:54AM -0600, Jason Gunthorpe wrote:
>>>> On Thu, Nov 02, 2017 at 06:55:56PM +0200, Leon Romanovsky wrote:
>>>>> From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>
>>>>> This will be compiled with GCC 7 coming with Ubuntu Artful
>>>> Hurm. This point of this is to test the latest gcc, not just the GCC
>>>> in a distro.
>>>>
>>>> We should be testing gcc-8 here, but it isn't available for
>>>> trusty right now. :(
>>>>
>>>> Then the lines:
>>>>
>>>>       - ubuntu-toolchain-r-test
>>>>
>>>> and
>>>>
>>>>       - gcc-7
>>>>
>>>> Should be removed from the .travis.yml as well in this patch.
>>> lib32gcc-7-dev depends on gcc-7 and it depends on
>>> ubuntu-toolchain-r-test.
>> We can probably use the 32 bit packages that come with trusty..
> OK, I'll remove GCC-7 and deb helpers installations from travis.yml.
>
> Regards,
> Alaa

There are issues using the trusty 32 bit packages (I'm getting #error "SSE instruction set not enabled").
So, for now I will only cleanup the unnecessary deb helpers from travis.yml .


+cd ../build32
+CFLAGS='-Werror -m32'
+cmake -GNinja .. -DENABLE_RESOLVE_NEIGH=0
-- The C compiler identification is GNU 4.8.5
...
...
...
-- Build files have been written to: /home/travis/build/alaahl/rdma-core/build32
+ninja
[11/183] Building C object util/CMakeFiles/rdma_util.dir/mmio.c.o
FAILED: /usr/bin/gcc   -Werror -m32  -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wshadow -Wno-missing-field-initializers -Wstrict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g  -Iinclude    -std=gnu11 -MMD -MT util/CMakeFiles/rdma_util.dir/mmio.c.o -MF util/CMakeFiles/rdma_util.dir/mmio.c.o.d -o util/CMakeFiles/rdma_util.dir/mmio.c.o   -c ../util/mmio.c
In file included from ../util/mmio.c:37:0:
/usr/lib/gcc/x86_64-linux-gnu/4.8/include/xmmintrin.h:31:3: error: #error "SSE instruction set not enabled"
 # error "SSE instruction set not enabled"
   ^
../util/mmio.c: In function ‘sse_mmio_write64_be’:
../util/mmio.c:45:2: error: unknown type name ‘__m128’
  __m128 tmp = {};
  ^
../util/mmio.c:45:2: error: empty scalar initializer
../util/mmio.c:45:2: error: (near initialization for ‘tmp’)
../util/mmio.c:46:2: error: implicit declaration of function ‘_mm_loadl_pi’ [-Werror=implicit-function-declaration]
  tmp = _mm_loadl_pi(tmp, (__force __m64 *)&val);
  ^
../util/mmio.c:46:35: error: ‘__m64’ undeclared (first use in this function)
  tmp = _mm_loadl_pi(tmp, (__force __m64 *)&val);
                                   ^
../util/mmio.c:46:35: note: each undeclared identifier is reported only once for each function it appears in
../util/mmio.c:46:42: error: expected expression before ‘)’ token
  tmp = _mm_loadl_pi(tmp, (__force __m64 *)&val);
                                          ^
../util/mmio.c:47:2: error: implicit declaration of function ‘_mm_storel_pi’ [-Werror=implicit-function-declaration]
  _mm_storel_pi((__m64 *)addr,tmp);
  ^
../util/mmio.c:47:24: error: expected expression before ‘)’ token
  _mm_storel_pi((__m64 *)addr,tmp);
                        ^
cc1: all warnings being treated as errors
[11/183] Building C object util/CMakeFiles/rdma_util_pic.dir/mmio.c.o
FAILED: /usr/bin/gcc   -Werror -m32  -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wshadow -Wno-missing-field-initializers -Wstrict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC -Iinclude    -std=gnu11 -MMD -MT util/CMakeFiles/rdma_util_pic.dir/mmio.c.o -MF util/CMakeFiles/rdma_util_pic.dir/mmio.c.o.d -o util/CMakeFiles/rdma_util_pic.dir/mmio.c.o   -c ../util/mmio.c
In file included from ../util/mmio.c:37:0:
/usr/lib/gcc/x86_64-linux-gnu/4.8/include/xmmintrin.h:31:3: error: #error "SSE instruction set not enabled"
 # error "SSE instruction set not enabled"
   ^
../util/mmio.c: In function ‘sse_mmio_write64_be’:
../util/mmio.c:45:2: error: unknown type name ‘__m128’
  __m128 tmp = {};
  ^
../util/mmio.c:45:2: error: empty scalar initializer
../util/mmio.c:45:2: error: (near initialization for ‘tmp’)
../util/mmio.c:46:2: error: implicit declaration of function ‘_mm_loadl_pi’ [-Werror=implicit-function-declaration]
  tmp = _mm_loadl_pi(tmp, (__force __m64 *)&val);
  ^
../util/mmio.c:46:35: error: ‘__m64’ undeclared (first use in this function)
  tmp = _mm_loadl_pi(tmp, (__force __m64 *)&val);
                                   ^
../util/mmio.c:46:35: note: each undeclared identifier is reported only once for each function it appears in
../util/mmio.c:46:42: error: expected expression before ‘)’ token
  tmp = _mm_loadl_pi(tmp, (__force __m64 *)&val);
                                          ^
../util/mmio.c:47:2: error: implicit declaration of function ‘_mm_storel_pi’ [-Werror=implicit-function-declaration]
  _mm_storel_pi((__m64 *)addr,tmp);
  ^
../util/mmio.c:47:24: error: expected expression before ‘)’ token
  _mm_storel_pi((__m64 *)addr,tmp);
                        ^
cc1: all warnings being treated as errors
[11/183] Building C object libibverbs/...keFiles/ibverbs_tools.dir/pingpong.c.o
ninja: build stopped: subcommand failed.



>> Arguably though it might be better to test with 32 bit gcc-latest..
>>
>> Even better would be to do 32 bit test under docker where we could make
>> 32 bit cross work 100% ..
>>
>> Jason
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
