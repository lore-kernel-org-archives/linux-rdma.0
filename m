From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: IB/srp: Fix deadlock between host removal and multipathd
Date: Wed, 06 Aug 2014 10:28:50 +0200
Message-ID: <53E1E742.8030805@acm.org>
References: <20140804233140.GA9106@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140804233140.GA9106@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/05/14 01:31, Dan Carpenter wrote:
> The patch bcc059103591: "IB/srp: Fix deadlock between host removal
> and multipathd" from Jul 9, 2014, leads to the following static
> checker warning:
> 
> 	drivers/infiniband/ulp/srp/ib_srp.c:3323 srp_init_module()
> 	warn: 'srp_remove_wq' isn't an ERR_PTR
> 
> drivers/infiniband/ulp/srp/ib_srp.c
>   3321  
>   3322          srp_remove_wq = create_workqueue("srp_remove");
> 
> Returns NULL on failure and not an ERR_PTR.
> 
>   3323          if (IS_ERR(srp_remove_wq)) {
>   3324                  ret = PTR_ERR(srp_remove_wq);
>   3325                  goto out;
>   3326          }
>   3327  
>   3328          ret = -ENOMEM;
>   3329          ib_srp_transport_template =
>   3330                  srp_attach_transport(&ib_srp_transport_functions);
>   3331          if (!ib_srp_transport_template)
>   3332                  goto destroy_wq;

Hello Dan,

Thanks for reporting this. I will post a fix later this month.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
