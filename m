From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP
 information
Date: Tue, 9 Jan 2018 13:09:17 -0700
Message-ID: <20180109200917.GF4518@ziepe.ca>
References: <20180102081832.5264-1-leon@kernel.org>
 <20180102081832.5264-8-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180102081832.5264-8-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 02, 2018 at 10:18:32AM +0200, Leon Romanovsky wrote:

> +	/* PID == 0 means that this QP was created by kernel */
> +	if (qp->res.pid && nla_put_u32(msg,
> +				       RDMA_NLDEV_ATTR_RES_PID, qp->res.pid))

This is returning a pid in the init name space, obtained here:

+		res->pid = task_pid_nr(current);

And since the netlink user is not running in the init name space this
will return the wrong pid #, and worse potentially pids the current
name space should not see.

This API also needs to filter the results and only return pids
visible, and translate the pids as well..

I also suspsect this needs to be a netlink array of pids for future,
as we have hope someday to have RDMA uobjects shared between multiple
processes?

> +	if (nla_put_string(msg,
> +			   RDMA_NLDEV_ATTR_RES_PID_COMM, qp->res.task_comm))
> +		goto err;

Feels odd to return the content of /proc/XX/comm in netlink?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
