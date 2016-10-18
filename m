From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ???For help??? configure crossbar build tool in CMakelist.txt
Date: Tue, 18 Oct 2016 09:50:04 -0600
Message-ID: <20161018155004.GA24189@obsidianresearch.com>
References: <5805FF8C.1060902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5805FF8C.1060902-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 18, 2016 at 06:55:08PM +0800, oulijun wrote:

>   if I use crossbar build tool aarch64-linux-gnu-gcc for building
>   the directory(provider/hns), what i should do it ?

You cannot cross compile only a part of the project, you must cross
compile everything.

$ mkdir build; cd build
$ CC=aarch64-linux-gnu-gcc cmake -GNinja
$ ninja

I haven't extensively tested cross compiling, you may run into
problems, in particular I know pkgconfig for libnl doesn't work
reliably when cross compiling.

You may need to build with -DENABLE_RESOLVE_NEIGH=0 if you don't have
a cross compiled libnl3 available.

> My modification currently according to the others as fllows:
> 
> in the file : provider/hns/CMakelist.txt
> 
> set(CMAKE_C_COMPILER /opt/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin/aarch64-linux-gnu-gcc)

This is not the right approach, the hns provider CMakelist should
detect the compiler is not ARM64 and just do nothing.

Perhaps something like this:

CHECK_C_SOURCE_COMPILES("
#ifndef __ARM64__
#error Failed
#endif
 int main(int argc,const char *argv[]) { return 1; }"
 HAVE_ARCH_ARM64)

if (HAVE_ARCH_ARM64)
 [..]
endif()
 
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
