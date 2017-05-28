From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Sun, 28 May 2017 12:53:00 +0300
Message-ID: <19a1d347-91da-7e5f-8877-86772204a80a@mellanox.com>
References: <1495957991-19223-1-git-send-email-maxg@mellanox.com>
 <1495957991-19223-2-git-send-email-maxg@mellanox.com>
 <20170528090705.GM13083@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170528090705.GM13083-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 5/28/2017 12:07 PM, Christoph Hellwig wrote:
> On Sun, May 28, 2017 at 10:53:11AM +0300, Max Gurtovoy wrote:
>> Cache the needed umr_fence and set the wqe ctrl segmennt
>> accordingly.
>
> Looks good,
>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Thanks.

>
> But that whole fence logic looks awkward to me.  Does the following
> patch to reorder it make sense to you?
>


Yes it make sense to me.
Sagi/Leon, any comments ?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
