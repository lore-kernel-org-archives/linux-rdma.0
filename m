From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: support devices with queue size < 32
Date: Wed, 29 Mar 2017 19:59:13 +0300
Message-ID: <2ba93b5b-ad36-5533-36e2-9db2e3198c19@grimberg.me>
References: <1315914765.312051621.1490259849534.JavaMail.zimbra@kalray.eu>
 <20170323140042.GA30536@lst.de>
 <277345557.313693033.1490279818647.JavaMail.zimbra@kalray.eu>
 <4951fac6-662f-29a6-5ba5-38d37a2c2dca@grimberg.me>
 <1180136633.325075447.1490700022740.JavaMail.zimbra@kalray.eu>
 <8dc0414f-be90-ee30-0f66-8cee26c4c2aa@grimberg.me>
 <20170329132918.GA32072@obsidianresearch.com>
 <406682b9-d7ca-4718-5830-7940d2822bc0@grimberg.me>
 <20170329162751.GA7113@obsidianresearch.com>
 <80770042-743e-a271-c636-f72099f9ac56@grimberg.me>
 <9eb08168-18a6-a176-01df-b68b6a225963@redhat.com>
 <3505b835-d0ba-70cb-dfe8-1265fc2bbb83@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3505b835-d0ba-70cb-dfe8-1265fc2bbb83-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> You say above "we post *up to* 2 work requests", unless you wish to
>> change that to "we always post at least 2 work requests per queue
>> entry", Jason is right, your frequency of signaling needs to be X/2
>> regardless of your CQ size, you need the signaling to control the queue
>> depth tracking.
>
> If you would like to spread things out farther between signaling, then
> you can modify your send routine to only increment the send counter for
> actual send requests, ignoring registration WQEs and invalidate WQES,
> and then signal every X/2 sends.

Yea, you're right, and not only I got it wrong, I even contradicted my
own suggestion that was exactly what you and Jason suggested (where is
the nearest rat-hole...)

So I suggested to signal every X/2 and Marta reported SQ overflows for
high queue-dpeth. Marta, at what queue-depth have you seen this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
