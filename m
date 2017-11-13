From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 1/9] RDMA/core: Add implicit per-device completion
 queue pools
Date: Mon, 13 Nov 2017 22:28:32 +0200
Message-ID: <1ac39e4b-81c8-1571-0fdf-8e9a38f1a5de@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <20171108095742.25365-2-sagi@grimberg.me>
 <fe2c23b7-2923-2693-28c3-6a6f399bda26@mellanox.com>
 <23b598f2-6982-0d15-69e4-c526c627ec33@grimberg.me>
 <1510248814.2608.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510248814.2608.19.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hello Sagi,
> 
> How about the following:
> 
> 	min(dev->attrs.max_cqe, max(nr_cqes, IB_CQE_BATCH))

That would work too, thanks Bart!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
