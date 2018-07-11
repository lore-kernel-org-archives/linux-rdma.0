From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 4/9] IB/mlx5: Introduce flow steering matcher
 object
Date: Wed, 11 Jul 2018 06:02:31 -0600
Message-ID: <20180711120231.GA23935@ziepe.ca>
References: <20180708102445.25496-1-leon@kernel.org>
 <20180708102445.25496-5-leon@kernel.org>
 <20180710173450.GB8266@ziepe.ca>
 <ba5fca7e-814f-47f0-486e-30b27cd56797@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ba5fca7e-814f-47f0-486e-30b27cd56797@dev.mellanox.co.il>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 11, 2018 at 12:32:56PM +0300, Yishai Hadas wrote:
> >>+static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(struct ib_device *ib_dev,
> >>+				   struct ib_uverbs_file *file,
> >>+				   struct uverbs_attr_bundle *attrs)
> >>+{
> >>+	struct mlx5_ib_dev *dev = to_mdev(ib_dev);
> >
> >I have a patch changing these - when working with uobj's the ib_dev
> >argument should not be used, the ib_dev must come from the ucontext
> >instead.
> >
> 
> OK, V1 will take the ib_dev from the uobj.
> 
> However, does it mean that you are going to change the signatures of all the
> handlers to *not* get ib_dev ?

Yes.

Jason
