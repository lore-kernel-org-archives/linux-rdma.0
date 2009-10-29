From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Thu, 29 Oct 2009 09:37:54 -0700
Message-ID: <4AE9C4E2.7090801@mellanox.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>	<4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>	<4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com>	<1255570760.13845.4.camel@obelisk.thedillows.org>	<4AD74C88.8030604@mellanox.com>	<1255634715.29829.9.camel@lap75545.ornl.gov>	<20091015213512.GW5191@obsidianresearch.com>	<4AE0E71E.20309@mellanox.com> <adavdhzs8iv.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavdhzs8iv.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > +	if (timer_pending(&target->qp_err_timer))
>  > +		del_timer_sync(&target->qp_err_timer);
>  > +
>  >  	spin_unlock_irq(target->scsi_host->host_lock);
>
> As was pointed out, I don't think you can do del_timer_sync while
> holding the lock, since the timer function takes the same lock.
>
>   

I don't think that it takes the same lock (ie. host_lock).; however, the 
problem is  kernel configured CONFIG_LOCKDEP, del_timer_sync()  call 
local_irq_save/restore() to acquire/release timer->lockdep_map

> But I don't know that just switching to del_timer without the sync works
> here ... without the sync then the timeout function could still run any
> time after the del_timer, even after everything gets freed.
>
>   
I will move del_timer_sync() of the host_lock. It's safe because we only 
setup the same timer when the target state is ALIVE, however, target 
state is already REMOVED when del_timer_sync() is called

> BTW the test of timer_pending isn't needed here... del_timer does the
> test internally anyway.
>
> I do agree it would be very good to improve the SRP error handling.  I
> have some concerns about the overall design here -- it seems that if we
> handle connection failure and allow a new connection to proceed while
> cleaning up asynchronously, then this opens the door to a lot of
> complexity, and I don't see that complexity handled in this patchset.
> For example, the new connection could fail too before the old one is
> done cleaning up, etc, etc and we end up with an arbitrarily large queue
> of things waiting to clean up.  Or maybe it really it is simpler than that.
>
>   
It's is complicated; however, it is not as complicated as you said.
There are two flows/places where we clean-up connection and create new 
one (ie. call srp_reconnect_target) in async event timer and scsi error 
handling srp_reset_host(); however, in srp_reset_host() the patch 3/4 
check for true condition of  timer_pending or qp_in_error or target 
state wrapped in host_lock then it won't call srp_reconnect_target(). It 
left one flow/place to clean up / create new connection.

We destroy cm connection/cq/qp and create new connection/cq/qp in the 
same flow/place; we also already clean up all scsi/srp resources 
associated with old connection before create new one; therefore, the 
only resources pended for clean up is cm/connection resources, qp/cq 
low-level resources. And I believe the lower IB stack does that well.

> I think the best way to move this forward would be to post another
> cleaned up version of your patch set.  Please try to reorganize things
> so each patch is reasonably self contained.  Of course your patchset is
> taking multiple steps to improve things.  But as much as possible,
> please try to avoid combining two things into a single patch, and
> conversely also try to avoid putting things into a patch that don't make
> sense without a later patch.
>
> Avoiding policy in the kernel as much as possible in terms of hard-coded
> timeouts etc is a good goal too.
>
> Also it would help to give each patch a separate descriptive subject,
> and put as much detail in the changelogs as you can.
>
> Thanks,
>   Roland
>   
I'll follow the instructions above, rework the patch set and resubmit

thanks,
-vu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
