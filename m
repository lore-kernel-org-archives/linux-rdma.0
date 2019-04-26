From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH mlx5-next 00/11] Mellanox, mlx5-next updates 2019-04-25
Date: Fri, 26 Apr 2019 16:01:49 -0700
Message-ID: <20190426160149.73d00a6c@cakuba.netronome.com>
References: <20190426215732.29761-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190426215732.29761-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 26 Apr 2019 21:58:02 +0000, Saeed Mahameed wrote:
> Hi,
> 
> This series provides misc low level updates to mlx5 core driver, to be
> shared between rdma and net-next trees.
> 
> 1) From Aya: Enable general events on all physical link types and 
> restrict general event handling of subtype DELAY_DROP_TIMEOUT in mlx5 rdma
> driver to ethernet links only as it was intended.
> 
> 2) From Eli: Introduce low level bits for prio tag mode
> 
> 3) From Maor: Low level steering updates to support RDMA RX flow
> steering and enables RoCE loopback traffic when switchdev is enabled.
> 
> 4) From Vu and Parav: Two small mlx5 core cleanups
> 
> 5) From Yevgeny add HW definitions of geneve offloads
> 
> In case of no objections this series will be applied to mlx5-next
> branch.

I can't really speak to implications of patch 9, but otherwise seems
inoffensive from netdev perspective :)

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
