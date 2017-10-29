From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add remote_invalidation module parameter
Date: Sun, 29 Oct 2017 11:52:37 -0600
Message-ID: <20171029175237.GD4488@ziepe.ca>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
 <1509295101-14081-3-git-send-email-idanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1509295101-14081-3-git-send-email-idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 29, 2017 at 06:38:21PM +0200, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org wrote:
  
> +static bool remote_invalidation = true;
> +module_param(remote_invalidation, bool, 0444);
> +MODULE_PARM_DESC(remote_invalidation,
> +	 "request remote invalidation from subsystem (default: true)");

Please no module options.

If your device has a performance anomaly that makes
SEND_WITH_INVALIDATE slower than local invalidation, then we need to
talk about having a new verbs flag for this situation so all the ULPs
can avoid using SEND_WITH_INVALIDATE..

Sagi, is this really an apples to apples comparison?

When I was talking with Chuck on NFS there were some various issues on
that side that made the local invalidate run faster, but it wasn't
actually working properly.

Does nvme wait for the local invalidate to finish before moving on?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
