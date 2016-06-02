From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] IB/core: Fix bit curruption in ib_device_cap_flags
 structure
Date: Thu, 2 Jun 2016 10:52:14 -0600
Message-ID: <20160602165214.GB11685@obsidianresearch.com>
References: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: matanb@mellanox.com, leon@leon.nu, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org, robert@leblancnet.us
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 02, 2016 at 12:28:05PM +0300, Max Gurtovoy wrote:
> ib_device_cap_flags 64-bit expansion caused caps overlapping
> and made consumers read wrong device capabilities. For example
> IB_DEVICE_SG_GAPS_REG was falsely read by the iser driver causing
> it to use a non-existing capability. This happened because signed
> int becomes sign extended when converted it to u64. Fix this by
> casting IB_DEVICE_ON_DEMAND_PAGING enumeration to ULL.
> 
> Fixes: fb532d6a79b9 ('IB/{core, ulp} Support above 32 possible device capability flags')
> Reported-by: Robert LeBlanc <robert@leblancnet.us>
> Cc: Stable <stable@vger.kernel.org> #[v4.6+]
> Acked-by: Sagi Grimberg <sagi@grimberg.me>
> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
> Signed-off-by: Matan Barak <matanb@mellanox.com>
>  include/rdma/ib_verbs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
