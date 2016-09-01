From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/3] Add new call ibv_cmd_create_ah_ex which
 supports extra parameters
Date: Thu, 1 Sep 2016 11:36:43 -0600
Message-ID: <20160901173643.GC20472@obsidianresearch.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
 <1472713193-22397-2-git-send-email-knut.omang@oracle.com>
 <20160901164939.GD6479@obsidianresearch.com>
 <1472750558.9410.230.camel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472750558.9410.230.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 07:22:38PM +0200, Knut Omang wrote:

> Note that the best solution if we get a merged library repo would just be to 
> eliminate it by folding the arguments into ibv_cmd_create_ah and make it similar to
> the other *create* functions.

Well, we currently have a promise not to break the ABI facing the
providers.

So, we'd still have to use symbol versions when we change the cmd so
old providers link. Not sure how much win there is there vs _ex.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
