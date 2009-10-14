From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Wed, 14 Oct 2009 13:37:21 -0700
Message-ID: <4AD63681.6080901@mellanox.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada1vl5alqh.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > +static int srp_dev_loss_tmo = 60;
>
> I don't think the name needs to be this abbreviated.  We don't
> necessarily need the srp_ prefix, but probably "device_loss_timeout" is
> much clearer without being too much longer.
>
>   
OK
>  > +
>  > +module_param(srp_dev_loss_tmo, int, 0444);
>  > +MODULE_PARM_DESC(srp_dev_loss_tmo,
>  > +		 "Default number of seconds that srp transport should \
>  > +		  insulate the lost of a remote port (default is 60 secs");
>
> I can't understand this description.  What does "insulate the lost" of a
> port mean?
>
>   
I should change "remote port" to just "port". It means that multipath 
driver won't know about  port offline event (pulling cable, power 
cycling switch, target...) and won't act/fail-over because srp won't 
return error code until this timeout expired
>  > +static void srp_reconnect_work(struct work_struct *work)
>  > +{
>  > +	struct srp_target_port *target =
>  > +		container_of(work, struct srp_target_port, work);
>  > +
>  > +	srp_reconnect_target(target);
>  > +	target->work_in_progress = 0;
>
> surely this is racy... isn't it possible for a context to see
> work_in_progress as 1, decide not to schedule the work, and then have it
> set to 0 immediately afterwards by the workqueue context?
>   
Yes, it is racy. It should be in lock_irq scsi host_lock
>  > +		target->qp_err_timer.expires = time * HZ + jiffies;
>
> given that this is only with 1 second resolution, probably makes sense
> to either make it a deferrable timer or round the timeout to avoid extra
> wakeups.
>   
OK - I'll round the timeout.
>  > +		add_timer(&target->qp_err_timer);
>
> I don't see anywhere that this is canceled on module unload etc?
>
>   
My mistake. Bart also pointed it out. I'll fix this.
>  > +				srp_qp_err_add_timer(target,
>  > +						     srp_dev_loss_tmo - 55);
>
>  > +	if (srp_dev_loss_tmo < 60)
>  > +		srp_dev_loss_tmo = 60;
>
> I don't understand the 55 and the 60 here... what are these magic
> numbers?  Wouldn't it make sense for the user to specify the actual
> timeout that is used (value - 55) rather than the value and then
> secretly subtracting 55?
>
>  - R.
>   

First it does not make sense for user to set it below 60; therefore, it 
is forced to have 60 and above

With async event handler, srp can detect local port offline and set 
timer exact device_loss_timeout; however, it does not have mechanism to 
detect remote port offline (srp_daemon need to register trap and 
communicate remote port in/out fabric down to srp driver)
I should just add timer (X seconds) instead of (device_loss_tmo - 55) in 
case receiving cqe error and/or connection close event

-vu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
