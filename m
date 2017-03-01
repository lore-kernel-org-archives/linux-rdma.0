From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Poll CQ syncing problem
Date: Wed, 1 Mar 2017 18:44:58 +0200
Message-ID: <0786659a-da12-e8f7-329e-3caa8cc8791f@grimberg.me>
References: <b4355d22-fc79-c860-de8a-5a4d468c884d@mellanox.com>
 <3ba1baab-e2ac-358d-3b3b-ff4a27405c93@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3ba1baab-e2ac-358d-3b3b-ff4a27405c93-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hi Christoph, Sagi

Hi Noa,

> Analysis:
> Since ib_comp_wq isn't single threaded, two works can run in parallel for the same CQ,
> executing __ib_process_cq.

How is that even possible? AFAICT a given CQ cannot run more than a
single work item at a time because we simply queue a work when we get
a completion event and rearm it only when we fully drain it. we requeue
if we exhausted our budget but still I don't see a mutual exclusion
violation...

Am I missing anything?

> Since this function isn't thread safe and the wc array is shared, it causes a data corruption
> which eventually crashes in the MAD layer due to a double list_del of the same element.

Hmm. I'm wandering if this is really the root-cause... Can it be the
fact that ib_comp_wq is unbound causing the worker to migrate cpu cores
in its lifetime?

I wanted to change that a while ago and sent a patch for it [1].

> We have the following options to solve this:
> 1. Instead of cq->wc, allocate an ib_wc array in __ib_process_cq per each call.

That is bad practice.

> 2. Make ib_comp_wq a single thread workqueue.

Not going to happen, it'll kill performance.

> 3. Change the locking scheme during poll: Currently only the device's poll_cq implementation
>    is done under lock. Change it to also contan the callbacks.

I don't see a need for this at all.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
