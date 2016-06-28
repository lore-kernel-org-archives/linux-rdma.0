From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/isert: Limit the number of SG elements per work
	request
Date: Tue, 28 Jun 2016 17:46:18 +0200
Message-ID: <20160628154618.GB2843@lst.de>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com> <885f39a6-9d75-9999-d582-e403f072bec1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <885f39a6-9d75-9999-d582-e403f072bec1-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  	attr.cap.max_send_sge = device->ib_device->attrs.max_sge;
> -	isert_conn->max_sge = min(device->ib_device->attrs.max_sge,
> -				  device->ib_device->attrs.max_sge_rd);
>  	attr.cap.max_recv_sge = 1;
>  	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
>  	attr.qp_type = IB_QPT_RC;
> @@ -151,6 +149,9 @@ isert_create_qp(struct isert_conn *isert_conn,
>  		return ERR_PTR(ret);
>  	}
>  
> +	isert_conn->max_send_sge = attr.cap.max_send_sge;
> +	isert_conn->max_recv_sge = attr.cap.max_recv_sge;

Can you explain how cap.max_recv_sge fits in here?  My understanding
is that it is about the number of SGEs for a receive WR...

> @@ -2087,12 +2087,12 @@ isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
>  		addr = cmd->write_va;
>  		rkey = cmd->write_stag;
>  		offset = cmd->iscsi_cmd->write_data_done;
> -		max_sge = dev->attrs.max_sge_rd;
> +		max_sge = conn->max_recv_sge;

.. and not about the number of SGEs for a RDMA READ WR.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
