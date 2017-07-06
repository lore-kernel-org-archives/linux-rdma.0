From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc v1] IB/core, opa_vnic, hfi1, mlx5: Properly free
 rdma_netdev
Date: Thu, 06 Jul 2017 09:40:04 -0400
Message-ID: <1499348404.2783.32.camel@redhat.com>
References: <8e959601996dc645f4ed7004482a1667c27deb39.1499289360.git.dledford@redhat.com>
         <20170706042347.GP1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170706042347.GP1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/6/2017 12:23 AM, Leon Romanovsky wrote:
> On Wed, Jul 05, 2017 at 05:17:52PM -0400, Doug Ledford wrote:
> > From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuE@public.gmane.org
> > m>
> > 
> > -static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
> > -{
> > -	return mlx5_rdma_netdev_free(netdev);
> > +	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
> > +					name, setup);
> > +	if (likely(!IS_ERR_OR_NULL(netdev))) {
> > +		rn = netdev_priv(netdev);
> > +		rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;
> > +	}
> > +	return netdev;
> >  }
> 
> 
> Thanks Doug, it looks good enough for the fix.
> 
> In general, the "likely" is not needed here (we are not in data path)

It doesn't hurt though...

> and our preference is to avoid "if(!error) { do something }"
> constructions
> in favor of "if(error) { return ...}" (fail as early as you can).

Normally I would agree with you on that point.  But when you aren't
returning an error code but instead are returning the same thing you
return in the non error case, and when there are so few things to be
done in the non error case, I think this sort of construct becomes more
appealing (mainly because it will more closely match the assembler that
GCC puts out when compiling this code and I think that has value for
those times when you need to debug the object code, but that's just my
personal opinion).

> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
