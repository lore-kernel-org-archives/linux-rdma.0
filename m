From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/1] IB/mlx4: Unaligned access in send_reply_to_slave
Date: Tue, 17 May 2016 11:37:11 +0300
Message-ID: <20160517083710.GA14673@shamir-linux.uk.oracle.com>
References: <1463462198-15674-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20160517073940.GF4662@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160517073940.GF4662-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 17, 2016 at 10:39:40AM +0300, Leon Romanovsky wrote:
> On Tue, May 17, 2016 at 01:16:38AM -0400, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
> > From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > The problem is that the function 'send_reply_to_slave' get the
> > 'req_sa_mad' as pointer whose address can be unaligned to 8 bytes.
> > In this case the compiler cannot know in advance what will be the
> > alignment of the 'data' field.
> > 
> > Sowmini Varadhan pointed to this reply from Dave Miller that say
> > that memcpy should not be used to solve alignment issues:
> > https://lkml.org/lkml/2015/10/21/352
> > 
> > The reason why memcpy works here is because we memcpy someting that
> > is bigger then 8 bytes and so the compiler cannot optimize this to
> > 'ldx' instruction.
> > 
> > Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> The difference between this version and previous version is in the
> title, am I right?

Correct. Minor request from Or Gerlitz.

Main issue which I want to address is this:

In the CM & MAD code we see many issues of unaligned access.

This has 2 main sources.
1. CM & MAD packets that are not built according to the alignment rules
2. Aligned structures that are put in arbitrary unaligned memory
locations

This issue affect platforms that require aligned access to anything
above 1 byte (e.g. sparc64).

The best way to avoid this issue is to design the packed wire packets
with alignment rules in place and align the start of any such structure
to 8 bytes when used.

Given that this is not the case in CM & MAD and it's wire protocol I try
to find the best way to avoid such issues w/o changing the whole code.

As Dave Miller noted in another case - the compiler is free to look in
to the cast and if it see that the object we try to copy has size of 8
bytes it can emit the memcpy and change it to 'ldx' instruction.

'ldx' instruction is sensitive to 8 bytes alignment and so we have the
issue.

Use of 'get_unaligned' should be option 1 to consider.

Only issue with this macro is that it only take care for data types with
size of 8, 16, 32, 64 bit.

It is good when we try to access something that is one of those types.

But when we try to cast some bigger structure and then copy some enum
from this structure it is not clear if this is the best way.

This is what I try to review here. 

Comments are more then welcome..

> 
> Thanks.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
