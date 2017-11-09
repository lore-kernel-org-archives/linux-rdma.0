From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: Fix possible circular dependency
 locking warning
Date: Thu, 9 Nov 2017 17:06:43 +0530
Message-ID: <20171109113642.GA4907@chelsio.com>
References: <1510226844-4165-1-git-send-email-chelsiocudbg@users.noreply.github.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510226844-4165-1-git-send-email-chelsiocudbg-KJX8L1YACloTKYOLMXNBRxrm3jAUxWOA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chelsio Cudbg <chelsiocudbg-YEAOTlfEoH4oZ4o0MQTwmEh/o/VBkw4H@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please ignore this.
I sent it with wrong user name.

On Thursday, November 11/09/17, 2017 at 16:57:24 +0530, Chelsio Cudbg wrote:
> From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> 
> Locking sequence of iw_cxgb4 and RoCE drivers in ib_register_device() is
> slightly different and this leads to possible circular dependency locking
> warning when both the devices are brought up.
> 
> Here is the locking sequence upto ib_register_device():
> iw_cxgb4: rtnl_mutex(net stack) --> uld_mutex --> device_mutex
> RoCE drivers: device_mutex --> rtnl_mutex
> 
> Here is the possibility of cross locking:
> 
> 	CPU #0 (iw_cxgb4) 		     CPU #1 (RoCE drivers)
> 
> -> on interface up cxgb4_up()
> executed with rtnl_mutex held
> -> hold uld_mutex and try
> registering ib device
> 					-> In ib_register_device() hold
> 					   device_mutex
> -> hold device mutex in
> ib_register_device
> 					-> try acquiring rtnl_mutex in
> 					   ib_enum_roce_netdev()
> 
> Current patch schedules the ib_register_device() functionality of
> iw_cxgb4 to a workqueue to prevent the possible cross-locking.
> Also rename the labels in c4iw_reister_device().
> 
> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/device.c   | 28 +++++++++++++---------------
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h | 10 +++++++++-
>  drivers/infiniband/hw/cxgb4/provider.c | 26 +++++++++++++++++---------
>  3 files changed, 39 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 33bfddf3b064..af77d128d242 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -64,14 +64,9 @@ module_param(c4iw_wr_log_size_order, int, 0444);
>  MODULE_PARM_DESC(c4iw_wr_log_size_order,
>  		 "Number of entries (log2) in the work request timing log.");
>  
> -struct uld_ctx {
> -	struct list_head entry;
> -	struct cxgb4_lld_info lldi;
> -	struct c4iw_dev *dev;
> -};
> -
>  static LIST_HEAD(uld_ctx_list);
>  static DEFINE_MUTEX(dev_mutex);
> +struct workqueue_struct *reg_workq;
>  
>  #define DB_FC_RESUME_SIZE 64
>  #define DB_FC_RESUME_DELAY 1
> @@ -912,7 +907,7 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
>  	c4iw_destroy_resource(&rdev->resource);
>  }
>  
> -static void c4iw_dealloc(struct uld_ctx *ctx)
> +void c4iw_dealloc(struct uld_ctx *ctx)
>  {
>  	c4iw_rdev_close(&ctx->dev->rdev);
>  	WARN_ON_ONCE(!idr_is_empty(&ctx->dev->cqidr));
> @@ -1208,8 +1203,6 @@ static int c4iw_uld_state_change(void *handle, enum cxgb4_state new_state)
>  	case CXGB4_STATE_UP:
>  		pr_info("%s: Up\n", pci_name(ctx->lldi.pdev));
>  		if (!ctx->dev) {
> -			int ret;
> -
>  			ctx->dev = c4iw_alloc(&ctx->lldi);
>  			if (IS_ERR(ctx->dev)) {
>  				pr_err("%s: initialization failed: %ld\n",
> @@ -1218,12 +1211,9 @@ static int c4iw_uld_state_change(void *handle, enum cxgb4_state new_state)
>  				ctx->dev = NULL;
>  				break;
>  			}
> -			ret = c4iw_register_device(ctx->dev);
> -			if (ret) {
> -				pr_err("%s: RDMA registration failed: %d\n",
> -				       pci_name(ctx->lldi.pdev), ret);
> -				c4iw_dealloc(ctx);
> -			}
> +
> +			INIT_WORK(&ctx->reg_work, c4iw_register_device);
> +			queue_work(reg_workq, &ctx->reg_work);
>  		}
>  		break;
>  	case CXGB4_STATE_DOWN:
> @@ -1551,6 +1541,12 @@ static int __init c4iw_init_module(void)
>  	if (!c4iw_debugfs_root)
>  		pr_warn("could not create debugfs entry, continuing\n");
>  
> +	reg_workq = create_singlethread_workqueue("Register_iWARP_device");
> +	if (!reg_workq) {
> +		pr_err("Failed creating workqueue to register iwarp device\n");
> +		return -ENOMEM;
> +	}
> +
>  	cxgb4_register_uld(CXGB4_ULD_RDMA, &c4iw_uld_info);
>  
>  	return 0;
> @@ -1567,6 +1563,8 @@ static void __exit c4iw_exit_module(void)
>  		kfree(ctx);
>  	}
>  	mutex_unlock(&dev_mutex);
> +	flush_workqueue(reg_workq);
> +	destroy_workqueue(reg_workq);
>  	cxgb4_unregister_uld(CXGB4_ULD_RDMA);
>  	c4iw_cm_term();
>  	debugfs_remove_recursive(c4iw_debugfs_root);
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index 788ddb6aa57b..42500cbb9669 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -322,6 +322,13 @@ struct c4iw_dev {
>  	wait_queue_head_t wait;
>  };
>  
> +struct uld_ctx {
> +	struct list_head entry;
> +	struct cxgb4_lld_info lldi;
> +	struct c4iw_dev *dev;
> +	struct work_struct reg_work;
> +};
> +
>  static inline struct c4iw_dev *to_c4iw_dev(struct ib_device *ibdev)
>  {
>  	return container_of(ibdev, struct c4iw_dev, ibdev);
> @@ -989,7 +996,7 @@ void c4iw_rqtpool_destroy(struct c4iw_rdev *rdev);
>  void c4iw_ocqp_pool_destroy(struct c4iw_rdev *rdev);
>  void c4iw_destroy_resource(struct c4iw_resource *rscp);
>  int c4iw_destroy_ctrl_qp(struct c4iw_rdev *rdev);
> -int c4iw_register_device(struct c4iw_dev *dev);
> +void c4iw_register_device(struct work_struct *work);
>  void c4iw_unregister_device(struct c4iw_dev *dev);
>  int __init c4iw_cm_init(void);
>  void c4iw_cm_term(void);
> @@ -1015,6 +1022,7 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
>  int c4iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
>  		   unsigned int *sg_offset);
>  int c4iw_dealloc_mw(struct ib_mw *mw);
> +void c4iw_dealloc(struct uld_ctx *ctx);
>  struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
>  			    struct ib_udata *udata);
>  struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
> index fb99a05562a3..575875a7e7f8 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -530,10 +530,12 @@ static void get_dev_fw_str(struct ib_device *dev, char *str)
>  		 FW_HDR_FW_VER_BUILD_G(c4iw_dev->rdev.lldi.fw_vers));
>  }
>  
> -int c4iw_register_device(struct c4iw_dev *dev)
> +void c4iw_register_device(struct work_struct *work)
>  {
>  	int ret;
>  	int i;
> +	struct uld_ctx *ctx = container_of(work, struct uld_ctx, reg_work);
> +	struct c4iw_dev *dev = ctx->dev;
>  
>  	pr_debug("c4iw_dev %p\n", dev);
>  	BUG_ON(!dev->rdev.lldi.ports[0]);
> @@ -609,8 +611,10 @@ int c4iw_register_device(struct c4iw_dev *dev)
>  	dev->ibdev.get_dev_fw_str = get_dev_fw_str;
>  
>  	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
> -	if (!dev->ibdev.iwcm)
> -		return -ENOMEM;
> +	if (!dev->ibdev.iwcm) {
> +		ret = -ENOMEM;
> +		goto err_dealloc_ctx;
> +	}
>  
>  	dev->ibdev.iwcm->connect = c4iw_connect;
>  	dev->ibdev.iwcm->accept = c4iw_accept_cr;
> @@ -625,20 +629,24 @@ int c4iw_register_device(struct c4iw_dev *dev)
>  
>  	ret = ib_register_device(&dev->ibdev, NULL);
>  	if (ret)
> -		goto bail1;
> +		goto err_unregister_device;
>  
>  	for (i = 0; i < ARRAY_SIZE(c4iw_class_attributes); ++i) {
>  		ret = device_create_file(&dev->ibdev.dev,
>  					 c4iw_class_attributes[i]);
>  		if (ret)
> -			goto bail2;
> +			goto err_kfree_iwcm;
>  	}
> -	return 0;
> -bail2:
> +	return;
> +err_kfree_iwcm:
>  	ib_unregister_device(&dev->ibdev);
> -bail1:
> +err_unregister_device:
>  	kfree(dev->ibdev.iwcm);
> -	return ret;
> +err_dealloc_ctx:
> +	pr_err("%s - Failed registering iwarp device: %d\n",
> +	       pci_name(ctx->lldi.pdev), ret);
> +	c4iw_dealloc(ctx);
> +	return;
>  }
>  
>  void c4iw_unregister_device(struct c4iw_dev *dev)
> -- 
> 2.5.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
