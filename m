From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Tue, 10 Jan 2017 11:30:51 -0500
Message-ID: <a1b3f6cc-2de0-8a19-18dd-182f2cb7d3e1@dev.mellanox.co.il>
References: <20170109213944.31970-1-jarod@redhat.com>
 <20170109223108.GA10850@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170109223108.GA10850-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/9/2017 5:31 PM, Jason Gunthorpe wrote:
> On Mon, Jan 09, 2017 at 04:39:44PM -0500, Jarod Wilson wrote:
>> Building for 32-bit arm, things fall down, due to lack of arch-specific
>> memory barriers.
> 
> Since we now have rxe that should work on ARM I think we need to fix
> this upstream..
> 
> Do you have time to test some patches on ARM?

Looks to me that issue was introduced by:

commit 1df0888f6a736e1612ce8b054d6c17651ebd003f
Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date:   Fri Sep 2 12:57:57 2016 -0600

    Remove most checks of __BYTE_ORDER

    For a long time now endian.h has defined sane fixed with conversion
    macros, so lets just use them instead of rolling our own.

    Also, htonll is defined in this source tree under infiniband/arch.h,
    so all users of that macro can just use the header.

    Someday we should also get rid of all the endless wrappers..

    Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

where byte order macros are from libibverbs arch.h which also includes
the memory barrier stuff.

So can't arch.h be separated out into 2 headers and have the various
parts of rdma-core include one or both of these headers as needed ?

-- Hal

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
