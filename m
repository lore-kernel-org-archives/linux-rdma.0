From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mlx5: Fix memory leak in mlx5_ib_create_flow
Date: Fri, 8 Jun 2018 17:21:17 -0600
Message-ID: <20180608232117.GF12577@ziepe.ca>
References: <20180607191915.GA9092@embeddedor.com>
 <20180608230835.GA24392@ziepe.ca>
 <809fbf8a-e37d-2e92-cecb-37653e38290c@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <809fbf8a-e37d-2e92-cecb-37653e38290c@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Raed Salem <raeds@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 08, 2018 at 06:11:49PM -0500, Gustavo A. R. Silva wrote:
> 
> >>  	mutex_lock(&dev->flow_db->lock);
> >>@@ -3640,6 +3646,9 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
> >>  	kfree(ucmd);
> >>  	kfree(handler);
> >>  	return ERR_PTR(err);
> >>+free_ucmd:
> >>+	kfree(ucmd);
> >>+	return ERR_PTR(err);
> >>  }
> >
> >This hunk is a bit wonky, can we do this instead? handle never needs
> >to be freed.
> >
> >destroy_ft:
> >	put_flow_table(dev, ft_prio, false);
> >	if (ft_prio_tx)
> >		put_flow_table(dev, ft_prio_tx, false);
> >unlock:
> >	mutex_unlock(&dev->flow_db->lock);
> >	kfree(dst);
> >free_ucmd:
> >	kfree(ucmd);
> >	return ERR_PTR(err);
> >}
> >
> >
> 
> Sure thing. I'll send v2 shortly.

I made the adjustment for you, if it is wrong let me know..

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/jgg-for-rc&id=2cc82dd58712888758c2d2b405d012f2cd580dd7

Jason
