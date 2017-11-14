From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 2/9] IB/isert: use implicit CQ allocation
Date: Tue, 14 Nov 2017 11:14:41 +0200
Message-ID: <e0428a24-a9b5-75f1-f514-ef6df6c5dd69@mellanox.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <20171108095742.25365-3-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-3-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

> @@ -535,13 +410,15 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
>   
>   	isert_set_nego_params(isert_conn, &event->param.conn);
>   
> -	ret = isert_conn_setup_qp(isert_conn, cma_id);
> -	if (ret)
> +	isert_conn->qp = isert_create_qp(isert_conn, cma_id);
> +	if (IS_ERR(isert_conn->qp)) {
> +		ret = PTR_ERR(isert_conn->qp);
>   		goto out_conn_dev;
> +	}
>   
>   	ret = isert_login_post_recv(isert_conn);
>   	if (ret)
> -		goto out_conn_dev;
> +		goto out_conn_qp;

This is a bug fix, right ?

>   
>   	ret = isert_rdma_accept(isert_conn);
>   	if (ret)
> @@ -553,6 +430,8 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
>   
>   	return 0;
>   
> +out_conn_qp:
> +	ib_destroy_qp(isert_conn->qp);

maybe use rdma_destroy_qp(isert_conn->cm_id) as we do in nvme/nvmet_rdma ?


Otherwise, Looks good

Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
