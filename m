From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 1/9] RDMA/core: Add implicit per-device completion
 queue pools
Date: Mon, 20 Nov 2017 14:31:53 +0200
Message-ID: <4fc5c223-358b-303b-26d6-abbc1620a74e@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <20171108095742.25365-2-sagi@grimberg.me> <1510676885.2280.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510676885.2280.9.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> +struct ib_cq *ib_find_get_cq(struct ib_device *dev, unsigned int nr_cqe,
>> +               enum ib_poll_context poll_ctx, int affinity_hint)
>> +{
>> +       struct ib_cq *cq, *found;
>> +       unsigned long flags;
>> +       int vector, ret;
>> +
>> +       if (poll_ctx >= ARRAY_SIZE(dev->cq_pools))
>> +               return ERR_PTR(-EINVAL);
>> +
>> +       if (!ib_find_vector_affinity(dev, affinity_hint, &vector)) {
>> +               /*
>> +                * Couldn't find matching vector affinity so project
>> +                * the affinty to the device completion vector range
>> +                */
>> +               vector = affinity_hint % dev->num_comp_vectors;
>> +       }
> 
> So depending on whether or not the HCA driver implements .get_vector_affinity()
> either pci_irq_get_affinity() is used or "vector = affinity_hint %
> dev->num_comp_vectors"? Sorry but I think that kind of differences makes it
> unnecessarily hard for ULP maintainers to provide predictable performance and
> consistent behavior across HCAs.

Well, as a ULP maintainer I think that in the lack of
.get_vector_affinity() I would do that same thing as this code. srp
itself is doing the same thing in srp_create_target()
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
