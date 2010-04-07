From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 31/37] librdmacm: provide abstracted verb calls
Date: Wed, 7 Apr 2010 13:14:46 -0700
Message-ID: <411E3A9BECF04B598FFEFFF08505DE6F@amr.corp.intel.com>
References: <27A4CFF94530491F88C8E528428FF93E@amr.corp.intel.com> <4BBCDF57.20303@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BBCDF57.20303-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> +static inline int
>> +rdma_get_send_comp(struct rdma_cm_id *id, struct ibv_wc *wc)
>> +{
>> +	struct ibv_cq *cq;
>> +	void *context;
>> +	int ret;
>> +
>> +	ret = ibv_poll_cq(id->send_cq, 1, wc);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ibv_req_notify_cq(id->send_cq, 0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ibv_poll_cq(id->send_cq, 1, wc);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ibv_get_cq_event(id->send_cq_channel, &cq, &context);
>> +	if (ret)
>> +		return ret;
>>
>
>This doesn't look correct.  If the send isn't complete by the time the
>2nd ibv_poll_cq() completes, then this function will return without
>having filled in the wc.  Or am I missing something?  Shouldn't the
>ibv_get_cq_event() be the first thing this function does?  The same
>issue/question exists for rdma_get_recv_comp().

I think it's possible for the function to return without having filled in a wc.
If the 2nd poll removes a completion, it can leave a cq event on the channel,
which a subsequent call could retrieve, but then find the cq empty.

The idea for this call is to abstract poll, notify_cq, and get_cq_event, but
still provide decent performance.  (Scalability is a separate matter.  I
couldn't find a decent way to abstract a CQ shared across QPs or between the
receive and send queues.)

To avoid returning from the call without a completion, I think the following
structure works:

poll()
notify_cq()
poll()
while (no completion) {
	get_cq_event()
	poll()
}

The only drawback I see is that it's theoretically possible to build up a queue
of cq events in the kernel.  Not sure how to fix that.  Any ideas?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
