From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-4.3 11/15] iw_cxgb4: Support ib_alloc_mr verb
Date: Fri, 7 Aug 2015 08:13:18 -0700
Message-ID: <20150807151318.GA13777@infradead.org>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
 <1438241568-3685-12-git-send-email-sagig@mellanox.com>
 <003301d0d122$a1e46ee0$e5ad4ca0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <003301d0d122$a1e46ee0$e5ad4ca0$@opengridcomputing.com>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 07, 2015 at 10:06:26AM -0500, Steve Wise wrote:
> If it is too much of a pain to alter this patch, then I'll just
> submit the NFSRDMA fix and live with the bisect issue...

Doug's tree is still to be rebased.  So please submit your NFS
fix now as ask Doug to merge it before Sagi's series in the final
tree.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
