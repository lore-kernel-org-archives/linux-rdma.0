From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: some test question//Re: [For help] configure crossbar build tool in
 CMakelist.txt
Date: Wed, 19 Oct 2016 10:53:34 +0800
Message-ID: <5806E02E.7030400@huawei.com>
References: <5805FF8C.1060902@huawei.com>
 <20161018155004.GA24189@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161018155004.GA24189-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, Jason

Indeed, you are right! when use the cmd: CC= aarch64-linux-gnu-gcc cmake -GNinja ..

the libnl doesn't work

the print log as follows:

ubuntu@62fe1357a077:~/rdma-core/build$ ninja
[27/164] Linking C executable bin/iwpmd
FAILED: : && /opt/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin/aarch64-linux-gnu-gcc -std=gnu99 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wshadow -Wno-missing-field-initializers -Wstrict-prototypes -Wold-style-definition -O2 -g -Wl,--as-needed -Wl,--no-undefined iwpmd/CMakeFiles/iwpmd.dir/iwarp_pm_common.c.o iwpmd/CMakeFiles/iwpmd.dir/iwarp_pm_helper.c.o iwpmd/CMakeFiles/iwpmd.dir/iwarp_pm_server.c.o -o bin/iwpmd ccan/libccan.a -lnl-route-3 -lnl-3 -lpthread && :
/opt/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin/../lib/gcc/aarch64-linux-gnu/4.9.2/../../../../aarch64-linux-gnu/bin/ld: cannot find -lnl-route-3
/opt/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin/../lib/gcc/aarch64-linux-gnu/4.9.2/../../../../aarch64-linux-gnu/bin/ld: cannot find -lnl-3
collect2: error: ld returned 1 exit status
[27/164] Building C object libibverbs/CMakeFiles/ibverbs.dir/cmd.c.o
ninja: build stopped: subcommand failed.


when use the cmd: CC=aarch64-linux-gnu-gcc cmake -GNinja -DENABLE_RESOLVE_NEIGH=0 ..

the provider/hns/CMakelist.txt can be called correctly and generate the library libhns-rdmav2.so(not be tested), but it will generate warning with mlx5

the print log as follows:

Building C object providers/mlx5/CMakeFiles/mlx5-rdmav2.dir/cq.c.o
../providers/mlx5/cq.c:414:13: warning: function declaration isn't a prototype [-Wstrict-prototypes]
static void mlx5_stall_poll_cq()
^
../providers/mlx5/cq.c: In function 'mlx5_stall_poll_cq':
../providers/mlx5/cq.c:414:13: warning: old-style function definition [-Wold-style-definition]

In summary, I have two questions:

1. if don't use libnl(use -DENABLE_RESOLVE_NEIGH=0), it will not confluent the function of library?

2. the rdma-core.git use the default build method by used build.sh, and i need modify it by added the building item or modify the README.md for hns, is the right approach?


Thanks

在 2016/10/18 23:50, Jason Gunthorpe 写道:
> On Tue, Oct 18, 2016 at 06:55:08PM +0800, oulijun wrote:
> 
>>   if I use crossbar build tool aarch64-linux-gnu-gcc for building
>>   the directory(provider/hns), what i should do it ?
> 
> You cannot cross compile only a part of the project, you must cross
> compile everything.
> 
> $ mkdir build; cd build
> $ CC=aarch64-linux-gnu-gcc cmake -GNinja
> $ ninja
> 
> I haven't extensively tested cross compiling, you may run into
> problems, in particular I know pkgconfig for libnl doesn't work
> reliably when cross compiling.
> 
> You may need to build with -DENABLE_RESOLVE_NEIGH=0 if you don't have
> a cross compiled libnl3 available.
> 
>> My modification currently according to the others as fllows:
>>
>> in the file : provider/hns/CMakelist.txt
>>
>> set(CMAKE_C_COMPILER /opt/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin/aarch64-linux-gnu-gcc)
> 
> This is not the right approach, the hns provider CMakelist should
> detect the compiler is not ARM64 and just do nothing.
> 
> Perhaps something like this:
> 
> CHECK_C_SOURCE_COMPILES("
> #ifndef __ARM64__
> #error Failed
> #endif
>  int main(int argc,const char *argv[]) { return 1; }"
>  HAVE_ARCH_ARM64)
> 
> if (HAVE_ARCH_ARM64)
>  [..]
> endif()
>  
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
