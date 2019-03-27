From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] infiniband: i40iw: fix potential NULL pointer
 dereferences
Date: Wed, 27 Mar 2019 10:20:03 -0300
Message-ID: <20190327132003.GA12891@ziepe.ca>
References: <9DD61F30A802C4429A01CA4200E302A7A5A6FAA8@fmsmsx124.amr.corp.intel.com>
 <20190315065715.18249-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190315065715.18249-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 15, 2019 at 01:57:14AM -0500, Kangjie Lu wrote:
> alloc_ordered_workqueue may fail and return NULL.
> The fix captures the failure and handles it properly to avoid
> potential NULL pointer dereferences.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
> V2: add return value to capture the error code
> ---
>  drivers/infiniband/hw/i40iw/i40iw.h      |  2 +-
>  drivers/infiniband/hw/i40iw/i40iw_cm.c   | 19 ++++++++++++++++---
>  drivers/infiniband/hw/i40iw/i40iw_main.c |  5 ++++-
>  3 files changed, 21 insertions(+), 5 deletions(-)

applied to for-next thanks
 
> diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
> index 2f2b4426ded7..8feec35f95a7 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw.h
> @@ -552,7 +552,7 @@ enum i40iw_status_code i40iw_obj_aligned_mem(struct i40iw_device *iwdev,
>  
>  void i40iw_request_reset(struct i40iw_device *iwdev);
>  void i40iw_destroy_rdma_device(struct i40iw_ib_device *iwibdev);
> -void i40iw_setup_cm_core(struct i40iw_device *iwdev);
> +int i40iw_setup_cm_core(struct i40iw_device *iwdev);
>  void i40iw_cleanup_cm_core(struct i40iw_cm_core *cm_core);
>  void i40iw_process_ceq(struct i40iw_device *, struct i40iw_ceq *iwceq);
>  void i40iw_process_aeq(struct i40iw_device *);
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> index 206cfb0016f8..2e20786b9a57 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -3237,7 +3237,7 @@ void i40iw_receive_ilq(struct i40iw_sc_vsi *vsi, struct i40iw_puda_buf *rbuf)
>   * core
>   * @iwdev: iwarp device structure
>   */
> -void i40iw_setup_cm_core(struct i40iw_device *iwdev)
> +int i40iw_setup_cm_core(struct i40iw_device *iwdev)
>  {
>  	struct i40iw_cm_core *cm_core = &iwdev->cm_core;
>  
> @@ -3256,9 +3256,20 @@ void i40iw_setup_cm_core(struct i40iw_device *iwdev)
>  
>  	cm_core->event_wq = alloc_ordered_workqueue("iwewq",
>  						    WQ_MEM_RECLAIM);
> +	if (!cm_core->event_wq)
> +		goto error;
>  
>  	cm_core->disconn_wq = alloc_ordered_workqueue("iwdwq",
>  						      WQ_MEM_RECLAIM);
> +	if (!cm_core->disconn_wq)
> +		goto error;
> +
> +	return 0;
> +error:
> +	i40iw_cleanup_cm_core(&iwdev->cm_core);
> +	i40iw_pr_err("fail to setup CM core");

But I deleted this print, memory allocation failures already print
enough

Jason
