From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 05/13] SoftiWarp application interface
Date: Tue, 23 Jan 2018 12:12:51 -0600
Message-ID: <015901d39475$c8407bb0$58c17310$@opengridcomputing.com>
References: <012901d3946e$41044a70$c30cdf50$@opengridcomputing.com>,<20180114223603.19961-1-bmt@zurich.ibm.com> <20180114223603.19961-6-bmt@zurich.ibm.com> <OF7390EC15.6C2741F2-ON0025821E.0062D222-0025821E.00639402@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF7390EC15.6C2741F2-ON0025821E.0062D222-0025821E.00639402-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bernard Metzler' <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >The rdma provider must ensure that event upcalls are serialized per
> >object.
> >Is this being done somewhere?  See "Callbacks" in
> >Documentation/infiniband/core_locking.txt.
> >
> 
> That says, if multiple QP's etc. contribute to a CQ, only one
> CQ event handler is allowed to run? That's not there, I would have
> to make a lock around...

Correct.  Basically, for a given CQ object, the driver can only have a single outstanding call to the ULP's event handler for that CQ at any point in time.  

...

> >> +	/*
> >> +	 * Try to acquire QP state lock. Must be non-blocking
> >> +	 * to accommodate kernel clients needs.
> >> +	 */
> >> +	if (!down_read_trylock(&qp->state_lock)) {
> >> +		*bad_wr = wr;
> >> +		return -ENOTCONN;
> >> +	}
> >> +
> >
> >Under what conditions does down_read_trylock() return 0?  This seems
> >like a
> >kernel ULP that has multiple threads posting to the sq might get an
> >error
> >due to lock contention?
> 
> This lock is only taken if the QP is to be transitioned into
> another state. If we are here, we assume to be in RTS state.
> If the lock is not available, someone else just moves the QP out
> of RTS and we should not do much here.
> 

Ah, I see.

> We do trylock() since we cannot sleep in some of our contexts...
> 

Right.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
