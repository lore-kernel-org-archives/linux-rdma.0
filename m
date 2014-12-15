From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH ] mlx4_core: Enhance device capabilities flags debug printouts
Date: Mon, 15 Dec 2014 11:35:52 +0200
Message-ID: <CAJ3xEMght7jLakWzDOHvqTT_gNSqJJHAjLu_F6gD0j+=Narqmg@mail.gmail.com>
References: <1417996112-19060-1-git-send-email-yuval.shaia@oracle.com>
	<54881BFF.2030008@mellanox.com>
	<20141215092153.GF2806@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141215092153.GF2806@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 15, 2014 at 11:21 AM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Dec 10, 2014 at 12:10:07PM +0200, Matan Barak wrote:
>>
>>
>> On 12/8/2014 1:48 AM, Yuval Shaia wrote:
>> >1. Add indication whether feature is supported or not.
>> >2. Add descriptions of all features.
>> >Without this fix there is no way to tell if feature is not supported or that description is not exist.
>> >
>> >Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> >---
>> >  drivers/net/ethernet/mellanox/mlx4/fw.c |   37 +++++++++++++++++++++++++++---
>> >  1 files changed, 33 insertions(+), 4 deletions(-)
>> >
>> >diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
>> >index 2e88a23..79ab326 100644
>> >--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
>> >+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
>> >@@ -91,7 +91,10 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
>> >                 [ 8] =P_Key violation counter",
>> >                 [ 9] =Q_Key violation counter",
>> >                 [10] =VMM",
>> >+               [11] =Fibre Channel Protocol On Ethernet Ports support",
>> >                 [12] =Dual Port Different Protocol (DPDP) support",
>> >+               [13] =Raw Ethertype support",
>> >+               [14] =Raw IPv6 support",
>> >                 [15] =Big LSO headers",
>> >                 [16] =MW support",
>> >                 [17] =APM support",
>> >@@ -99,16 +102,40 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
>> >                 [19] =Raw multicast support",
>> >                 [20] =Address vector port checking support",
>> >                 [21] =UD multicast support",
>> >+               [22] =UD IPv4 Multicast support",
>> >                 [24] =Demand paging support",
>> >                 [25] =Router support",
>> >+               [26] =L2 Ethernet Multicast support",
>> >+               [28] =Software parsing support for UD transport",
>> >+               [29] =TCP checksum off-load support",
>> >                 [30] =IBoE support",
>> >+               [31] =FCoE T11 frame format support",
>> >                 [32] =Unicast loopback support",
>> >+               [33] =Multicast loopback support",
>> >                 [34] =FCS header control",
>> >+               [35] =Address Path ud_force_mgid support",
>> >+               [36] =Header-Data Split support",
>> >+               [37] =Wake On LAN support on port 1",
>> >+               [38] =Wake On LAN support on port 2",
>> >+               [39] =Fatal Warning Event upon a thermal warning condition",
>> >                 [38] =Wake On LAN support",
>> >                 [40] =UDP RSS support",
>> >                 [41] =Unicast VEP steering support",
>> >                 [42] =Multicast VEP steering support",
>> >+               [43] =VLAN Steering mechanism support",
>> >+               [44] =Steering according to EtherType support",
>> >+               [45] =WQE format version 1 support",
>> >+               [46] =Keep Alive Validiation support",
>> >+               [47] =PTP1588 support",
>> >                 [48] =Counters support",
>> >+               [49] =Advanced Counters support",
>> >+               [50] =Force Ethernet user priority from QPC support",
>> >+               [51] =RX Port Num check disabled",
>> >+               [52] =RSS on fragmented IP datagram support",
>>
>> Hi,
>>
>> Except for Or's comments, [55] exists twice. Furthermore, please
>> move [56]-[57] to be after [55] =Port link type sensing support".
> Thanks,
> Will send a revise patch soon.
> By accepting this patch it is agreed that function will dump device capabilities flag and not the combination of dev & driver capabilities.
> (as the name suggest)

NO, as Matan wrote you "except for Or's comments" - we do want to dump
what is supported by both the device (firmware) and the driver, and
not more. A subset of your patch can be used, let me know if you want
me to prepare it.

Or.

>>
>> >+               [55] =Link Sensing support",
>> >+               [56] =Reliable Multicast support",
>> >+               [57] =Fast Drop support",
>> >+               [58] =Protected FMR support",
>> >                 [53] =Port ETS Scheduler support",
>> >                 [55] =Port link type sensing support",
>> >                 [59] =Port management change event support",
>> >@@ -119,8 +146,9 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
>> >
>> >         mlx4_dbg(dev, "DEV_CAP flags:\n");
>> >         for (i =; i < ARRAY_SIZE(fname); ++i)
>> >-               if (fname[i] && (flags & (1LL << i)))
>> >-                       mlx4_dbg(dev, "    %s\n", fname[i]);
>> >+               if (fname[i])
>> >+                       mlx4_dbg(dev, "    (%c) %s\n", (flags & (1LL << i)) ?
>> >+                                '*' : ' ', fname[i]);
>> >  }
>>
>> I think that the strings should be displayed only if both driver and
>> FW supports them. You could add a QUERY_DEV_CAP_SUPPORTED_FLAGS
>> which ors all the supported flags in device.h and check if (flags &
>> QUERY_DEV_CAP_SUPPORTED_FLAGS) & (1LL << i)).
>>
>> >
>> >  static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
>> >@@ -144,8 +172,9 @@ static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
>> >         int i;
>> >
>> >         for (i =; i < ARRAY_SIZE(fname); ++i)
>> >-               if (fname[i] && (flags & (1LL << i)))
>> >-                       mlx4_dbg(dev, "    %s\n", fname[i]);
>> >+               if (fname[i])
>> >+                       mlx4_dbg(dev, "    (%c) %s\n", (flags & (1LL << i)) ?
>> >+                                '*' : ' ', fname[i]);
>> >  }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
