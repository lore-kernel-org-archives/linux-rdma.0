From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 3 May 2017 19:01:14 +0300
Message-ID: <77ada146-67eb-9dce-d252-6ac630c9a1e8@grimberg.me>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu>
 <823aa3f0-685f-4569-11d6-238cc4f0b126@grimberg.me>
 <780938034.8003164.1493824767084.JavaMail.zimbra@kalray.eu>
 <20170503155316.GA14334@obsidianresearch.com>
 <1493827096.3901.4.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493827096.3901.4.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hello Jason,
>
> As far as I know the compiler only does that for compile-time constants. In
> this case the divisor (max(queue_size / 2, 1)) is not a compile-time constant.

We could theoretically do a (sig_count & max(queue_size / 2, 1)) but
that would only do well with power of 2 sized queues...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
