From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Mon, 15 Jan 2018 11:52:37 -0500
Message-ID: <1516035157.3900.4.camel@redhat.com>
References: <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
         <1515610750.10153.1.camel@redhat.com> <20180110191510.GK4518@ziepe.ca>
         <1515612639.10153.3.camel@redhat.com> <20180110205243.GP4776@mellanox.com>
         <1515618674.10153.6.camel@redhat.com> <20180110211501.GS4776@mellanox.com>
         <1515675741.21421.1.camel@redhat.com> <1515703435.21421.9.camel@redhat.com>
         <1515705340.2752.60.camel@wdc.com> <1515706433.21421.11.camel@redhat.com>
         <1515791472.2396.57.camel@wdc.com> <1515802177.1566.1.camel@redhat.com>
         <1515808673.11354.1.camel@redhat.com> <1515855226.32050.1.camel@redhat.com>
         <1516032762.3951.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516032762.3951.5.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2018-01-15 at 16:12 +0000, Bart Van Assche wrote:
> On Sat, 2018-01-13 at 09:53 -0500, Laurence Oberman wrote:
> > [  239.502025] ib_srpt Received SRP_LOGIN_REQ with i_port_id
> > 7cfe:9003:0072:6e4f:7cfe:9003:0072:6ed3, t_port_id
> > 7cfe:9003:0072:6e4e:7cfe:9003:0072:6e4e and it_iu_len 2116 on port
> > 1
> > (guid=fe80:0000:0000:0000:7cfe:9003:0072:6e4f); pkey 0xffff
> > [  239.623881] ib_srpt failed to create queue pair with sq_size =
> > 16384
> > (-12) - retrying
> > [  239.669381] ib_srpt failed to create queue pair with sq_size =
> > 8192
> > (-12) - retrying
> > [  239.715366] ib_srpt Received SRP_LOGIN_REQ with i_port_id
> > 7cfe:9003:0072:6e4e:7cfe:9003:0072:6ed2, t_port_id
> > 7cfe:9003:0072:6e4e:7cfe:9003:0072:6e4e and it_iu_len 2116 on port
> > 1
> > (guid=fe80:0000:0000:0000:7cfe:9003:0072:6e4e); pkey 0xffff
> > [  239.831661] ib_srpt failed to create queue pair with sq_size =
> > 16384
> > (-12) - retrying
> > [  239.877193] ib_srpt failed to create queue pair with sq_size =
> > 8192
> > (-12) - retrying
> 
> Hello Laurence,
> 
> These messages are expected and do not indicate a failure. The retry
> loop
> the above messages refer to got introduced a long time ago:
> 
> commit ab477c1ff5e0a744c072404bf7db51bfe1f05b6e
> Author: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Date:   Sun Oct 19 18:05:33 2014 +0300
> 
>     srp-target: Retry when QP creation fails with ENOMEM
>     
>     It is not guaranteed to that srp_sq_size is supported
>     by the HCA. So if we failed to create the QP with ENOMEM,
>     try with a smaller srp_sq_size. Keep it up until we hit
>     MIN_SRPT_SQ_SIZE, then fail the connection.
>     
> [ ... ]
> 
> The only recent change in that code is that retry attempts are now
> logged.
> From commit 0e9949f1db6c "IB/srpt: Add RDMA/CM support":
> 
> +       if (ret) {
> +               bool retry = sq_size > MIN_SRPT_SQ_SIZE;
> +
> +               pr_err("failed to create queue pair with sq_size = %d
> (%d)%s\n",
> +                      sq_size, ret, retry ? " - retrying" : "");
> +               if (retry) {
> +                       ib_free_cq(ch->cq);
> +                       sq_size = max(sq_size / 2, MIN_SRPT_SQ_SIZE);
> +                       goto retry;
> +               } else {
> +                       goto err_destroy_cq;
>                 }
> -               pr_err("failed to create_qp ret= %d\n", ret);
> -               goto err_destroy_cq;
>         }
> 
> Do you perhaps want that pr_err() to be changed into a pr_debug() for
> retry
> attempts?
> 
> Thanks,
> 
> Bart.

Hi Bart, 

I recognized those as maybe just reporting messages so I thought we
were were good with the recent patch to fix the connection issue.
However when I attempted to actually use the targets with your latest
SRPT I had failures on the client.

It was a tough weekend for me, and maybe I made mistakes.
Let me complete the irq/cpu test Ming is waiting for and I will revisit
this fully with a clean build and your most recent patch.

I will answer off list while we figure it out

Many Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
