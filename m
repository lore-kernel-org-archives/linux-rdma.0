From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/2] Allocate the per-port Q counter
Date: Fri, 21 Dec 2018 12:12:06 -0700
Message-ID: <20181221191206.GA28409@ziepe.ca>
References: <20181209105236.26233-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181209105236.26233-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 09, 2018 at 12:52:34PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi
> 
> See commit message for the patch description.
> 
> Thanks
> 
> Leon Romanovsky (1):
>   net/mlx5: Add shared Q counter bits
> 
> Yishai Hadas (1):
>   IB/mlx5: Allocate the per-port Q counter shared when DEVX is supported

Applied to for-next

Thanks,
Jason
