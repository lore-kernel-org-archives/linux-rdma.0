From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Mon, 15 May 2017 11:46:46 -0600
Message-ID: <20170515174646.GC6229@obsidianresearch.com>
References: <20170515145203.10708.16921.stgit@klimt.1015granger.net>
 <20170515145757.GI3616@mtr-leonro.local>
 <02AFF424-A387-47F7-BD24-61C7734B9008@oracle.com>
 <20170515170021.GJ3616@mtr-leonro.local>
 <AE3152CC-B7C8-4C51-ADDE-C3822533BB94@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AE3152CC-B7C8-4C51-ADDE-C3822533BB94-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 15, 2017 at 01:22:59PM -0400, Chuck Lever wrote:

> I find the feature useful. But it is correct to say that such
> development knobs are often left to kernel compile-time, as
> it is not especially useful to end users.

Put it in debugfs?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
