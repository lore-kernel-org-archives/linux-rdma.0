From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V2 10/17] xprtrdma: Add CONFIG setting that can disable
 ALLPHYSICAL
Date: Mon, 21 Apr 2014 23:23:38 -0700
Message-ID: <20140422062338.GA23311@infradead.org>
References: <20140421214442.12569.8950.stgit@manet.1015granger.net>
 <20140421220214.12569.23157.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140421220214.12569.23157.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 21, 2014 at 06:02:14PM -0400, Chuck Lever wrote:
> ALLPHYSICAL is not a safe memory registration mode because it
> permits NFS servers to write anywhere in a client's memory.  NFS
> server bugs could result in client memory being overwritten.
> 
> This can be useful for embedded systems which do not support more
> surgical RDMA memory registration and protection methods, or for
> bring-up of new HCA hardware.
> 
> However, enterprise Linux distributions have expressed a desire to
> disable it in production environments.

It's just as unsafe in embedded devices.  I think it should go
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
