From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: some test question//Re: [For help] configure crossbar build tool
 in CMakelist.txt
Date: Tue, 18 Oct 2016 22:11:02 -0600
Message-ID: <20161019041102.GA28678@obsidianresearch.com>
References: <5805FF8C.1060902@huawei.com>
 <20161018155004.GA24189@obsidianresearch.com>
 <5806E02E.7030400@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5806E02E.7030400-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2016 at 10:53:34AM +0800, oulijun wrote:

> when use the cmd: CC=aarch64-linux-gnu-gcc cmake -GNinja -DENABLE_RESOLVE_NEIGH=0 ..
> 
> the provider/hns/CMakelist.txt can be called correctly and generate
> the library libhns-rdmav2.so(not be tested), but it will generate
> warning with mlx5
> 
> the print log as follows:
> 
> Building C object providers/mlx5/CMakeFiles/mlx5-rdmav2.dir/cq.c.o
> ../providers/mlx5/cq.c:414:13: warning: function declaration isn't a prototype [-Wstrict-prototypes]
> static void mlx5_stall_poll_cq()

Thanks, you may be the first person to compile on ARM64, so I'm glad
to hear that is your only warning, I will get it fixed.

> In summary, I have two questions:
> 
> 1. if don't use libnl(use -DENABLE_RESOLVE_NEIGH=0), it will not
> confluent the function of library?

Correct, RoCEE will not work entirely as expected if you try and run
the libibverbs from such a build.

> 2. the rdma-core.git use the default build method by used build.sh,
> and i need modify it by added the building item or modify the
> README.md for hns, is the right approach?

No.

If you native compile on an actual ARM64 machine you will not have
problems, simply follow the README.md directions to install the
required packages on the actual machine.

Your problem is cross compiling. Cross compiling is hard. You need to
make libnl3 available in your cross compiler's 'sysroot'. I can't
really give you generic good directions for that..

One option is to cross compile libnl and 'cross-install' it into the
compiler tree.

Another option is to download the libnl3 ARM64 packages from Debian and
then unpack and rename directories 'just so' to make it work.

But if you don't intend to run the build binaries (eg when you go to
test, you will build natively on ARM64), then don't worry about it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
