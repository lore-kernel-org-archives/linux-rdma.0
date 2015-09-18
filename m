From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH] infiniband:core:Fix error handling in the function
 cm_lap_handler
Date: Fri, 18 Sep 2015 16:16:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A903C417@ORSMSX109.amr.corp.intel.com>
References: <1442543974-7206-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442543974-7206-1-git-send-email-xerofoify@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "haggaie@mellanox.com" <haggaie@mellanox.com>, "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "Weiny, Ira" <ira.weiny@intel.com>, "yun.wang@profitbricks.com" <yun.wang@profitbricks.com>, "erezsh@mellanox.com" <erezsh@mellanox.com>, "ted.h.kim@oracle.com" <ted.h.kim@oracle.com>, "david.ahern@oracle.com" <david.ahern@oracle.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index ea4db9c..8fab3a7 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -2812,7 +2812,12 @@ static int cm_lap_handler(struct cm_work *work)
>  	cm_init_av_for_response(work->port, work->mad_recv_wc->wc,
>  				work->mad_recv_wc->recv_buf.grh,
>  				&cm_id_priv->av);
> -	cm_init_av_by_path(param->alternate_path, &cm_id_priv->alt_av);
> +	ret = cm_init_av_by_path(param->alternate_path, &cm_id_priv-
> >alt_av);
> +	if (ret) {
> +		spin_unlock_irq(&cm_id_priv->lock);
> +		cm_deref_id(cm_id_priv);
> +	}

How can this be right?  On a failure, we release the spinlock and the reference on the cm_id, then continue on with the processing?

> +
>  	ret = atomic_inc_and_test(&cm_id_priv->work_count);
>  	if (!ret)
>  		list_add_tail(&work->list, &cm_id_priv->work_list);
> --
> 2.1.4
