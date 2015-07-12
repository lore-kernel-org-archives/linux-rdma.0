From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 04/12] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Sun, 12 Jul 2015 00:58:14 -0700
Message-ID: <20150712075814.GA6636@infradead.org>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204218.26247.67243.stgit@manet.1015granger.net>
 <20150711103428.GD14741@infradead.org>
 <682604AF-955A-44F8-86F9-EB7D403CABFF@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <682604AF-955A-44F8-86F9-EB7D403CABFF-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 11, 2015 at 02:50:58PM -0400, Chuck Lever wrote:
> I would prefer to run this by Doug Oucharek first, as a courtesy.
> Unless I???m mistaken, the Lustre client is supposed to be on its
> way into the kernel, not on its way out.

The only way a mess like lustre got into the kernel tree at all is
because the rules allow ignoring the staging tree for API changes,
otherwise kernel development wouldn't scale.  Lustre isn't really
on the way in, it's been in the staging tree forever and has made
zero progress towards actually being maintainable code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
