From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] util/mmio.c: Fix compilation errors when
 __SSE__ is not set on 32 bit
Date: Mon, 13 Nov 2017 11:59:33 -0700
Message-ID: <20171113185933.GB6918@ziepe.ca>
References: <20171113060806.27354-1-leon@kernel.org>
 <20171113060806.27354-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171113060806.27354-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 13, 2017 at 08:08:05AM +0200, Leon Romanovsky wrote:
> From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> When building for 32 bit, the compilation may fail with the following
> errors in case that __SSE__ is not set:
> 
> In file included from ../util/mmio.c:37:0:
> /usr/lib/gcc/x86_64-linux-gnu/4.8/include/xmmintrin.h:31:3: error: #error "SSE instruction set not enabled"

Please do not apply this until we fix the root cause.

Debian and RH 32 bit builds should be built with SSE turned on, so
they may need some compiler options in their packaging files.

Otherwise all this code is totally useless.

Also, this condition should be a #warning print or some kind of cmake
failure as it is deeply undesired..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
