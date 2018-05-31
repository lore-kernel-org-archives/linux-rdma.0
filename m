From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH V4] mlx4_core: allocate ICM memory in page size chunks
Date: Thu, 31 May 2018 08:54:05 +0200
Message-ID: <20180531065405.GH15278@dhcp22.suse.cz>
References: <20180523232246.20445-1-qing.huang@oracle.com>
 <20180525.102321.858995452200286788.davem@davemloft.net>
 <7a353b65-6b7f-1aee-1c48-e83c8e02f693@gmail.com>
 <0e11e0fc-6ccf-aa93-9c4f-b9eae1b90643@gmail.com>
 <cdf0d1a9-378a-8b09-544e-a4918acb57fe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cdf0d1a9-378a-8b09-544e-a4918acb57fe@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, qing.huang@oracle.com, tariqt@mellanox.com, haakon.bugge@oracle.com, yanjun.zhu@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com
List-Id: linux-rdma@vger.kernel.org

On Tue 29-05-18 23:49:59, Eric Dumazet wrote:
> 
> 
> On 05/29/2018 11:44 PM, Eric Dumazet wrote:
> 
> > 
> > And I will add this simple fix, this really should address your initial concern much better.
> > 
> > @@ -99,6 +100,8 @@ static int mlx4_alloc_icm_pages(struct scatterlist *mem, int order,
> >  {
> >         struct page *page;
> >  
> > +       if (order)
> > +               gfp_mask |= __GFP_NORETRY;
> 
>     and also      gfp_mask &= ~__GFP_DIRECT_RECLAIM

JFTR the latter one makes __GFP_NORETRY pointless. Non sleeping allocations
are not retrying.

> >         page = alloc_pages_node(node, gfp_mask, order);
> >         if (!page) {
> >                 page = alloc_pages(gfp_mask, order);
> > 

-- 
Michal Hocko
SUSE Labs
