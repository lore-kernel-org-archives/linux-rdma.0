From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Thu, 15 Jun 2017 16:45:37 +0800
Message-ID: <6f5249b4-e8fe-5def-bbc9-0079b7457df9@redhat.com>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <56e8ccd3-8116-89a1-2f65-eb61a91c5f84@mellanox.com>
 <860db62d-ae93-d94c-e5fb-88e7b643f737@redhat.com>
 <0a825b18-df06-9a6d-38c9-402f4ee121f7@mellanox.com>
 <7496c68a-15f3-d8cb-b17f-20f5a59a24d2@redhat.com>
 <31678a43-f76c-a921-e40c-470b0de1a86c@grimberg.me>
 <20170319070115.GP2079@mtr-leonro.local>
 <136275928.8307994.1495126919829.JavaMail.zimbra@redhat.com>
 <358169046.8629042.1495210672801.JavaMail.zimbra@redhat.com>
 <6bf26cbc-71e4-a030-628b-a2ee1d1de94b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6bf26cbc-71e4-a030-628b-a2ee1d1de94b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 06/04/2017 11:49 PM, Sagi Grimberg wrote:
> Hi Yi,
>
>> Finally found below patch [1] that fixed this issue.
>> With [1], I can see the speed of reset_controller operation[2] is 
>> obviously slow than before.
>>
>>
>> [1]
>> commit b7363e67b23e04c23c2a99437feefac7292a88bc
>> Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>> Date:   Wed Mar 8 22:03:17 2017 +0200
>>
>>      IB/device: Convert ib-comp-wq to be CPU-bound
>
> This is very unlikely.
>
> I think that what made this go away is:
>
> commit 777dc82395de6e04b3a5fedcf153eb99bf5f1241
> Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Date:   Tue Mar 21 16:29:49 2017 +0200
>
>     nvmet-rdma: occasionally flush ongoing controller teardown
>
>     If we are attacked with establishments/teradowns we need to
>     make sure we do not consume too much system memory. Thus
>     let ongoing controller teardowns complete before accepting
>     new controller establishments.
>
Hi Sagi
This patch fixed the issue, thanks again.

Yi
>
> Cheers,
> Sagi.
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
