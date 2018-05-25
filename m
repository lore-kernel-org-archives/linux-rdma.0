From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH V4] mlx4_core: allocate ICM memory in page size chunks
Date: Fri, 25 May 2018 10:23:21 -0400 (EDT)
Message-ID: <20180525.102321.858995452200286788.davem@davemloft.net>
References: <20180523232246.20445-1-qing.huang@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523232246.20445-1-qing.huang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: qing.huang@oracle.com
Cc: tariqt@mellanox.com, haakon.bugge@oracle.com, yanjun.zhu@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com
List-Id: linux-rdma@vger.kernel.org

From: Qing Huang <qing.huang@oracle.com>
Date: Wed, 23 May 2018 16:22:46 -0700

> When a system is under memory presure (high usage with fragments),
> the original 256KB ICM chunk allocations will likely trigger kernel
> memory management to enter slow path doing memory compact/migration
> ops in order to complete high order memory allocations.
> 
> When that happens, user processes calling uverb APIs may get stuck
> for more than 120s easily even though there are a lot of free pages
> in smaller chunks available in the system.
> 
> Syslog:
> ...
> Dec 10 09:04:51 slcc03db02 kernel: [397078.572732] INFO: task
> oracle_205573_e:205573 blocked for more than 120 seconds.
> ...
> 
> With 4KB ICM chunk size on x86_64 arch, the above issue is fixed.
> 
> However in order to support smaller ICM chunk size, we need to fix
> another issue in large size kcalloc allocations.
> 
> E.g.
> Setting log_num_mtt=30 requires 1G mtt entries. With the 4KB ICM chunk
> size, each ICM chunk can only hold 512 mtt entries (8 bytes for each mtt
> entry). So we need a 16MB allocation for a table->icm pointer array to
> hold 2M pointers which can easily cause kcalloc to fail.
> 
> The solution is to use kvzalloc to replace kcalloc which will fall back
> to vmalloc automatically if kmalloc fails.
> 
> Signed-off-by: Qing Huang <qing.huang@oracle.com>
> Acked-by: Daniel Jurgens <danielj@mellanox.com>
> Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied, thanks.
