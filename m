From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v8 2/4] IB/core: Add rdma netlink helper functions
Date: Mon, 3 Aug 2015 21:15:34 -0600
Message-ID: <20150804031534.GA28707@obsidianresearch.com>
References: <1436463268-32365-1-git-send-email-kaike.wan@intel.com>
 <1436463268-32365-3-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1436463268-32365-3-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 09, 2015 at 01:34:26PM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This patch adds a function to check if listeners for a netlink multicast
> group are present. It also adds a function to receive netlink response
> messages.
> 
> Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  drivers/infiniband/core/netlink.c |   55 +++++++++++++++++++++++++++++++++++++
>  include/rdma/rdma_netlink.h       |    7 +++++
>  2 files changed, 62 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> index 23dd5a5..d47df93 100644
> +++ b/drivers/infiniband/core/netlink.c
> @@ -49,6 +49,14 @@ static DEFINE_MUTEX(ibnl_mutex);
>  static struct sock *nls;
>  static LIST_HEAD(client_list);
>  
> +int ibnl_chk_listeners(unsigned int group)
> +{
> +	if (netlink_has_listeners(nls, group) == 0)
> +		return -1;
> +	return 0;
> +}
> +EXPORT_SYMBOL(ibnl_chk_listeners);

I was thinking about this today, and, where is the security?

What prevents a non-root user from making the above true and/or worse?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
