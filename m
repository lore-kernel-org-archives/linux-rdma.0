From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 3/3] IB/core, opa_vnic, hfi1, mlx5: Properly
 free rdma_netdev
Date: Wed, 05 Jul 2017 17:21:24 -0400
Message-ID: <1499289684.2783.27.camel@redhat.com>
References: <20170630201236.5213.72919.stgit@scvm10.sc.intel.com>
         <20170630201445.5213.82089.stgit@scvm10.sc.intel.com>
         <20170702132340.GD8041@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170702132340.GD8041-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-07-02 at 16:23 +0300, Leon Romanovsky wrote:
> On Fri, Jun 30, 2017 at 01:14:46PM -0700, Dennis Dalessandro wrote:
> > From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuE@public.gmane.org
> > m>
> > 
> > 
> > +	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
> > +					name, setup);
> 
> It can return NULL
> 
> > +	rn = netdev_priv(netdev);
> > +	rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;
> 
> This will crash in such case.

A fixed version of this patch is the last thing I'm waiting on before
sending my final -rc pull request to Linus.  I would skip this, but
since the IPoIB fixes broke things, we need a proper version of this
patch to undo that breakage.  I fixed it up as I saw fit and sent the
fixed version to the list on its own thread, please double check it
before I send it to Linus.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
