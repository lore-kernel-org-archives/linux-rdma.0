From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Expose correct max_sge_rd limit
Date: Thu, 7 Apr 2016 10:05:24 +0300
Message-ID: <570606B4.5040402@grimberg.me>
References: <1459440205-25208-1-git-send-email-sagig@grimberg.me>
 <20160401000426.GF2670@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160401000426.GF2670-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 01/04/16 03:04, Leon Romanovsky wrote:
> On Thu, Mar 31, 2016 at 07:03:25PM +0300, Sagi Grimberg wrote:
>> mlx5 devices (Connect-IB, ConnectX-4, ConnectX-4-LX) has a limitation
>> where rdma read work queue entries cannot exceed 512 bytes.
>> A rdma_read wqe needs to fit in 512 bytes:
>> - wqe control segment (16 bytes)
>> - rdma segment (16 bytes)
>> - scatter elements (16 bytes each)
>>
>> So max_sge_rd should be: (512 - 16 - 16) / 16 = 30.
>>
>> Reported-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> Tested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> Signed-off-by: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>
> Thanks Sagi,
>
> Excellent catch, the same as in commit: a5e4ba334e2
> ("mlx4: Expose correct max_sge_rd limit")
>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Doug, this is stable material, can we get it to 4.6-rc
and place a stable tag on it?

Thanks,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
