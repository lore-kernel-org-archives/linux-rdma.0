From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: support devices with queue size < 32
Date: Fri, 7 Apr 2017 15:31:56 +0200 (CEST)
Message-ID: <1917497781.360337179.1491571916242.JavaMail.zimbra@kalray.eu>
References: <1315914765.312051621.1490259849534.JavaMail.zimbra@kalray.eu> <80770042-743e-a271-c636-f72099f9ac56@grimberg.me> <9eb08168-18a6-a176-01df-b68b6a225963@redhat.com> <3505b835-d0ba-70cb-dfe8-1265fc2bbb83@redhat.com> <2ba93b5b-ad36-5533-36e2-9db2e3198c19@grimberg.me> <1121115847.336382032.1490883808617.JavaMail.zimbra@kalray.eu> <1224897571.353404199.1491481743295.JavaMail.zimbra@kalray.eu> <20170406130207.GI2269@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170406130207.GI2269-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Thu, Apr 06, 2017 at 02:29:03PM +0200, Marta Rybczynska wrote:
>> >>>> You say above "we post *up to* 2 work requests", unless you wish to
>> >>>> change that to "we always post at least 2 work requests per queue
>> >>>> entry", Jason is right, your frequency of signaling needs to be X/2
>> >>>> regardless of your CQ size, you need the signaling to control the queue
>> >>>> depth tracking.
>> >>>
>> >>> If you would like to spread things out farther between signaling, then
>> >>> you can modify your send routine to only increment the send counter for
>> >>> actual send requests, ignoring registration WQEs and invalidate WQES,
>> >>> and then signal every X/2 sends.
>> >>
>> >> Yea, you're right, and not only I got it wrong, I even contradicted my
>> >> own suggestion that was exactly what you and Jason suggested (where is
>> >> the nearest rat-hole...)
>> >>
>> >> So I suggested to signal every X/2 and Marta reported SQ overflows for
>> >> high queue-dpeth. Marta, at what queue-depth have you seen this?
>> >
>> > The remote side had queue depth of 16 or 32 and that's the WQ on the
>> > initiator side that overflows (mlx5_wq_overflow). We're testing with
>> > signalling X/2 and it seems to work.
>>
>> Update on the situation: the signalling on X/2 seems to work fine in
>> practice. To clarify more that's the send queue that overflows
>> (mlx5_wq_overflow in begin_wqe of drivers/infiniband/hw/mlx5/qp.c).
>>
>> However, I have still doubt how it's going to work in the case of
>> higher queue depths (i.e. the typical case). If we signal every X/2
>> we'll do it much more rarely than today (every 32 messages). I'm not
>> sure on the system effect this would have.
>>
>> Mellanox guys, do you have an idea what it might do?
> 
> It will continue to work as expected with long depths too.
> All that you need is do not to forget to issue signal if queue is terminated.
> 

Thanks Leon. I will then submit the v2.

Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
