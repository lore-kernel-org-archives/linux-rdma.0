From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] new ib_drain_qp() API
Date: Tue, 9 Feb 2016 17:23:43 -0500
Message-ID: <47D5799E-57BD-4BD2-84B8-1E9459393706@oracle.com>
References: <cover.1454969695.git.swise@chelsio.com> <010901d16375$1a023210$4e069630$@opengridcomputing.com> <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com> <56BA540B.4040405@sandisk.com> <011901d1637d$b5286400$1f792c00$@opengridcomputing.com> <012801d16384$f68884f0$e3998ed0$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <012801d16384$f68884f0$e3998ed0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 9, 2016, at 4:58 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
> 
>>> Hello Steve,
>>> 
>>> How about creating three functions - one that drains the receive queue,
>>> one that drains the send queue and a third function that drains both ?
>>> The latter function then can call the two former functions. And since
>>> only one of these three functions will have a user in your patch series
>>> (the function that drains the RQ), how about only introducing only that
>>> function now and to wait with introducing the two other functions until
>>> these have a user ?
>> 
>> That sounds reasonable.  Simpler too perhaps.  We'll see if anyone else
>> has an opinion.
> 
> Another option is for ib_drain_qp() to just skip queues with IB_POLL_DIRECT CQ processing.

Does ib_drain_qp() recognize when one CQ is new-style, and one
is old school? How about QPs with a single CQ? Since there is
a requirement that each CQ is allocated via ib_alloc_cq, it
would be good to assert that is true in ib_drain_qp() before
you prepare and post the blank WRs.

Or if you prefer not to handle it automatically, you could add
a flag parameter to ib_drain_qp (IB_DRAIN_RQ, IB_DRAIN_SQ, or
IB_DRAIN_BOTH).


--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
