From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/core: Support accessing SA in
 virtualized environment
Date: Tue, 1 Mar 2016 11:32:56 -0700
Message-ID: <20160301183256.GB12495@obsidianresearch.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
 <1456851143-138332-4-git-send-email-eli@mellanox.com>
 <20160301174401.GC25176@obsidianresearch.com>
 <20160301181742.GB19366@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160301181742.GB19366-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 08:17:42PM +0200, Eli Cohen wrote:
> On Tue, Mar 01, 2016 at 10:44:01AM -0700, Jason Gunthorpe wrote:
> > On Tue, Mar 01, 2016 at 06:52:16PM +0200, Eli Cohen wrote:
> > > Per the ongoing standardisation process, when virtual HCAs are present
> > > in a network, traffic is routed based on a destination GID. In order to
> > > access the SA we use the well known SA GID.
> > 
> > Should we be merging patches based on on-going standards work?
> The spec is in a very advanced state so I think it makes sense to
> merge.

How does this interact with the existing SRIOV stuff? It is already
very annoying that mlx5 is incompatible with the old scheme. Is the
proposal to shift all IB to this new scheme, or still keep mlx4/mlx5 with
different approaches?

We can't just have the kernel become incompatible with existing
SMs. Eg opensm only supports the old scheme last I looked.

> > > +		ah_attr.ah_flags = IB_AH_GRH;
> > > +		ah_attr.grh.dgid.global.subnet_prefix = cpu_to_be64(IB_SA_WELL_KNOWN_GID_PREFIX);
> > > +		ah_attr.grh.dgid.global.interface_id = cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
> > 
> > I'm surprised this hard wired to fe80::2 - surely this should use
> > the current subnet prefix? There should be no traffic prefixed with
> > fe80:: if a subnet is configured with another prefix.
> > 
> Hmm... seems like no such thing IB_SA_WELL_KNOWN_GID_PREFIX. The
> subnet prefix is part of the port info but struct ib_port_attr does
> not define a field for the subnet prefix. How do you think it should
> be obtained?

It makes sense to add it to ib_port_attr, the code already has to call
that to get the sm_lid.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
