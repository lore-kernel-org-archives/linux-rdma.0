From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rfc 3/5] irq_poll: wire up irq_am
Date: Mon, 12 Feb 2018 21:40:52 +0200
Message-ID: <5d0abc5a-5b5d-33d2-954c-3ec92272b99f@grimberg.me>
References: <20180205220316.30236-1-sagi@grimberg.me>
 <20180205220316.30236-4-sagi@grimberg.me> <1518053304.2870.95.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518053304.2870.95.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Bart,

>> +void irq_poll_init_am(struct irq_poll *iop, unsigned int nr_events,
>> +        unsigned short nr_levels, unsigned short start_level, irq_poll_am_fn *amfn)
>> +{
>> +	iop->amfn = amfn;
>> +	irq_am_init(&iop->am, nr_events, nr_levels, start_level, irq_poll_am);
>> +}
> 
> This function has a large number of parameters and most of them are passed verbatim to
> irq_am_init(). Please consider to introduce a structure for these parameters such that
> the number of function arguments stays reasonable.

I can definitely change that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
