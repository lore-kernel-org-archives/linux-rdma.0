From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/srp: implement SRP_CRED_REQ
Date: Sat, 14 Aug 2010 13:08:51 -0400
Message-ID: <1281805731.2670.14.camel@obelisk.thedillows.org>
References: <201008021732.44769.bvanassche@acm.org>
	 <1280785473.2451.90.camel@lap75545.ornl.gov>
	 <AANLkTikSFgcjZ0z-Py1+yeFZ8oAohBS=fpRAMqWRBnHy@mail.gmail.com>
	 <1280847933.20446.29.camel@lap75545.ornl.gov>
	 <AANLkTinMU8QkX-5WrsW18UJ7qNfp7ZDchpqcPw0JGAJz@mail.gmail.com>
	 <1280850256.20446.56.camel@lap75545.ornl.gov>
	 <AANLkTikmh4+15_3wPGaBkb5o5wkyyiLnRbqKu2Tzmbgp@mail.gmail.com>
	 <1281723164.2437.40.camel@lap75545.ornl.gov>
	 <AANLkTim_qOd_pX2pnSVv5NJJsQ0jYqJP5fo-5YC8TRV=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim_qOd_pX2pnSVv5NJJsQ0jYqJP5fo-5YC8TRV=@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-08-14 at 10:21 +0200, Bart Van Assche wrote:
> On Fri, Aug 13, 2010 at 8:12 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> > On Tue, 2010-08-10 at 09:55 +0200, Bart Van Assche wrote:
> >> On Tue, Aug 3, 2010 at 5:44 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> >> >
> >> > On Tue, 2010-08-03 at 17:26 +0200, Bart Van Assche wrote:
> >> > [ ... ]
> >> > > I'm not sure it is a good idea to allow that all transmit buffers get
> >> > > allocated for sending CMD_RSP information units and that none remain
> >> > > for replying to incoming SRP_CRED_REQ / SRP_AER_REQ / SRP_T_LOGOUT
> >> > > requests. Wouldn't that be a protocol violation ?
> >> >
> >> > You mean SRP_CMD? We don't do that, we clamp the outstanding requests we
> >> > generate so we'll always have a buffer to reply to SRP_CRED_REQ et al.
> >> >
> >> > If SRQ_SQ_SIZE is 64, we set .can_queue to 63 which will leave a buffer
> >> > available for the reply.
> >> >
> >> > Now, if the target sends us multiple SRP_CRED_REQ without waiting for a
> >> > reply, then we could use up buffers and not be able to send requests,
> >> > but that would be a protocol violation on the target's side.
> >>
> >> (resending as plain text)
> >>
> >> I have been looking further into this. There is a slight asymmetry in
> >> the current transmit buffer allocation code: one buffer element is
> >> reserved on the target for task management requests but not on the
> >> initiator. So - at least in theory - it is possible that all elements
> >> of the initiator transmit ring are allocated for SRP_CMD requests at
> >> the time an SRP_TSK_MGMT request should be sent. Wouldn't it be more
> >> symmetric to change __srp_get_tx_iu() as follows (diff against the
> >> current for-next branch) ?
> >
> > This is not needed in the code as it currently stands. We cannot have
> > all elements of the tx ring allocated for SRP_CMD requests, because we
> > don't send one if we don't have a credit for it, and we save a credit
> > for the SRP_TSK_MGMT request. Hence, there will always be a buffer
> > available for the management request.
> >
> > We don't need it for when we start replying to target requests in the
> > future, because we already reserve that buffer by limiting our view of
> > credits to one less than the actual ring size.
> 
> It is not needed as long as the target respects the limit of at most
> one outstanding request, as required by the SRP (draft) standard. The
> test in question is a single if-statement that provides some
> additional robustness and no measurable overhead. So I don't see why
> it should be removed.

I didn't say remove it, I'm objecting to your changes to it. They are
unnecessary because we will keep a Tx buffer around for the response to
a conforming target. Keeping the guard is needed for the reasons you
point out about non-conforming targets.

Dave


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
