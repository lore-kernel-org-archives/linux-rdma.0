From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 3/9] xprtrdma: Introduce ro_unmap_sync method
Date: Mon, 23 Nov 2015 22:45:56 -0800
Message-ID: <20151124064556.GA29141@infradead.org>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221414.32702.87638.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151123221414.32702.87638.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 05:14:14PM -0500, Chuck Lever wrote:
> In the current xprtrdma implementation, some memreg strategies
> implement ro_unmap synchronously (the MR is knocked down before the
> method returns) and some asynchonously (the MR will be knocked down
> and returned to the pool in the background).
> 
> To guarantee the MR is truly invalid before the RPC consumer is
> allowed to resume execution, we need an unmap method that is
> always synchronous, invoked from the RPC/RDMA reply handler.
> 
> The new method unmaps all MRs for an RPC. The existing ro_unmap
> method unmaps only one MR at a time.

Do we really want to go down that road?  It seems like we've decided
in general that while the protocol specs say MR must be unmapped before
proceeding with the data that is painful enough to ignore this
requirement.  E.g. iser for example only does the local invalidate
just before reusing the MR.

I'd like to hear arguments for and against each method instead of
adding more magic to drivers to either optimize MR performance and
add clunky workarounds to make it even slower, and instead handled
the semantics we agreed upo in common code.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
