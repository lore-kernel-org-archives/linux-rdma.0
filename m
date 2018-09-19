From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next 07/25] net/mlx5: Update mlx5_ifc with DEVX UID
 bits
Date: Wed, 19 Sep 2018 11:31:47 -0600
Message-ID: <20180919173147.GO11367@ziepe.ca>
References: <20180917110418.18937-1-leon@kernel.org>
 <20180917110418.18937-8-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917110418.18937-8-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 17, 2018 at 02:04:00PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Add DEVX information to WQ, SRQ, CQ, TRI, TIS, QP,
> RQ, XRCD, PD, MKEY and MCG.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 67 +++++++++++++++++++++++++++----------------
>  1 file changed, 43 insertions(+), 24 deletions(-)

It is weird that we sometimes have these IFC bundle updates and
sometimes the IFC is inlined in the patch.. 

Why not just do one big IFC only patch with everything the series
needs?

Jason
