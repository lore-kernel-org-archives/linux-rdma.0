Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929562;
	b=pSDQ2KDNJi20ZCh7XFGWGFfoqgOdBKGfpK0RkdTkJ8jZ0zKRjM4U0OyZaxTbZNUoUPn6
	 kb9uPE6CC/Xui9TPWNULDBlthJ67eoYvLSrVWfHoM7YL5pqR1b01WGK2xYZYJYtklexoq
	 ECpXJ8Pewug015oHPF5JHrTf3ZjchSRWvnWoKbcN04Ta2+vI1fTNw453AIEA80Usu/Odf
	 ZmAscLRPnVTPgp+o9hYm5VMu76x9alo+CgmC0JYcXP3bh0zOiIwiNM4QVT95cDhcF/apY
	 6/d3uhMhJRXaFypxzqrf1CR51RecnJ7dfdYi4gt9Fc/2XxrMJSNPt6yjQVm18QB/9bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929562;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:Content-Language:To:CC:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=7SkVw0RFH0VVqDnrmy5F8xRg/V0orPRWS61lowUiSXQ=;
	b=isZuaPs8BjOlIYJK8MSc1SeEDlSuIODM67SgCvCL2Ri+iosLOuA7H/6at1OlB11/Rrhz
	 N0JNhABfM/WkI3tZsj92LNg09TPcvVGuMEJpoGUXngZTYpr8NrhmsD9S9lx0ScHeXIw+E
	 305A6JYDfPZnOX2qhek6I5WO3evPFP6nqSPdzWxQQi6m13/6jnnOZcPiFWnPSaV1OGfrs
	 Sd1S/nLGuTLZ+5o+JwRsEZOrFt/A/jjNDG7y56T5g7dOY9nLzsGIzL+kB/kXat8L+dqyr
	 li1QTq3W/PiRjOQN/laDAmtXIj2g4+1YsS1493XumxWuTewb0lEyXk/ZXuoeBdyRmmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hisilicon.com;
	spf=pass smtp.mailfrom=hisilicon.com;
	arc=none smtp.remote-ip=113.46.200.227
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7360C606A31B
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 01:46:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7360C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jLMTD0XcYznTWX;
	Fri,  6 Nov 2026 09:45:52 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id EDFB74056C;
	Fri,  6 Nov 2026 09:45:49 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 6 Nov 2026 09:45:48 +0800
Message-ID: <515a4612-dea9-9603-1918-a9e6b1ca5430@hisilicon.com>
Date: Fri, 6 Nov 2026 09:45:47 +0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: A question about FAILOVER event in RoCE LAG
Content-Language: en-US
To: Mark Bloch <mbloch@nvidia.com>, Or Gerlitz <gerlitz.or@gmail.com>, Leon
 Romanovsky <leon@kernel.org>
CC: Mark Bloch <markb@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, <ogerlitz@ddn.com>
References: <26b0d23202814f60b994ce123830353d@hisilicon.com>
 <Y/tWPpJNz3EHtMgB@unreal> <afd9c082-db31-da9e-8cc9-44410d110ccf@nvidia.com>
 <CAJ3xEMjHf89E1FaC_+AQcQv_x8sm2T7Qo3_QOgGTgKs3kbT2UQ@mail.gmail.com>
 <2c617198-e394-4c4c-be59-77d8ba14e844@nvidia.com>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <2c617198-e394-4c4c-be59-77d8ba14e844@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/11/5 15:57, Mark Bloch wrote:
