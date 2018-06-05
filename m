From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH V4] mlx4_core: allocate ICM memory in page size chunks
Date: Tue, 5 Jun 2018 10:32:41 +0200
Message-ID: <20180605083241.GU19202@dhcp22.suse.cz>
References: <20180525.102321.858995452200286788.davem@davemloft.net>
 <7a353b65-6b7f-1aee-1c48-e83c8e02f693@gmail.com>
 <0e11e0fc-6ccf-aa93-9c4f-b9eae1b90643@gmail.com>
 <cdf0d1a9-378a-8b09-544e-a4918acb57fe@gmail.com>
 <20180531065405.GH15278@dhcp22.suse.cz>
 <ae114f01-4b09-bb1c-fb92-6152486a896f@gmail.com>
 <20180531085532.GK15278@dhcp22.suse.cz>
 <20180531091022.GL15278@dhcp22.suse.cz>
 <20180604131104.GS19202@dhcp22.suse.cz>
 <1908601f-2eda-d739-9c4d-430a002b1a05@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1908601f-2eda-d739-9c4d-430a002b1a05@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, qing.huang@oracle.com, tariqt@mellanox.com, haakon.bugge@oracle.com, yanjun.zhu@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com
List-Id: linux-rdma@vger.kernel.org

On Mon 04-06-18 06:22:26, Eric Dumazet wrote:
> 
> 
> On 06/04/2018 06:11 AM, Michal Hocko wrote:
> > On Thu 31-05-18 11:10:22, Michal Hocko wrote:
> 
> > Just in case you are interested
> > ---
> > From 5010543ed6f73e4c00367801486dca8d5c63b2ce Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.com>
> > Date: Mon, 4 Jun 2018 15:07:37 +0200
> > Subject: [PATCH] net: cleanup gfp mask in alloc_skb_with_frags
> > 
> > alloc_skb_with_frags uses __GFP_NORETRY for non-sleeping allocations
> > which is just a noop and a little bit confusing.
> > 
> > __GFP_NORETRY was added by ed98df3361f0 ("net: use __GFP_NORETRY for
> > high order allocations") to prevent from the OOM killer. Yet this was
> > not enough because fb05e7a89f50 ("net: don't wait for order-3 page
> > allocation") didn't want an excessive reclaim for non-costly orders
> > so it made it completely NOWAIT while it preserved __GFP_NORETRY in
> > place which is now redundant.
> > 
> > Drop the pointless __GFP_NORETRY because this function is used as
> > copy&paste source for other places.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > ---
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks! What is the proper process now? Should I resend or somebody can
pick it up from this thread?
-- 
Michal Hocko
SUSE Labs
