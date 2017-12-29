From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next v2] iw_cxgb4: Change error/warn prints to
 pr_debug
Date: Fri, 29 Dec 2017 11:11:22 -0700
Message-ID: <20171229181122.GB12569@ziepe.ca>
References: <1514533274-23613-1-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514533274-23613-1-git-send-email-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 29, 2017 at 01:11:14PM +0530, Bharat Potnuri wrote:
> These prints not neccesarily mean error/warning, so changing them to
> debug.
> 
> changes since v1:
> - Revert the pr_fmt changes.
> - Few more prints changed from pr_warn() to pr_debug().

I applied this to for-next, please put the change log after the
diffstat in future patches, so we don't have to manually edit your
commit message.

> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>  drivers/infiniband/hw/cxgb4/cm.c | 17 ++++++++---------
>  drivers/infiniband/hw/cxgb4/ev.c |  2 +-
>  2 files changed, 9 insertions(+), 10 deletions(-)
>

*right here*

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
