From: idanb <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add remote_invalidation module parameter
Date: Mon, 30 Oct 2017 10:38:18 +0200
Message-ID: <7e038d80-de95-8fb7-e313-825e40c03e88@mellanox.com>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
 <1509295101-14081-3-git-send-email-idanb@mellanox.com>
 <20171029175237.GD4488@ziepe.ca>
 <740c93f4-164e-d4e3-97b1-313a0420ae81@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <740c93f4-164e-d4e3-97b1-313a0420ae81-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 10/30/2017 10:14 AM, Sagi Grimberg wrote:
>
>> Sagi, is this really an apples to apples comparison?
>
> No
>
>> When I was talking with Chuck on NFS there were some various issues on
>> that side that made the local invalidate run faster, but it wasn't
>> actually working properly.
>>
>> Does nvme wait for the local invalidate to finish before moving on?
>
> Not really, and we should, I'll get to it.

I agree we should fix this, nevertheless I don't expect this to create 
an IO rate issue for long queue depths.
Indeed we will have a tradeoff here of latency vs rate.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
