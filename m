From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V3 1/8] IB/core: Change provider's API of
 create_cq to be extendible
Date: Thu, 11 Jun 2015 11:55:55 -0600
Message-ID: <20150611175555.GB20142@obsidianresearch.com>
References: <1434029727-6062-1-git-send-email-ogerlitz@mellanox.com>
 <1434029727-6062-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434029727-6062-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 04:35:20PM +0300, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add a new ib_cq_init_attr structure which contains the
> previous cqe (minimum number of CQ entries) and comp_vector
> (completion vector) in addition to a new flags field.
> All vendors' create_cq callbacks are changed in order
> to work with the new API.
> 
> This commit does not change any functionality.
> 
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

You need to collect any Reviwed-By's etc people provide to earlier
series, and include them when spining a new revision.  For instance

http://permalink.gmane.org/gmane.linux.drivers.rdma/26129

I think I had provided a Reviewed-By for some of these patches too.

It isn't reasonable to expect Doug to do that.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
