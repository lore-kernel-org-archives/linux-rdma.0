From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Wed, 20 Dec 2017 03:12:23 +0800
Message-ID: <20171219191223.GA3139@dhcp-13-42.nay.redhat.com>
References: <20171214110241.4701-1-honli@redhat.com>
 <1513263572.2986.2.camel@wdc.com>
 <20171215013628.GA743@dhcp-13-42.nay.redhat.com>
 <20171215172800.GA12434@ziepe.ca>
 <20171219122050.GA19682@dhcp-13-42.nay.redhat.com>
 <1513702653.2535.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1513702653.2535.3.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 04:57:35PM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-19 at 20:20 +0800, Honggang LI wrote:
> > As ibsrpdm always only run once, because "config->once" has been
> > assigned to 1. I would suggest to apply this patch.
> > 
> > diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> > index cec36db2..4012a7db 100644
> > --- a/srp_daemon/srp_daemon.c
> > +++ b/srp_daemon/srp_daemon.c
> > @@ -1945,12 +1945,12 @@ static struct resources *alloc_res(void)
> >  				     run_thread_get_trap_notices, &res->res);
> >  		if (ret)
> >  			goto err;
> > -	}
> >  
> > -	ret = pthread_create(&res->res.async_ev_thread, NULL,
> > -			     run_thread_listen_to_events, &res->res);
> > -	if (ret)
> > -		goto err;
> > +		ret = pthread_create(&res->res.async_ev_thread, NULL,
> > +				     run_thread_listen_to_events, &res->res);
> > +		if (ret)
> > +			goto err;
> > +	}
> >  
> >  	if (config->retry_timeout && !config->once) {
> >  		ret = pthread_create(&res->res.reconnect_thread, NULL,
> 
> Please submit this as a proper patch and add the following:

[rdma-core PATCH] srp_daemon: Don't create async_ev_thread if only run once

I sent the patch with that $SUBJECT.

thanks
> Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> 
> Thanks,
> 
> Bart.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
