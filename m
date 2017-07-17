From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [bug report] i40iw: add connection management code
Date: Mon, 17 Jul 2017 14:27:55 -0500
Message-ID: <20170717192755.GA16652@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170714113514.rfkbbktuvb5hfmkt@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170714113514.rfkbbktuvb5hfmkt@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 14, 2017 at 02:35:14PM +0300, Dan Carpenter wrote:
> Hello Faisal Latif,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch f27b4746f378: "i40iw: add connection management code" from
> Jan 20, 2016, leads to the following Smatch complaint:
> 
>     drivers/infiniband/hw/i40iw/i40iw_cm.c:3691 i40iw_accept()
>     error: we previously assumed 'cm_node->listener' could be null (see line 3689)
> 
>     drivers/infiniband/hw/i40iw/i40iw_cm.c:4061 i40iw_cm_event_connected()
>     error: we previously assumed 'cm_node->listener' could be null (see line 4059)
>
Dan - Thank you for reporting.

The NULL check at 3689 is incorrect as we will always have
a listener at this point in i40iw_accept. 

The code 4058-4063 also needs to be removed as we are in active node
context and cm_node->accept_pend is always 0.

We ll send a patch to fix this soon.

> 
> drivers/infiniband/hw/i40iw/i40iw_cm.c
>   3688		if (cm_node->accept_pend) {
>   3689			if (!cm_node->listener)
>                              ^^^^^^^^^^^^^^^^^
> Check
> 
>   3690				i40iw_pr_err("cm_node->listener NULL for passive node\n");
>   3691			atomic_dec(&cm_node->listener->pend_accepts_cnt);
>                                     ^^^^^^^^^^^^^^^^^
> Unchecked dereference
> 
>   3692			cm_node->accept_pend = 0;
>   3693		}
> 
> 	[ snip ]
> 
>   4058		if (cm_node->accept_pend) {
>   4059			if (!cm_node->listener)
>                              ^^^^^^^^^^^^^^^^^
>   4060				i40iw_pr_err("listener is null for passive node\n");
>   4061			atomic_dec(&cm_node->listener->pend_accepts_cnt);
>                                     ^^^^^^^^^^^^^^^^^
>   4062			cm_node->accept_pend = 0;
>   4063		}
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
