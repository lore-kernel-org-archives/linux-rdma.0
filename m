From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH V4] mlx4_core: allocate ICM memory in page size chunks
Date: Thu, 31 May 2018 19:04:46 -0700
Message-ID: <7d8f52e1-aa16-d20c-a9a8-35ad88c0b1ab@oracle.com>
References: <20180523232246.20445-1-qing.huang@oracle.com>
 <20180525.102321.858995452200286788.davem@davemloft.net>
 <7a353b65-6b7f-1aee-1c48-e83c8e02f693@gmail.com>
 <0e11e0fc-6ccf-aa93-9c4f-b9eae1b90643@gmail.com>
 <cdf0d1a9-378a-8b09-544e-a4918acb57fe@gmail.com>
 <20180531065405.GH15278@dhcp22.suse.cz>
 <ae114f01-4b09-bb1c-fb92-6152486a896f@gmail.com>
 <20180531085532.GK15278@dhcp22.suse.cz>
 <20180531091022.GL15278@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180531091022.GL15278@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, tariqt@mellanox.com, haakon.bugge@oracle.com, yanjun.zhu@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com, "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
List-Id: linux-rdma@vger.kernel.org



On 5/31/2018 2:10 AM, Michal Hocko wrote:
> On Thu 31-05-18 10:55:32, Michal Hocko wrote:
>> On Thu 31-05-18 04:35:31, Eric Dumazet wrote:
> [...]
>>> I merely copied/pasted from alloc_skb_with_frags() :/
>> I will have a look at it. Thanks!
> OK, so this is an example of an incremental development ;).
>
> __GFP_NORETRY was added by ed98df3361f0 ("net: use __GFP_NORETRY for
> high order allocations") to prevent from OOM killer. Yet this was
> not enough because fb05e7a89f50 ("net: don't wait for order-3 page
> allocation") didn't want an excessive reclaim for non-costly orders
> so it made it completely NOWAIT while it preserved __GFP_NORETRY in
> place which is now redundant. Should I send a patch?
>

Just curious, how about GFP_ATOMIC flag? Would it work in a similar 
fashion? We experimented
with it a bit in the past but it seemed to cause other issue in our 
tests. :-)

By the way, we didn't encounter any OOM killer events. It seemed that 
the mlx4_alloc_icm() triggered slowpath.
We still had about 2GB free memory while it was highly fragmented.

  #0 [ffff8801f308b380] remove_migration_pte at ffffffff811f0e0b
  #1 [ffff8801f308b3e0] rmap_walk_file at ffffffff811cb890
  #2 [ffff8801f308b440] rmap_walk at ffffffff811cbaf2
  #3 [ffff8801f308b450] remove_migration_ptes at ffffffff811f0db0
  #4 [ffff8801f308b490] __unmap_and_move at ffffffff811f2ea6
  #5 [ffff8801f308b4e0] unmap_and_move at ffffffff811f2fc5
  #6 [ffff8801f308b540] migrate_pages at ffffffff811f3219
  #7 [ffff8801f308b5c0] compact_zone at ffffffff811b707e
  #8 [ffff8801f308b650] compact_zone_order at ffffffff811b735d
  #9 [ffff8801f308b6e0] try_to_compact_pages at ffffffff811b7485
#10 [ffff8801f308b770] __alloc_pages_direct_compact at ffffffff81195f96
#11 [ffff8801f308b7b0] __alloc_pages_slowpath at ffffffff811978a1
#12 [ffff8801f308b890] __alloc_pages_nodemask at ffffffff81197ec1
#13 [ffff8801f308b970] alloc_pages_current at ffffffff811e261f
#14 [ffff8801f308b9e0] mlx4_alloc_icm at ffffffffa01f39b2 [mlx4_core]

Thanks!
