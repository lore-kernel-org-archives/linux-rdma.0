From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Mon, 13 Nov 2017 22:31:26 +0200
Message-ID: <6af627c8-2814-d562-21a2-f10788e44458@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <1510245771.2608.6.camel@wdc.com>
 <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5@grimberg.me>
 <1510248716.2608.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510248716.2608.17.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> But I'm afraid don't understand how the fact that ULPs will run on
>> different ports matter? how would the fact that we had two different
>> pools on different ports make a difference?
> 
> If each RDMA port is only used by a single ULP then the ULP driver can provide
> a better value for the CQ size than IB_CQE_BATCH. If CQ pools would be created
> by ULPs then it would be easy for ULPs to pass their choice of CQ size to the
> RDMA core.

But if that is not the case, maybe we may have less completion
aggragation per interrupt.

> In case multiple ULPs share an RDMA port then which CQ is chosen for the ULP
> will depend on the order in which the ULP drivers are loaded. This may lead to
> hard to debug performance issues, e.g. due to different lock contention
> behavior. That's another reason why per-ULP CQ pools look more interesting to
> me than one CQ pool per HCA.

The ULP is free to pass in an affinity hint to enforce locality to a
specific cpu core. Would that solve this issue?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