> 
> 
> On 03/11/2026 17:54, Or Gerlitz wrote:
>> On Sun, Feb 26, 2023 at 4:46 PM Mark Bloch <mbloch@nvidia.com> wrote:
>>> On 26/02/2023 14:53, Leon Romanovsky wrote:
>>>> On Fri, Feb 24, 2023 at 11:14:47AM +0000, huangjunxian (C) wrote:
>>
>>>>> We've been working on LAG in hns RoCE driver, and we notice that when a FAILOVER event
>>>>> occurs in active-backup mode, all GIDs of the RDMA bond device are deleted and new GIDs
>>>>> are added, triggered by the event handler listed below.
>>
>>>>> So, when a FAILOVER event occurs on a RDMA bond device with running traffic, does it make
>>>>> sense that the traffic is terminated since its GIDs are deleted?
>>
>>> Yep, please read the original commit message:
>>>
>>> commit 238fdf48f2b54a01cedb5774c3a1e81c94e1a3a0
>>> Author: Matan Barak <matanb@mellanox.com>
>>> Date:   Thu Jul 30 18:33:27 2015 +0300
>>>
>>>     IB/core: Add RoCE table bonding support
>>>
>>>     Handling bonding and other devices require us to all all GIDs of the
>>>     net-devices which are upper-devices of the RoCE port related
>>>     net-device.
>>>
>>>     Active-backup configurations imposes even more challenges as the
>>>     default GID should only be set on the active devices (this is
>>>     necessary as otherwise the same MAC could be used for several
>>>     slaves and thus several slaves will have identical GIDs).
>>>
>>>     Managing these configurations are done by listening to:
>>>     (a) NETDEV_CHANGEUPPER event
>>>             (1) if a related net-device is linked, delete all inactive
>>>                 slaves default GIDs and add the upper device GIDs.
>>>             (2) if a related net-device is unlinked, delete all upper GIDs
>>>                 and add the default GIDs.
>>>     (b) NETDEV_BONDING_FAILOVER:
>>>             (1) delete the bond GIDs from inactive slaves
>>>             (2) delete the inactive slave's default GIDs
>>>             (3) Add the bond GIDs to the active slave.
>>
>> Hi Mark and team,
>>
>> (using modern & PC language of child devices)
>>
>> So I believe that the generic code which is pointed out in this reply
>> has to do with the general case
>> of applying bonding over two RoCE enabled netdevs (delete gid in child
>> A, add GID to child B).
>>
>> Wheres the special case of RoCE LAG - namely the mlx5 feature which
>> comes into play when
>> you bond two mlx5 Eth devices belonging to two ports of the same NIC
>> is slightly different - b/c
>> the two associated rdma devices are deleted and a bonded rdma device is born.
>>
>> In that case, we saw this week that the connection breaks, likely b/c
>> of the GID add/delete
>> thing etc and for no reason user-experience wise - the user sees one
>> rdma device the device has
>> two rdma links below the cover, one is still functional, why break?
>>
>> Indeed for LACP mode the session doesn't break.
>>
>> Can some enhancement or fix be applied here to make it work also for
>> active-passive?
>>
>> Or.
> 
> There might something we can do, can you please try the patch bellow?
> it assumes fail_over_mac=none is used with your bond device.

I tested this patch on our hns RoCE bond device (with an enablement
of the new core_cap_flag in hns driver) and it works well.

If you're going to send a formal patch, feel free to add:
Tested-by: Junxian Huang <huangjunxian6@hisilicon.com>

Thanks,
Junxian

