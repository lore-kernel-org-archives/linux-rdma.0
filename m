From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Mon, 20 Nov 2017 14:26:51 +0200
Message-ID: <da18d9bc-4db4-8bc1-dd61-05cb14dcd53c@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <1510245771.2608.6.camel@wdc.com>
 <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5@grimberg.me>
 <1510248716.2608.17.camel@wdc.com>
 <6af627c8-2814-d562-21a2-f10788e44458@grimberg.me>
 <1510676487.2280.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510676487.2280.4.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> The ULP is free to pass in an affinity hint to enforce locality to a
>> specific cpu core. Would that solve this issue?
> 
> Only for mlx5 adapters because only the mlx5 driver implements
> .get_vector_affinity(). For other adapters the following code is used to chose a
> vector:

Looks like even that will get reverted for 4.15 :)
Due to the change in user experience for managed irq vectors.

> 
>      vector = affinity_hint % dev->num_comp_vectors;
> 
> That means whether or not a single CQ will be used by different CPUs depends on
> how the ULP associates 'affinity_hint' with CPUs.

My intension was to pass it down to ib_alloc_cq and then convert
ib_cq_poll_work to run queue_work_on(cq->cpu, ib_comp_wq, &cq->work)

Note that you point out something that is more relevant to server/target
side ULPs (hence the assumption of workqueue mode).

So up until now I count Bart and Max on per-ULP pools, on the other
hand theres Christoph and I for per-device pools. Can we get a tie
breaker?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
