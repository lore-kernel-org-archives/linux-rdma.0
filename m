From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 0/3] Dump and fill MKEY
Date: Tue, 19 Jun 2018 08:21:06 -0600
Message-ID: <20180619142106.GA27457@mellanox.com>
References: <20180619054724.32677-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180619054724.32677-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 19, 2018 at 08:47:21AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> MLX5 IB HCA offers the memory key, dump_fill_mkey to increase
> performance, when used in a send or receive operations.
> 
> It is used to force local HCA operations to skip the PCI bus access,
> while keeping track of the processed length in the ibv_sge handling.
> 
> In this three patch series, we expose various bits in our HW
> spec file (mlx5_ifc.h), move unneeded for mlx5_core FW command and
> export such memory key to user space thought our mlx5-abi header file.

Where is the user space for this?

Jason