> 
> [PATCH RFC POC] RDMA: Preserve fixed-MAC bond GIDs across failover
> 
> A provider supporting bonding failover can redirect existing QPs to the
> active physical port without replacing their GIDs. Deleting bond-owned
> GIDs on failover clears their hardware entries while live QPs still hold
> their indices.
> 
> Add a per-port capability, advertised by mlx5 RoCE LAG at registration.
> For active-backup bonds using fail_over_mac=none, skip the failover GID
> purge and allow bond/VLAN address events through either associated
> child.
> 
> Keep address-change, address-deletion and unlink handling in place.
> Policies active/follow and providers without the capability retain the
> existing behavior. mlx5 still removes old-child GIDs and updates its
> hardware LAG mapping through the existing paths.
> 
> fail_over_mac=none must be set for this.
> 
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> ---
> diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
> index 4a2a4638b476..3fa7d5b499e5 100644
> --- a/drivers/infiniband/core/roce_gid_mgmt.c
> +++ b/drivers/infiniband/core/roce_gid_mgmt.c
> @@ -141,6 +141,22 @@ static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_de
>         return BONDING_SLAVE_STATE_NA;
>  }
> 
> +static bool bond_preserves_gids(struct ib_device *ib_dev, u32 port,
> +                               struct net_device *ndev)
> +{
> +       const struct ib_port_immutable *immutable;
> +       struct bonding *bond;
> +
> +       immutable = ib_port_immutable_read(ib_dev, port);
> +       if (!(immutable->core_cap_flags & RDMA_CORE_CAP_BONDING_FAILOVER) ||
> +           !netif_is_bond_master(ndev))
> +               return false;
> +
> +       bond = netdev_priv(ndev);
> +       return READ_ONCE(bond->params.mode) == BOND_MODE_ACTIVEBACKUP &&
> +              READ_ONCE(bond->params.fail_over_mac) == BOND_FOM_NONE;
> +}
> +
>  #define REQUIRED_BOND_STATES           (BONDING_SLAVE_STATE_ACTIVE |   \
>                                          BONDING_SLAVE_STATE_NA)
>  static bool
> @@ -159,8 +175,9 @@ is_eth_port_of_netdev_filter(struct ib_device *ib_dev, u32 port,
>                 real_dev = cookie;
> 
>         res = ((rdma_is_upper_dev_rcu(rdma_ndev, cookie) &&
> -              (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
> -               REQUIRED_BOND_STATES)) ||
> +              (bond_preserves_gids(ib_dev, port, real_dev) ||
> +               (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
> +                REQUIRED_BOND_STATES))) ||
>                real_dev == rdma_ndev);
> 
>         rcu_read_unlock();
> @@ -248,6 +265,18 @@ static bool upper_device_filter(struct ib_device *ib_dev, u32 port,
>         return res;
>  }
> 
> +static bool bonding_failover_filter(struct ib_device *ib_dev, u32 port,
> +                                   struct net_device *rdma_ndev, void *cookie)
> +{
> +       /*
> +        * The provider remaps existing QPs without changing the bond's GIDs.
> +        * Either child may still be associated with the RDMA port: do not
> +        * depend on the provider having processed the failover notification.
> +        */
> +       return upper_device_filter(ib_dev, port, rdma_ndev, cookie) &&
> +              !bond_preserves_gids(ib_dev, port, cookie);
> +}
> +
>  /**
>   * is_upper_ndev_bond_master_filter - Check if a given netdevice
>   * is bond master device of netdevice of the RDMA device of port.
> @@ -771,7 +800,7 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
>                                 .filter = is_eth_port_of_netdev_filter
>                         };
>         static const struct netdev_event_work_cmd bonding_event_ips_del_cmd = {
> -               .cb = del_netdev_upper_ips, .filter = upper_device_filter};
> +               .cb = del_netdev_upper_ips, .filter = bonding_failover_filter};
>         struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
>         struct netdev_event_work_cmd cmds[ROCE_NETDEV_CALLBACK_SZ] = { {NULL} };
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 4e5180e097c6..28b1c4debde9 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3537,6 +3537,8 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
>         immutable->pkey_tbl_len = attr.pkey_tbl_len;
>         immutable->gid_tbl_len = attr.gid_tbl_len;
>         immutable->core_cap_flags = get_core_cap_flags(ibdev, &rep);
> +       if (mlx5_lag_is_roce(dev->mdev))
> +               immutable->core_cap_flags |= RDMA_CORE_CAP_BONDING_FAILOVER;
>         immutable->max_mad_size = IB_MGMT_MAD_SIZE;
> 
>         return 0;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index cb3b6163961b..cb9e52b8ffbc 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -650,6 +650,8 @@ void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
>  #define RDMA_CORE_CAP_IW_CM             0x00000008
>  #define RDMA_CORE_CAP_IB_SA             0x00000010
>  #define RDMA_CORE_CAP_OPA_MAD           0x00000020
> +/* Existing QPs can switch bond members without replacing their GIDs. */
> +#define RDMA_CORE_CAP_BONDING_FAILOVER  0x00000040
> 
>  /* Address format                       0x000FF000 */
>  #define RDMA_CORE_CAP_AF_IB             0x00001000
> 
> 
>>
>>> and please read: https://wiki.linuxfoundation.org/networking/bonding
>>> especially the section that explains some of the restrictions of
>>> active-backup mode.
>>>
> 
> 
