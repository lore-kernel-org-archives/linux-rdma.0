From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Exposing a new mini-CQE format
Date: Tue, 29 May 2018 15:35:43 -0600
Message-ID: <20180529213543.GP18442@mellanox.com>
References: <20180527104234.17261-1-leon@kernel.org>
 <20180527104234.17261-2-leon@kernel.org>
 <7aba104bb1313c1cda01baae2ff8495d5623f4b1.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7aba104bb1313c1cda01baae2ff8495d5623f4b1.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "leon@kernel.org" <leon@kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, Yonatan Cohen <yonatanc@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Guy Levi(SW)" <guyle@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 29, 2018 at 03:01:27PM -0600, Saeed Mahameed wrote:
> On Sun, 2018-05-27 at 13:42 +0300, Leon Romanovsky wrote:
> > From: Yonatan Cohen <yonatanc@mellanox.com>
> > 
> > The new mini-CQE format includes byte-count, checksum
> > and stride index.
> > 
> > Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
> > Reviewed-by: Guy Levi <guyle@mellanox.com>
> > Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> 
> 
> Applied to mlx5-next.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git  mlx5-
> next
> 
> commit-id: ab741b2eed3e456cebd2240d4c9c6be003d5ae72

Thanks, everything is now merged as:

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/jgg-for-next&id=f3ca0ab114e0de3bbad4c4a537d32fb57aa42f81

Jason
