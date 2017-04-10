From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: support devices with queue size < 32
Date: Mon, 10 Apr 2017 13:29:37 +0200 (CEST)
Message-ID: <303729965.362188822.1491823777140.JavaMail.zimbra@kalray.eu>
References: <1315914765.312051621.1490259849534.JavaMail.zimbra@kalray.eu> <3505b835-d0ba-70cb-dfe8-1265fc2bbb83@redhat.com> <2ba93b5b-ad36-5533-36e2-9db2e3198c19@grimberg.me> <1121115847.336382032.1490883808617.JavaMail.zimbra@kalray.eu> <1224897571.353404199.1491481743295.JavaMail.zimbra@kalray.eu> <20170406130207.GI2269@mtr-leonro.local> <1917497781.360337179.1491571916242.JavaMail.zimbra@kalray.eu> <c7e56394-feb3-282b-0eec-166ef0d8b13c@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c7e56394-feb3-282b-0eec-166ef0d8b13c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>>> Mellanox guys, do you have an idea what it might do?
>>>
>>> It will continue to work as expected with long depths too.
>>> All that you need is do not to forget to issue signal if queue is terminated.
>>>
>>
>> Thanks Leon. I will then submit the v2.
> 
> Marta, can you please test with higher queue-depth? Say 512 and/or 1024?
> 

Yes, we'll do that.

Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
