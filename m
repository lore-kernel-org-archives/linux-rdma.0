From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/srp: implement SRP_CRED_REQ
Date: Tue, 03 Aug 2010 11:05:33 -0400
Message-ID: <1280847933.20446.29.camel@lap75545.ornl.gov>
References: <201008021732.44769.bvanassche@acm.org>
 <1280785473.2451.90.camel@lap75545.ornl.gov>
 <AANLkTikSFgcjZ0z-Py1+yeFZ8oAohBS=fpRAMqWRBnHy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTikSFgcjZ0z-Py1+yeFZ8oAohBS=fpRAMqWRBnHy-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-08-03 at 13:40 +0200, Bart Van Assche wrote:
> On Mon, Aug 2, 2010 at 11:44 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> > On Mon, 2010-08-02 at 17:32 +0200, Bart Van Assche wrote:
> > [ ... ]
> >
> > There seems to be an accounting change from using tx_head/tx_tail to
> > using tx_req and tx_rsp. I'm not sure that really makes sense --
> > splitting that into its own patch would allow for an easier review and
> > may make it obvious if it is the right thing to do.
> 
> As I wrote in [PATCH 0/4], both initator-to-target requests and
> initiator-to-target responses are now allocated from the same send
> queue. Since tx_head - tx_tail is now the sum of the number of
> requests and the number of responses allocated on the send queue, new
> variables had to be introduced in order to count how many requests and
> how many responses had been allocated on the send queue.

I understood that you were allocating from the same queue of buffers,
I'm just not sure you need to keep track separately. We already hold
SRP_RSP_SQ_SIZE buffers back from sending requests, so we will always
have those (well, one) available for sending a response.

If we use too many for responses, that's not great, but it isn't
completely fatal -- srp_queuecommand() will bounce the command back to
the mid-layer with a BUSY status, and while the error handling (task
mgmt) will go to the big guns and reset the connection sooner, we will
recover.

If there isn't a buffer available to send the response, it'll get
dropped on the floor, just like in your patch.

I just don't see a reason for the accounting change.

> > SRP_AER_REQ isn't handled, and it wouldn't be much to add it. That would
> > improve our standards compatibility.
> 
> The message "Unhandled SRP opcode" is printed for SRP_AER_REQ
> information units. Support for SRP_AER_REQ can still be added in a
> follow-up patch.

Adding the few lines to this patch to implement a stub for it is
preferable. Credits may be returned via the AER message as well, so it
fits in the justification you give for this patch.

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
