From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/6] libqedr: main
Date: Thu, 20 Oct 2016 11:08:28 -0600
Message-ID: <20161020170828.GC28181@obsidianresearch.com>
References: <1476956952-17388-1-git-send-email-Ram.Amrani@cavium.com>
 <1476956952-17388-5-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476956952-17388-5-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 20, 2016 at 12:49:10PM +0300, Ram Amrani wrote:
> +struct {
> +	unsigned int vendor;
> +	unsigned int device;
> +} hca_table[] = {

needs static const, please check all your stuff for static and const..

> +int qelr_modify_qp(struct ibv_qp *, struct ibv_qp_attr *,
> +		   int ibv_qp_attr_mask);
> +int qelr_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask,
> +		  struct ibv_qp_init_attr *init_attr);

It would be nice to be consistent, I prefer the argument name to be in
the prototype.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
