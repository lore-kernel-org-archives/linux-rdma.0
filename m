From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband: i40iw: fix potential NULL pointer
 dereferences
Date: Tue, 12 Mar 2019 12:01:12 -0300
Message-ID: <20190312150112.GA29101@ziepe.ca>
References: <20190309052750.16139-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190309052750.16139-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 08, 2019 at 11:27:50PM -0600, Kangjie Lu wrote:
> alloc_ordered_workqueue may fail and return NULL. Let's check
> its return value to ensure it is not NULL so as to avoid
> potential NULL pointer dereferences.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> index 206cfb0016f8..ad9b4f235e30 100644
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -3256,9 +3256,21 @@ void i40iw_setup_cm_core(struct i40iw_device *iwdev)
>  
>  	cm_core->event_wq = alloc_ordered_workqueue("iwewq",
>  						    WQ_MEM_RECLAIM);
> +	if (!cm_core->event_wq) {
> +		i40iw_debug(cm_core->dev,
> +				I40IW_DEBUG_CM,
> +				"%s allocate event work queue failed\n",
> +				__func__);
> +	}
>  
>  	cm_core->disconn_wq = alloc_ordered_workqueue("iwdwq",
>  						      WQ_MEM_RECLAIM);
> +	if (!cm_core->disconn_wq) {
> +		i40iw_debug(cm_core->dev,
> +				I40IW_DEBUG_CM,
> +				"%s allocate disconnect work queue failed\n",
> +				__func__);
> +	}
>  }

Same no as the mlx patches - handle the error or don't bother

Jason
