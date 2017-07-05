From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc v1] IB/core, opa_vnic, hfi1, mlx5: Properly free
 rdma_netdev
Date: Wed, 05 Jul 2017 19:31:10 -0400
Message-ID: <1499297470.2783.29.camel@redhat.com>
References: <8e959601996dc645f4ed7004482a1667c27deb39.1499289360.git.dledford@redhat.com>
         <20170705215200.GA85407@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705215200.GA85407-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-07-05 at 14:52 -0700, Vishwanathapura, Niranjana wrote:
> Thanks Doug for updating the patch with the fix.
> 
> > @@ -3550,16 +3555,19 @@ mlx5_ib_alloc_rdma_netdev(struct ib_device
> > *hca,
> > 			  unsigned char name_assign_type,
> > 			  void (*setup)(struct net_device *))
> > {
> > +	struct net_device *netdev;
> > +	struct rdma_netdev *rn;
> > +
> > 	if (type != RDMA_NETDEV_IPOIB)
> > 		return ERR_PTR(-EOPNOTSUPP);
> > 
> > -	return mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
> > -				      name, setup);
> > -}
> > -
> > -static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
> > -{
> > -	return mlx5_rdma_netdev_free(netdev);
> > +	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
> > +					name, setup);
> > +	if (likely(!IS_ERR_OR_NULL(netdev))) {
> > +		rn = netdev_priv(netdev);
> > +		rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;
> > +	}
> 
> Looks like mlx5_rdma_netdev_alloc() always return NULL in case of
> error, hence 
> null check should have been suffecient. But the above check will also
> do, I am 
> fine with this change.

No, at the very beginning of mlx5_rdma_netdev_alloc() it will return
-EOPNOTSUPP if the card doesn't support IPoIB accelerations.  So we
have to support both NULL and an ERR_PTR (and possibly more options in
the future, you never know, the above is future proof).

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
