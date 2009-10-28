From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Wed, 28 Oct 2009 11:00:56 -0700
Message-ID: <adavdhzs8iv.fsf@cisco.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>
	<4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>
	<4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com>
	<1255570760.13845.4.camel@obelisk.thedillows.org>
	<4AD74C88.8030604@mellanox.com>
	<1255634715.29829.9.camel@lap75545.ornl.gov>
	<20091015213512.GW5191@obsidianresearch.com>
	<4AE0E71E.20309@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AE0E71E.20309-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (Vu Pham's message of "Thu, 22 Oct
	2009 16:13:34 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > +	if (timer_pending(&target->qp_err_timer))
 > +		del_timer_sync(&target->qp_err_timer);
 > +
 >  	spin_unlock_irq(target->scsi_host->host_lock);

As was pointed out, I don't think you can do del_timer_sync while
holding the lock, since the timer function takes the same lock.

But I don't know that just switching to del_timer without the sync works
here ... without the sync then the timeout function could still run any
time after the del_timer, even after everything gets freed.

BTW the test of timer_pending isn't needed here... del_timer does the
test internally anyway.

I do agree it would be very good to improve the SRP error handling.  I
have some concerns about the overall design here -- it seems that if we
handle connection failure and allow a new connection to proceed while
cleaning up asynchronously, then this opens the door to a lot of
complexity, and I don't see that complexity handled in this patchset.
For example, the new connection could fail too before the old one is
done cleaning up, etc, etc and we end up with an arbitrarily large queue
of things waiting to clean up.  Or maybe it really it is simpler than that.

I think the best way to move this forward would be to post another
cleaned up version of your patch set.  Please try to reorganize things
so each patch is reasonably self contained.  Of course your patchset is
taking multiple steps to improve things.  But as much as possible,
please try to avoid combining two things into a single patch, and
conversely also try to avoid putting things into a patch that don't make
sense without a later patch.

Avoiding policy in the kernel as much as possible in terms of hard-coded
timeouts etc is a good goal too.

Also it would help to give each patch a separate descriptive subject,
and put as much detail in the changelogs as you can.

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
