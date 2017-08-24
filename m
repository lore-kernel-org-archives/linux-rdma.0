From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-next v1 REPOST 00/10] Hardware tag matching
 support
Date: Thu, 24 Aug 2017 16:53:50 -0400
Message-ID: <1503608030.78641.57.camel@redhat.com>
References: <20170817125212.3173-1-leon@kernel.org>
         <1503604595.78641.39.camel@redhat.com>
         <1503605434.78641.41.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503605434.78641.41.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-24 at 16:10 -0400, Doug Ledford wrote:
> On Thu, 2017-08-24 at 15:56 -0400, Doug Ledford wrote:
> > On Thu, 2017-08-17 at 15:52 +0300, Leon Romanovsky wrote:
> > > This patch series adds to Mellanox ConnectX HCA driver support of
> > > tag matching. It introduces new hardware object eXtended shared
> > > Receive
> > > Queue (XRQ), which follows SRQ semantics with addition of
> > > extended
> > > receive buffers topologies and offloads.
> > > 
> > > This series adds tag matching topology and rendezvouz offload.
> > > 
> > > Changelog:
> > > v0->v1:
> > >  * Rebased version, no change
> > > RFC->v0:
> > >  * Followed after RFC posted on the ML and OFVWG discussions
> > >  * Implements agreed verbs interface
> > >  * Rebased on top of latest version
> > >  * Adding feature description under Documentaion/infiniband
> > >  * In struct ib_srq_init_attr moved CQ outside XRC inner struct.
> > >  * Added max size of the information passed after the RNDV header
> > >  * Added hca_sq_owner HW flag for RNDV QPs
> > > 
> > > Thanks
> > 
> > I know in the previous thread on this submission that you thought
> > it
> > didn't need the shared pull request, but I'm seeing this when I try
> > to
> > build after pulling this patch series in:
> > In file included from ./include/linux/mlx5/driver.h:49:0,
> >                  from ./include/linux/mlx5/fs.h:36,
> >                  from drivers/infiniband/hw/mlx5/qp.c:37:
> > drivers/infiniband/hw/mlx5/qp.c: In function ‘create_qp_common’:
> > drivers/infiniband/hw/mlx5/qp.c:1734:6: error:
> > ‘MLX5_QPC_OFFLOAD_TYPE_RNDV’ undeclared (first use in this
> > function);
> > did you mean ‘MLX5_XRQC_OFFLOAD_RNDV’?
> >       MLX5_QPC_OFFLOAD_TYPE_RNDV);
> 
> Nevermind.  This is an ordering issue.  I took this before your 24
> patch series and I think that is the source of the problem.

Nope, that didn't fix it either.  Maybe it needs one of your other
patchsets?  I also tried it on the shared code base an it fails to
build there in the same way.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
