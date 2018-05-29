From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/3] Introduce new mlx5 CQE format
Date: Tue, 29 May 2018 14:05:15 -0600
Message-ID: <20180529200515.GA26938@ziepe.ca>
References: <20180527104234.17261-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180527104234.17261-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 27, 2018 at 01:42:31PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Introduce new internal to mlx5 CQE format - mini-CQE. It is a CQE in
> compressed form that holds data needed to extra a single full CQE.
> 
> It stride index, byte count and packet checksum.
> 
> Thanks
> 
> Yonatan Cohen (3):
>   net/mlx5: Exposing a new mini-CQE format
>   IB/mlx5: Refactor CQE compression response
>   IB/mlx5: Introduce a new mini-CQE format

Applied to for-next.

Generally taking new uapi patches that are first the list should have
a few weeks of comment period, but since this is just adding a new bit
to an existing driver private api it seems OK to go this merge window.

Thanks,
Jason
