From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add a value assignment to avoid sleep-in-atomic
 bug caused by uninitialized value
Date: Fri, 2 Jun 2017 16:17:54 -0500
Message-ID: <20170602211754.GA29936@ssaleem-MOBL4.amr.corp.intel.com>
References: <1496283076-6915-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496283076-6915-1-git-send-email-baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Cc: faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 01, 2017 at 10:11:16AM +0800, Jia-Ju Bai wrote:
> The value "cqp_request->waiting" indicates whether the sleeping operation 
> should be performed, and it is not assigned in i40iw_get_cqp_request, so 
> the driver may sleep in interrupt handling. The function call path is:
> 
> i40iw_dpc (tasklet_init indicates it handles interrupt)
>   i40iw_process_aeq
>     i40iw_next_iw_state
>       i40iw_hw_modify_qp (call i40iw_get_cqp_request)
>         i40iw_handle_cqp_op
>           i40iw_wait_event --> may sleep
> 
> To fix it, "cqp_request->waiting" is assigned in "else" branch in
> i40iw_get_cqp_request.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_utils.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
> index 409a378..0f4e633 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
> @@ -326,6 +326,7 @@ struct i40iw_cqp_request *i40iw_get_cqp_request(struct i40iw_cqp *cqp, bool wait
>  		cqp_request->waiting = true;
>  	} else {
>  		atomic_set(&cqp_request->refcount, 1);
> +		cqp_request->waiting = false;
>  	}
>  	return cqp_request;
>  }
> --

Hi Jia - cqp_request->waiting is always initialized. If cqp_request object is 
allocated using kzalloc, it is initialized to 0. For those cqp_request object that are
retrieved from the cqp list 'cqp->cqp_avail_reqs', the waiting flag is set to false
when it is put back on the list via i40iw_free_cqp_request. So there should be no issue
here.

Shiraz
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
