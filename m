From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH rdma-next] IB/iser: Fix connection teardown race condition
Date: Thu, 25 May 2017 18:24:59 +0300
Message-ID: <98334f53-a7ff-d465-989f-a5ee7add2291@mellanox.com>
References: <20170521161731.22223-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170521161731.22223-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Vladimir Neyelov <vladimirn@mellanox.com>, stable@vger.kernel.org, sagig <sagi@grimberg.me>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

what do you think on this approach ?
we must somehow defend on the NULL deref in case dd_data in iscsi_conn 
(the iser_conn) already NULL due to conn_stop call.


>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 5a887efb4bdf..9ba649836d86 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -83,6 +83,7 @@ static struct scsi_host_template iscsi_iser_sht;
>  static struct iscsi_transport iscsi_iser_transport;
>  static struct scsi_transport_template *iscsi_iser_scsi_transport;
>  static struct workqueue_struct *release_wq;
> +static DEFINE_MUTEX(unbind_iser_conn_mutex);
>  struct iser_global ig;
>
>  int iser_debug_level = 0;
> @@ -550,12 +551,14 @@ iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
>  	 */
>  	if (iser_conn) {
>  		mutex_lock(&iser_conn->state_mutex);
> +		mutex_lock(&unbind_iser_conn_mutex);
>  		iser_conn_terminate(iser_conn);
>  		iscsi_conn_stop(cls_conn, flag);
>
>  		/* unbind */
>  		iser_conn->iscsi_conn = NULL;
>  		conn->dd_data = NULL;
> +		mutex_unlock(&unbind_iser_conn_mutex);
>
>  		complete(&iser_conn->stop_completion);
>  		mutex_unlock(&iser_conn->state_mutex);
> @@ -977,13 +980,21 @@ static int iscsi_iser_slave_alloc(struct scsi_device *sdev)
>  	struct iser_conn *iser_conn;
>  	struct ib_device *ib_dev;
>
> +	mutex_lock(&unbind_iser_conn_mutex);
> +
>  	session = starget_to_session(scsi_target(sdev))->dd_data;
>  	iser_conn = session->leadconn->dd_data;
> +	if (!iser_conn) {
> +		mutex_unlock(&unbind_iser_conn_mutex);
> +		return -ENOTCONN;
> +	}
>  	ib_dev = iser_conn->ib_conn.device->ib_device;
>
>  	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
>  		blk_queue_virt_boundary(sdev->request_queue, ~MASK_4K);
>
> +	mutex_unlock(&unbind_iser_conn_mutex);
> +
>  	return 0;
>  }
>
> --
> 2.12.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
