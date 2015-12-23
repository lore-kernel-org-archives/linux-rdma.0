From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 00/10] Add RoCE support to the mlx5 driver
Date: Wed, 23 Dec 2015 18:36:53 +0200
Message-ID: <CAAKD3BBiUhJ7OjJwAPPzscn6PAEh=hGP8WSzt+rxQNN-Dx49Kg@mail.gmail.com>
References: <1450876674-21695-1-git-send-email-matanb@mellanox.com>
	<567AC6C3.5070102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567AC6C3.5070102-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 23, 2015 at 6:07 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 12/23/2015 08:17 AM, Matan Barak wrote:
>> Hi Doug,
>>
>> This patchset adds RoCE V1 and RoCE V2 support to the mlx5 device
>> driver.
>>
>> This patchset was applied and tested over the third version of
>> "Add RoCE v2 support".
>>
>> Regards,
>> Achiad
>>
>> Changes from V0:
>>  - Fixed using rwlock before initializing it.
>>  - Rebased over Doug's k.o/for-4.5 branch.
>>
>> Achiad Shochat (10):
>>   IB/mlx5: Support IB device's callback for getting the link layer
>>   IB/mlx5: Support IB device's callback for getting its netdev
>>   net/mlx5_core: Break down the vport mac address query function
>>   net/mlx5_core: Introduce access functions to enable/disable RoCE
>>   net/mlx5_core: Introduce access functions to query vport RoCE fields
>>   IB/mlx5: Extend query_device/port to support RoCE
>>   IB/mlx5: Set network_hdr_type upon RoCE responder completion
>>   IB/mlx5: Support IB device's callbacks for adding/deleting GIDs
>>   IB/mlx5: Add RoCE fields to Address Vector
>>   IB/mlx5: Support RoCE
>>
>>  drivers/infiniband/hw/mlx5/ah.c                 |  32 ++-
>>  drivers/infiniband/hw/mlx5/cq.c                 |  17 ++
>>  drivers/infiniband/hw/mlx5/main.c               | 318 ++++++++++++++++++++++--
>>  drivers/infiniband/hw/mlx5/mlx5_ib.h            |  15 +-
>>  drivers/infiniband/hw/mlx5/qp.c                 |  42 +++-
>>  drivers/net/ethernet/mellanox/mlx5/core/vport.c | 139 ++++++++++-
>>  include/linux/mlx5/device.h                     |  26 ++
>>  include/linux/mlx5/driver.h                     |   7 -
>>  include/linux/mlx5/mlx5_ifc.h                   |  10 +-
>>  include/linux/mlx5/qp.h                         |  21 +-
>>  include/linux/mlx5/vport.h                      |   8 +
>>  11 files changed, 578 insertions(+), 57 deletions(-)
>>
>
> This series doesn't apply to my tree even after the GID table lock
> series and the RoCEv2-V3 series.  I'm guessing you have some other mlx5
> specific series in your tree?
>

Strange.... I'll respin them over your k.o/for-4.4-rc tree + the
required patches. Ok?

> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
