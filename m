From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH V4] mlx4_core: allocate ICM memory in page size chunks
Date: Thu, 31 May 2018 11:10:22 +0200
Message-ID: <20180531091022.GL15278@dhcp22.suse.cz>
References: <20180523232246.20445-1-qing.huang@oracle.com>
 <20180525.102321.858995452200286788.davem@davemloft.net>
 <7a353b65-6b7f-1aee-1c48-e83c8e02f693@gmail.com>
 <0e11e0fc-6ccf-aa93-9c4f-b9eae1b90643@gmail.com>
 <cdf0d1a9-378a-8b09-544e-a4918acb57fe@gmail.com>
 <20180531065405.GH15278@dhcp22.suse.cz>
 <ae114f01-4b09-bb1c-fb92-6152486a896f@gmail.com>
 <20180531085532.GK15278@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531085532.GK15278@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, qing.huang@oracle.com, tariqt@mellanox.com, haakon.bugge@oracle.com, yanjun.zhu@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com
List-Id: linux-rdma@vger.kernel.org

On Thu 31-05-18 10:55:32, Michal Hocko wrote:
> On Thu 31-05-18 04:35:31, Eric Dumazet wrote:
[...]
> > I merely copied/pasted from alloc_skb_with_frags() :/
> 
> I will have a look at it. Thanks!

OK, so this is an example of an incremental development ;).

__GFP_NORETRY was added by ed98df3361f0 ("net: use __GFP_NORETRY for
high order allocations") to prevent from OOM killer. Yet this was
not enough because fb05e7a89f50 ("net: don't wait for order-3 page
allocation") didn't want an excessive reclaim for non-costly orders
so it made it completely NOWAIT while it preserved __GFP_NORETRY in
place which is now redundant. Should I send a patch?

-- 
Michal Hocko
SUSE Labs
