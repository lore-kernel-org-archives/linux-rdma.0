From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 12/22] IB/iser: Introduce iser_reg_ops
Date: Thu, 30 Jul 2015 11:32:49 -0600
Message-ID: <20150730173249.GD25282@obsidianresearch.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
 <1438243595-32288-13-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438243595-32288-13-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 11:06:25AM +0300, Sagi Grimberg wrote:

>  /**
> + * struct iser_device - Memory registration operations
> + *     per-device registration schemes
> + *
> + * @alloc_reg_res:     Allocate registration resources
> + * @free_reg_res:      Free registration resources
> + * @reg_rdma_mem:      Register memory buffers
> + * @unreg_rdma_mem:    Un-register memory buffers
> + */
> +struct iser_reg_ops {
> +	int            (*alloc_reg_res)(struct ib_conn *ib_conn,
> +					unsigned cmds_max);
> +	void           (*free_reg_res)(struct ib_conn *ib_conn);
> +	int            (*reg_rdma_mem)(struct iscsi_iser_task *iser_task,
> +				       enum iser_data_dir cmd_dir);
> +	void           (*unreg_rdma_mem)(struct iscsi_iser_task *iser_task,
> +					 enum iser_data_dir cmd_dir);
> +};

It sucks we need every ULP to have function pointer swap outs just to
support MRs.. NFS has the same...
>  
>  	if (iser_task->dir[ISER_DIR_IN]) {
> -		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_IN);
> +		device->reg_ops->unreg_rdma_mem(iser_task, ISER_DIR_IN);
>  		if (is_rdma_data_aligned)
>  			iser_dma_unmap_task_data(iser_task,
>  						 &iser_task->data[ISER_DIR_IN],

Is this the same wrong ordering that NFS had?

DMA unmap (and CPU access) for ACCESS_REMOTE_WRITE rkeys should happen
after invalidate completes, not before.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
