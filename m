From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] infiniband:core:Fix error handling in the function
 join_handler
Date: Tue, 8 Sep 2015 16:50:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A903955A@ORSMSX109.amr.corp.intel.com>
References: <1441593769-14864-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441593769-14864-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/multicast.c
> b/drivers/infiniband/core/multicast.c
> index 2cb865c..9284337 100644
> --- a/drivers/infiniband/core/multicast.c
> +++ b/drivers/infiniband/core/multicast.c
> @@ -526,8 +526,9 @@ static void join_handler(int status, struct
> ib_sa_mcmember_rec *rec,
>  		process_join_error(group, status);
>  	else {
>  		int mgids_changed, is_mgid0;
> -		ib_find_pkey(group->port->dev->device, group->port->port_num,
> -			     be16_to_cpu(rec->pkey), &pkey_index);
> +		if (ib_find_pkey(group->port->dev->device, group->port-
> >port_num,
> +				 be16_to_cpu(rec->pkey), &pkey_index))
> +			return;

We can't just abort here.  Apps are waiting on a callback to their join operation, and the SA believes that this port is part of the multicast group.

If we don't get a valid pkey, the group will be left set to 'MCAST_INVALID_PKEY_INDEX'. 

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
