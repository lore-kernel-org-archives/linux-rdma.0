From: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-4.3 11/15] iw_cxgb4: Support ib_alloc_mr verb
Date: Fri, 7 Aug 2015 09:31:54 -0700
Message-ID: <20150807163154.GA1590@infradead.org>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
 <1438241568-3685-12-git-send-email-sagig@mellanox.com>
 <003301d0d122$a1e46ee0$e5ad4ca0$@opengridcomputing.com>
 <20150807151318.GA13777@infradead.org>
 <003a01d0d12c$e84b4e80$b8e1eb80$@opengridcomputing.com>
 <20150807162615.GA16851@infradead.org>
 <003c01d0d12e$31a879d0$94f96d70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <003c01d0d12e$31a879d0$94f96d70$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 07, 2015 at 11:29:12AM -0500, Steve Wise wrote:
> I misspoke.  I had the order reversed. The order is such that we can add my new NFS patch after:
> 
> e20684a xprtrdma, svcrdma: Convert to ib_alloc_mr
> 
> and before these:
> 
> af78181 cxgb3: Support ib_alloc_mr verb
> b7e06cd iw_cxgb4: Support ib_alloc_mr verb

In general it would be preferable to have it before the ib_alloc_mr
conversion, but if it causes more work I doubt it's really worth it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
