From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/3] IB: new common API for draining queues
Date: Thu, 11 Feb 2016 17:18:40 -0600
Message-ID: <024201d16522$8af68440$a0e38cc0$@opengridcomputing.com>
References: <cover.1455230646.git.swise@chelsio.com> <3e7261d1436d33320223d365974ff38945f0d558.1455230646.git.swise@chelsio.com> <56BD1248.80805@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BD1248.80805-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Thursday, February 11, 2016 4:59 PM
> To: Steve Wise; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 1/3] IB: new common API for draining queues
> 
> On 02/05/2016 01:13 PM, Steve Wise wrote:
> > +static void wait_for_drain(struct ib_cq *cq, struct completion *c)
> > +{
> > +	if (cq->poll_ctx == IB_POLL_DIRECT)
> > +		do
> > +			ib_process_cq_direct(cq, 1024);
> > +		while (!wait_for_completion_timeout(c, msecs_to_jiffies(100)));
> > +	else
> > +		wait_for_completion(c);
> > +}
> 
> Hello Steve,
> 
> Have you verified this patch with checkpatch ? I expect that checkpatch
> will report that six braces are missing from this function.
> 
> Thanks,
> 
> Bart.

I'll run it through.  Thanks.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
