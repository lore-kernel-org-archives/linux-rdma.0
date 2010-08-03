From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/srp: implement SRP_CRED_REQ
Date: Tue, 03 Aug 2010 11:44:16 -0400
Message-ID: <1280850256.20446.56.camel@lap75545.ornl.gov>
References: <201008021732.44769.bvanassche@acm.org>
 <1280785473.2451.90.camel@lap75545.ornl.gov>
 <AANLkTikSFgcjZ0z-Py1+yeFZ8oAohBS=fpRAMqWRBnHy@mail.gmail.com>
 <1280847933.20446.29.camel@lap75545.ornl.gov>
 <AANLkTinMU8QkX-5WrsW18UJ7qNfp7ZDchpqcPw0JGAJz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTinMU8QkX-5WrsW18UJ7qNfp7ZDchpqcPw0JGAJz-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-08-03 at 17:26 +0200, Bart Van Assche wrote:
> On Tue, Aug 3, 2010 at 5:05 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> > I understood that you were allocating from the same queue of buffers,
> > I'm just not sure you need to keep track separately. We already hold
> > SRP_RSP_SQ_SIZE buffers back from sending requests, so we will always
> > have those (well, one) available for sending a response.
> >
> > If we use too many for responses, that's not great, but it isn't
> > completely fatal -- srp_queuecommand() will bounce the command back to
> > the mid-layer with a BUSY status, and while the error handling (task
> > mgmt) will go to the big guns and reset the connection sooner, we will
> > recover.
> >
> > If there isn't a buffer available to send the response, it'll get
> > dropped on the floor, just like in your patch.
> >
> > I just don't see a reason for the accounting change.
> 
> I'm not sure it is a good idea to allow that all transmit buffers get
> allocated for sending CMD_RSP information units and that none remain
> for replying to incoming SRP_CRED_REQ / SRP_AER_REQ / SRP_T_LOGOUT
> requests. Wouldn't that be a protocol violation ?

You mean SRP_CMD? We don't do that, we clamp the outstanding requests we
generate so we'll always have a buffer to reply to SRP_CRED_REQ et al.

If SRQ_SQ_SIZE is 64, we set .can_queue to 63 which will leave a buffer
available for the reply.

Now, if the target sends us multiple SRP_CRED_REQ without waiting for a
reply, then we could use up buffers and not be able to send requests,
but that would be a protocol violation on the target's side.

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
