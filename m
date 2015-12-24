From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 0/3] Add cross-channel support
Date: Thu, 24 Dec 2015 10:02:29 +0200
Message-ID: <567BA695.8050403@mellanox.com>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450606571-15877-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/24/2015 5:31 AM, Doug Ledford wrote:
> On 12/20/2015 12:16 PM, Leon Romanovsky wrote:
>> Leon Romanovsky (3):
>>    IB/core: Align coding style of ib_device_cap_flags structure
>>    IB/core: Add cross-channel support
>>    IB/mlx5: Add driver cross-channel support
>>
>>   drivers/infiniband/core/uverbs_cmd.c |  5 ++-
>>   drivers/infiniband/hw/mlx5/cq.c      |  7 +++-
>>   drivers/infiniband/hw/mlx5/main.c    |  3 ++
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h | 16 ++++++++
>>   drivers/infiniband/hw/mlx5/qp.c      | 54 ++++++++++++++++++++++-----
>>   include/linux/mlx5/qp.h              |  3 ++
>>   include/rdma/ib_verbs.h              | 71 +++++++++++++++++++++---------------
>>   7 files changed, 117 insertions(+), 42 deletions(-)
>>
>
> I took the series as is.  Please make sure to resubmit the libibverbs portion of these changes with the requested man page updates.
>
Doug,

Wait.

We had consensus among the reviewers that the 1st patch ("IB/core: Align 
coding style of ib_device_cap_flags structure") is wrong cleanup which 
basically is (1) unneeded (2) creates more damage (git blame and such,  
non-applicable to uapi, more) than benefit, etc -- finally Leon was 
convinced too [1].

Leon will re-spin in the coming 1-2 hours V2, could please pick it 
instead of V1, when people agree on direction X and you are not against 
it, lets do X and not Y.

thanks,

Or.

[1] http://marc.info/?t=145061068000003&r=1&w=2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
