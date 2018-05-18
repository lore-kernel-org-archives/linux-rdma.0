From: David Miller <davem@davemloft.net>
Subject: Re: [pull request][for-next 00/15] Mellanox, mlx5 core and netdev
 updates 2018-05-17
Date: Fri, 18 May 2018 13:03:51 -0400 (EDT)
Message-ID: <20180518.130351.456975805564832525.davem@davemloft.net>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: dledford@redhat.com, jgg@mellanox.com, leonro@mellanox.com, ogerlitz@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 17 May 2018 18:22:43 -0700

> Below you can find two pull requests,
> 
> 1. mlx5 core updates to be shared for both netdev and RDMA, (patches 1..9)
>  which is based on the last mlx5-next pull request
>  
> The following changes since commit a8408f4e6db775e245f20edf12b13fd58cc03a1c:
> 
>   net/mlx5: fix spelling mistake: "modfiy" -> "modify" (2018-05-04 12:11:51 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-updates-2018-05-17
> 
> for you to fetch changes up to 10ff5359f883412728ba816046ee3a696625ca02:
> 
>   net/mlx5e: Explicitly set source e-switch in offloaded TC rules (2018-05-17 14:17:35 -0700)
> 
> 2. mlx5e netdev updates only for net-next branch (patches 10..15) based on net-next
> and the above pull request.
> 
> The following changes since commit 538e2de104cfb4ef1acb35af42427bff42adbe4d:
> 
>   Merge branch 'net-Allow-more-drivers-with-COMPILE_TEST' (2018-05-17 17:11:07 -0400)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5e-updates-2018-05-17
> 
> for you to fetch changes up to a228060a7c9ab88597eeac131e4578595d5d46ae:
> 
>   net/mlx5e: Add HW vport counters to representor ethtool stats (2018-05-17 17:48:54 -0700)
> 
> Dave, for your convenience you can either pull 1. and then 2. or pull 2.
> directly.

Looks good.

I pulled 1 then I pulled 2.  That seemed to work well.  Particularly
it allowed me to capture the two different merge commit messages one
by one.

Is this basically how you want to handle things moving forward?

Thanks.
