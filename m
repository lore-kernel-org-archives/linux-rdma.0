From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Sun, 4 Jun 2017 18:49:20 +0300
Message-ID: <6bf26cbc-71e4-a030-628b-a2ee1d1de94b@grimberg.me>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <56e8ccd3-8116-89a1-2f65-eb61a91c5f84@mellanox.com>
 <860db62d-ae93-d94c-e5fb-88e7b643f737@redhat.com>
 <0a825b18-df06-9a6d-38c9-402f4ee121f7@mellanox.com>
 <7496c68a-15f3-d8cb-b17f-20f5a59a24d2@redhat.com>
 <31678a43-f76c-a921-e40c-470b0de1a86c@grimberg.me>
 <20170319070115.GP2079@mtr-leonro.local>
 <136275928.8307994.1495126919829.JavaMail.zimbra@redhat.com>
 <358169046.8629042.1495210672801.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <358169046.8629042.1495210672801.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yi,

> Finally found below patch [1] that fixed this issue.
> With [1], I can see the speed of reset_controller operation[2] is obviously slow than before.
> 
> 
> [1]
> commit b7363e67b23e04c23c2a99437feefac7292a88bc
> Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Date:   Wed Mar 8 22:03:17 2017 +0200
> 
>      IB/device: Convert ib-comp-wq to be CPU-bound

This is very unlikely.

I think that what made this go away is:

commit 777dc82395de6e04b3a5fedcf153eb99bf5f1241
Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Date:   Tue Mar 21 16:29:49 2017 +0200

     nvmet-rdma: occasionally flush ongoing controller teardown

     If we are attacked with establishments/teradowns we need to
     make sure we do not consume too much system memory. Thus
     let ongoing controller teardowns complete before accepting
     new controller establishments.


Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
