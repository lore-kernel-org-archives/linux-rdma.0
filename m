From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Tue, 5 May 2015 08:44:11 -0700
Message-ID: <20150505154411.GA16729@infradead.org>
References: <20150313211124.22471.14517.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150313211124.22471.14517.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 13, 2015 at 05:21:17PM -0400, Chuck Lever wrote:
> This is a series of client-side patches for NFS/RDMA. In preparation
> for increasing the transport credit limit and maximum rsize/wsize,
> I've re-factored the memory registration logic into separate files,
> invoked via a method API.

Just curious if you ever though of moving this into the generic
rdma layer?

I've been working on a rdma based storage driver recently, and the
various different memory registration methods are a complete pain in the
ass, and impossible to test in and ULD without havin access to all kinds
of different hardware.

And from I see we litterly dont use them much different from the generic
dma mapping API helpers (at a very high level) so it seems it should
be easy to move a slightly expanded version of your API to the core
code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
