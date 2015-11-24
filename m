From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 8/8] svcrdma: Remove svc_rdma_fastreg_mr::access_flags
 field
Date: Mon, 23 Nov 2015 22:39:03 -0800
Message-ID: <20151124063903.GA12300@infradead.org>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net>
 <20151123222118.13040.24258.stgit@klimt.1015granger.net>
 <5653B4CA.5050806@talpey.com>
 <92B143FC-0F2C-48E4-9042-189883D76403@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <92B143FC-0F2C-48E4-9042-189883D76403-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 07:53:04PM -0500, Chuck Lever wrote:
> > Wait, the REMOTE_WRITE is there to support iWARP, but it isn't
> > needed for IB or RoCE. Shouldn't this be updated to peek at those
> > new attributes to decide, instead of remaining unconditional?
> 
> That???s coming in another patch from Christoph.

Can you drop this patch so that we have less conflicts with that one,
assuming this series goes in through the NFS tree, and the memory
registration changes go in through the RDMA tree?
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
