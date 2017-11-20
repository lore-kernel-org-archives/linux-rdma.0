From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Mon, 20 Nov 2017 14:10:13 +0200
Message-ID: <fd911816-576f-5a8e-eb41-b9081c960685@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <1510245771.2608.6.camel@wdc.com>
 <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5@grimberg.me>
 <1510248716.2608.17.camel@wdc.com>
 <6af627c8-2814-d562-21a2-f10788e44458@grimberg.me>
 <20171113203444.GJ22610@ziepe.ca>
 <75a7cfe3-58e0-b416-0b5b-beba1e8207fd@grimberg.me>
 <20171114024822.GN22610@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114024822.GN22610-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> It is too bad we can't re-size CQs.. Can we?
>>
>> I wish we could, but its an optional feature so I can't see how we can
>> use it.
> 
> Well, it looks like mlx4/5 can do it, which covers a huge swath of
> deployed hardware..
> 
> I'd say make an optimal implementation using resize_cq and just a working
> implementation without it?

I can experiment with it, sure. Do you think that its a must have for
first phase though?

> The only way to encourage vendors to implement optional features is to
> actually use them in the OS...

I agree with you on that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
