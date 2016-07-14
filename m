From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: NVMe over RDMA latency
Date: Thu, 14 Jul 2016 09:52:18 +0300
Message-ID: <578736A2.40402@grimberg.me>
References: <1467921342.24395.12.camel@ssi> <57860EBA.5010103@grimberg.me>
 <1468434332.1869.8.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468434332.1869.8.camel@ssi>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> With real NVMe device on target, host see latency about 33us.
>
> root@host:~# fio t.job
> job1: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
> fio-2.9-3-g2078c
> Starting 1 process
> Jobs: 1 (f=1): [r(1)] [100.0% done] [113.1MB/0KB/0KB /s] [28.1K/0/0 iops] [eta 00m:00s]
> job1: (groupid=0, jobs=1): err= 0: pid=3139: Wed Jul 13 11:22:15 2016
>    read : io=2259.5MB, bw=115680KB/s, iops=28920, runt= 20001msec
>      slat (usec): min=1, max=195, avg= 2.62, stdev= 1.24
>      clat (usec): min=0, max=7962, avg=30.97, stdev=14.50
>       lat (usec): min=27, max=7968, avg=33.70, stdev=14.69
>
> And tested NVMe device locally on target, about 23us.
> So nvmeof added only about ~10us.
>
> That's nice!

I didn't understand what was changed?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
