From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Fri, 3 Feb 2017 09:48:18 -0700
Message-ID: <20170203164818.GA18398@obsidianresearch.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <1485446182-5109-8-git-send-email-yishaih@mellanox.com>
 <20170126173005.GD16562@obsidianresearch.com>
 <20170203160419.GA28953@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170203160419.GA28953-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 03, 2017 at 08:04:19AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 26, 2017 at 10:30:05AM -0700, Jason Gunthorpe wrote:
> > No, this is no longer just a provider so it doesn't get to use
> > provider.map
> > 
> > mlx5 will need its own map file and the various magic I described to
> > become a proper library and a plugin at once.
> 
> Honestly, I don't think it should be both at once.  The library for
> direct access needs to be in /usr/lib and the provider hidden in the
> providers directory, and not export anything not in the providers API.

Provider libraries don't export any symbols at all. That is the main
reason having a library be both could potentially work out OK.. 

But it would have to be a proper /usr/lib/../ library first, and be
symlinked to a provider lib name second... And they will have to make
sure that dlopen figures this out and only loads one copy..

> I think what needs to happen is a new library for the direct access,
> and the provider should be layered on top of it.

I suspect that might just make a bigger mess, it looks like there is
some sharing of internal statics and what not - so the two libraries
would end up having their own private symbol interface, which is
looking like be a worse situation then the above...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
