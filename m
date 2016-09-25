From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] libocrdma: Move ocrdma's list
 implementation into common directory
Date: Sun, 25 Sep 2016 16:05:23 -0600
Message-ID: <20160925220523.GA1821@obsidianresearch.com>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-5-git-send-email-leon@kernel.org>
 <20160925144121.GA12246@infradead.org>
 <20160925161315.GD4088@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160925161315.GD4088-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 25, 2016 at 07:13:15PM +0300, Leon Romanovsky wrote:
> On Sun, Sep 25, 2016 at 07:41:21AM -0700, Christoph Hellwig wrote:
> > This implementation was also copy and pasted from the Linux kernel
> > one, including the kernel document comments, and an incorrect license
> > was added to it.  It should be removed just like the Mellanox copy.
> 
> Awesome,
> Any suggestion where can we get list.h compliant with BSD license?
> Is this enough [1] ?
> 
> [1]
> https://github.com/lattera/freebsd/blob/master/sys/ofed/include/linux/list.h

I recommend CCAN's version, it looks like it would be trivial to
convert to.

https://github.com/rustyrussell/ccan/blob/master/ccan/list/list.h

We should also try and use their macros for the other stuff your
migrated, eg their container_of has more static checking, as does the
min/max, and they have a min/max_t implementation.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
