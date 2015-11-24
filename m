From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 3/8] svcrdma: Add svc_rdma_get_context() API that is
 allowed to fail
Date: Tue, 24 Nov 2015 12:02:12 -0800
Message-ID: <20151124200212.GA10208@infradead.org>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net>
 <20151123222038.13040.61285.stgit@klimt.1015granger.net>
 <20151124065522.GC29141@infradead.org>
 <7717B6B1-4A27-4D8A-8BCC-528CEC6DB54D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7717B6B1-4A27-4D8A-8BCC-528CEC6DB54D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2015 at 09:24:51AM -0500, Chuck Lever wrote:
> There is only one (new) call site that needs it. I can simplify
> this patch as Sagi suggested before, but it seems silly to
> introduce the extra clutter of adding a gfp_t argument
> everywhere.

We a) generally try to pass the gfp_t around if we expect calling
contexts to change, and b the changes to the 6 callers are probably
still smaller than this patch :)

> > And if we have any way to avoid the __GFP_NOFAIL
> > I'd really appreciate if we could give that a try.
> 
> I???m not introducing the flag here.
> 
> Changing all the svc_rdma_get_context() call sites to handle
> allocation failure (when it is already highly unlikely) is
> a lot of needless work, IMO, and not related to supporting
> bi-directional RPC.

Ok.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
