From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 1/3] IB: new common API for draining queues
Date: Thu, 11 Feb 2016 18:32:35 -0600
Message-ID: <56BD2823.3020804@opengridcomputing.com>
References: <cover.1455230646.git.swise@chelsio.com>
 <3e7261d1436d33320223d365974ff38945f0d558.1455230646.git.swise@chelsio.com>
 <56BD1248.80805@sandisk.com> <56BD1624.4090309@sandisk.com>
 <024401d16522$d7bbfd50$8733f7f0$@opengridcomputing.com>
 <56BD1800.9050508@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BD1800.9050508-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 2/11/2016 5:23 PM, Bart Van Assche wrote:
> On 02/11/2016 03:20 PM, Steve Wise wrote:
>> I guess you're making your point to not post code that has no user...
>
> How about using WARN_ONCE(cq->poll_ctx == IB_POLL_DIRECT) instead ?

That's fine with me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
