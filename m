From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 00/43] New fast registration API
Date: Thu, 23 Jul 2015 02:26:36 -0700
Message-ID: <20150723092636.GD32592@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <20150722171023.GA18934@infradead.org>
 <20150722172702.GE26909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150722172702.GE26909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 22, 2015 at 11:27:02AM -0600, Jason Gunthorpe wrote:
> What is SRP trying to accomplish with that?
> 
> The only reason that springs to mind is to emulate IB_MR_MAP_ARB_SG ?

It's not emulating IB_MR_MAP_ARB_SG, it simply allows muliple memory
registrations per I/O request.  Be that to support gappy SGLs in a
generic way, or to allow larger I/O sizes than the HCA MR size.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
