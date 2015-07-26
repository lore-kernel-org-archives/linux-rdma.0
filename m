From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 06/15] xprtrdma: Clean up rpcrdma_ia_open()
Date: Sun, 26 Jul 2015 11:51:01 -0700
Message-ID: <20150726185101.GA27309@infradead.org>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190320.10997.40165.stgit@manet.1015granger.net>
 <20150726165337.GC9273@infradead.org>
 <B8761105-FE4E-4DD4-8E3D-77F30B170ADD@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B8761105-FE4E-4DD4-8E3D-77F30B170ADD-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 26, 2015 at 02:21:23PM -0400, Chuck Lever wrote:
> No, this patch is not strictly needed in 4.3, but my read of
> Jason?s series is that he does not touch xprtrdma. I don?t
> believe there will be a merge conflict.
> 
> The goal of this patch is to move xprtrdma forward so it will
> be straightforward to use pd->local_dma_key for RPC send and
> receive buffers. That?s a change that can be added after both
> this patch and Jason?s series is merged.
> 
> I prefer keeping this patch separate, because that makes it
> simpler to review and test this refactor. I don?t see a reason
> to delay it, but I can do that if it is needed.

You're right, Jason didn't touch xprtrdma. Sorry for the noise.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
