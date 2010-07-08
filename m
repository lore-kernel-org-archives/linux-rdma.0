From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r
	calls
Date: Thu, 8 Jul 2010 12:47:01 -0600
Message-ID: <20100708184701.GP4630@obsidianresearch.com>
References: <1278540873-3857-1-git-send-email-sdake@redhat.com> <adalj9lzv4r.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adalj9lzv4r.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 08, 2010 at 11:27:48AM -0700, Roland Dreier wrote:

> I'm really not sure about this patch one way or another.  With alloca,
> it ends up looking pretty clean, but we do introduce the tiny
> possibility of buffer overrun (since readdir_r uses a user-supplied
> buffer of poorly-specified size); the benefit is that we work within
> corosync's constraints.  I honestly don't have a good feeling whether
> the benefit exceeds the cost.
> 
> Jason, any opinion one way or another?

Well, my view is that this is needless churn/risk for a very bad
choice made by another project. Aliasing a perfectly thread safe
readdir() to assert is anti-social :)

I also do not think it enhances theoretical portability, as NAME_MAX
is not guarenteed to exist by POSIX and alloca is not a C or POSIX
standard function. (C99 stadardized alloca as variable sized arrays)

Frankly, as a Linux only low level library, relying on glibc behavior
to make it simpler and more correct is perfectly acceptable to me..

It isn't even the case that libibverbs is an outlier here, common
things like libcrypto even use readdir! Purging readdir from every
library your app might want to load via a plugin is a really futile
quest :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
