From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next] net/mlx5: ODP support for XRC transport is not
 enabled by default in FW
Date: Wed, 6 Mar 2019 15:53:33 -0400
Message-ID: <20190306195333.GA24296@ziepe.ca>
References: <20190225065439.821-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190225065439.821-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Moni Shoua <monis@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 25, 2019 at 08:54:39AM +0200, Leon Romanovsky wrote:
> From: Moni Shoua <monis@mellanox.com>
> 
> ODP support for XRC transport is not enabled by default in FW,
> so we need separate ODP checks to enable/disable it.
> 
> While that, rewrite the set of ODP SRQ support capabilities in way
> that tests each field separately for clearness, which is not needed
> for current FW, but better to have it separated.
> 
> Signed-off-by: Moni Shoua <monis@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 38 +++++++++++--------
>  1 file changed, 22 insertions(+), 16 deletions(-)
> 
> --
> 2.19.1

Applied to for-next, thanks

Jason
