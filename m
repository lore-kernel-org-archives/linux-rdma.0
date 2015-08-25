From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 00/10] Add RoCE support to the mlx5 driver
Date: Tue, 25 Aug 2015 11:35:14 +0300
Message-ID: <55DC28C2.4020705@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
 <55DB8152.6080402@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55DB8152.6080402-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/24/2015 11:40 PM, Tom Talpey wrote:
> On 8/20/2015 12:46 PM, Achiad Shochat wrote:
>> Hi Doug,
>>
>> This patchset adds RoCE V1 and RoCE V2 support to the mlx5 device
>> driver.
>
> Question - assuming I read them correctly, these patches add the
> RoCE v1 and RoCE v2 support on a per-port basis. That is, a port
> can be either IB, RoCE v1 or RoCE v2, but not a combination.
>
> Has any thought been put toward supporting these protocols on a
> per-QP basis, i.e. the caller of rdma_connect() can specify the
> desired protocol? Or to have some sort of discovery?
>
> I know that there may be implementation restrictions on today's
> devices, but it's my personal belief that future devices will
> support multiple protocols (perhaps beyond the three above), and
> laying the groundwork for this today will be important.
>
> Tom.
>
>>
>> This patchset was applied and tested over patchset "Add RoCE v2
>> support" which was sent to the mailing list by Matan Barak.
>>
>> Achiad Shochat (10):
>>    IB/mlx5: Support IB device's callback for getting the link layer
>>    IB/mlx5: Support IB device's callback for getting its netdev
>>    net/mlx5_core: Break down the vport mac address query function
>>    net/mlx5_core: Introduce access functions to enable/disable RoCE
>>    net/mlx5_core: Introduce access functions to query vport RoCE fields
>>    IB/mlx5: Extend query_device/port to support RoCE
>>    IB/mlx5: Set network_hdr_type upon RoCE responder completion
>>    IB/mlx5: Support IB device's callbacks for adding/deleting GIDs
>>    IB/mlx5: Add RoCE fields to Address Vector
>>    IB/mlx5: Support RoCE
>>
>>   drivers/infiniband/hw/mlx5/ah.c                 |  32 ++-
>>   drivers/infiniband/hw/mlx5/cq.c                 |  17 ++
>>   drivers/infiniband/hw/mlx5/main.c               | 318
>> ++++++++++++++++++++++--
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h            |  15 +-
>>   drivers/infiniband/hw/mlx5/qp.c                 |  42 +++-
>>   drivers/net/ethernet/mellanox/mlx5/core/vport.c | 139 ++++++++++-
>>   include/linux/mlx5/device.h                     |  26 ++
>>   include/linux/mlx5/driver.h                     |   7 -
>>   include/linux/mlx5/mlx5_ifc.h                   |  10 +-
>>   include/linux/mlx5/qp.h                         |  21 +-
>>   include/linux/mlx5/vport.h                      |   8 +
>>   11 files changed, 578 insertions(+), 57 deletions(-)
>>
>

Hello Tom,

RoCE v1 and RoCE v2 are supported on a per-GID basis, not sure what got 
you to understand it is per-port.

Achiad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
