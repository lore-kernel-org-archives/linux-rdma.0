From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v1 00/15] Flow actions to mutate packets
Date: Wed, 5 Sep 2018 08:14:58 +0300
Message-ID: <20180905051458.GD2977@mtr-leonro.mtl.com>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180904221205.GB3895@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180904221205.GB3895@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 04, 2018 at 04:12:05PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 28, 2018 at 02:18:39PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > >From Mark,
> >
> > This series exposes the ability to create flow actions which can
> > mutate packet headers. We do that by exposing two new verbs:
> >  * modify header - can change existing packet headers. packet
> >  * reformat - can encapsulate or decapsulate a packet.
> >               Once created a flow action must be attached to a steering
> >               rule for it to take effect.
> >
> > The first 10 patches refactor mlx5_core code, rename internal structures
> > to better reflect their operation and export needed functions so the
> > RDMA side can allocate the action.
> >
> > The last 5 patches expose via the IOCTL infrastructure mlx5_ib methods
> > which do the actual allocation of resources and return an handle to the
> > user. A user of this API is expected to know how to work with the
> > device's spec as the input to those function is HW depended.
> >
> > An example usage of the modify header action is routing, A user can
> > create an action which edits the L2 header and decrease the TTL.
> >
> > An example usage of the packet reformat action is VXLAN encap/decap
> > which is done by the HW.
> >
> > Changelog:
> >  v0 -> v1:
> >   * Patch 1: Addressed Saeed's comments and simplified the logic.
> >   * Patch 2: Changed due to changes in patch 1.
> >
> >  Split the 27 patch series into 3, this is the first one
> >  which just lets the user create flow action.
> >  Other than that styling fixes mainly in the RDMA patches
> >  to make sure 80 chars limit isn't exceeded.
> >
> >  RFC -> v0:
> >   * Patch 1 a new patch which refactors the logic
> >     when getting a flow namespace.
> >   * Patch 2 was split into two.
> >   * Patch 3: Fixed a typo in commit message
> >   * Patch 5: Updated commit message
> >   * Patch 7: Updated commit message
> >     Renamed:
> >       - MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID to
> >         MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT
> >       - packet_reformat_id to reformat_id in struct mlx5_flow_act
> >       - packet_reformat_id to encap_id in struct mlx5_esw_flow_attr
> >       - packet_reformat_id to encap_id in struct mlx5e_encap_entry
> >       - PACKET_REFORMAT to REFORMAT when printing trace points
> >   * Patch 9: Updated commit message
> >     Updated function declaration in mlx5_core.h, could of lead
> >     to compile error on bisection.
> >   * Patch 11: Disallow egress rules insertion when in switchdev mode
> >   * Patch 12: A new patch to deal with passing enum values using
> >     the IOCTL infrastructure.
> >   * Patch 13: Use new enum value attribute when passing enum
> >     mlx5_ib_uapi_flow_table_type
> >   * Patch 15: Don't set encap flags on flow tables if in switchdev mode
> >   * Patch 17: Use new enum value attribute when passing enum
> >     mlx5_ib_uapi_flow_table_type and enum
> >     mlx5_ib_uapi_flow_action_packet_reformat_type
> >   * Patch 19: Allow creation of both
> >     MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L3_TUNNEL
> >     and MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L3_TUNNEL_TO_L2
> > packet
> >     reformat actions.
> >   * Patch 20: A new patch which allows attaching packet reformat
> >     actions to flow tables on NIC RX.
> >
> > Thanks
> >
> > Mark Bloch (15):
> >   net/mlx5: Cleanup flow namespace getter switch logic
> >   net/mlx5: Add proper NIC TX steering flow tables support
> >   net/mlx5: Export modify header alloc/dealloc functions
> >   net/mlx5: Add support for more namespaces when allocating modify
> >     header
> >   net/mlx5: Break encap/decap into two separated flow table creation
> >     flags
> >   net/mlx5: Move header encap type to IFC header file
> >   {net, RDMA}/mlx5: Rename encap to reformat packet
> >   net/mlx5: Expose new packet reformat capabilities
> >   net/mlx5: Pass a namespace for packet reformat ID allocation
> >   net/mlx5: Export packet reformat alloc/dealloc functions
> >   RDMA/uverbs: Add UVERBS_ATTR_CONST_IN to the specs language
> >   RDMA/mlx5: Add a new flow action verb - modify header
> >   RDMA/uverbs: Add generic function to fill in flow action object
> >   RDMA/mlx5: Add new flow action verb - packet reformat
> >   RDMA/mlx5: Extend packet reformat verbs
> >
> >  drivers/infiniband/core/uverbs_ioctl.c             |  23 ++
> >  .../infiniband/core/uverbs_std_types_flow_action.c |   7 +-
> >  drivers/infiniband/hw/mlx5/devx.c                  |   6 +-
> >  drivers/infiniband/hw/mlx5/flow.c                  | 301 +++++++++++++++++++++
> >  drivers/infiniband/hw/mlx5/main.c                  |   3 +
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h               |  19 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   8 +-
> >  .../mellanox/mlx5/core/diag/fs_tracepoint.h        |   2 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  51 ++--
> >  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
> >  .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   9 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  87 +++---
> >  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  73 +++--
> >  .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  12 +-
> >  include/linux/mlx5/device.h                        |   6 +
> >  include/linux/mlx5/fs.h                            |  20 +-
> >  include/linux/mlx5/mlx5_ifc.h                      |  70 +++--
> >  include/rdma/uverbs_ioctl.h                        |  40 +++
> >  include/rdma/uverbs_std_types.h                    |  12 +
> >  include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  18 ++
> >  include/uapi/rdma/mlx5_user_ioctl_verbs.h          |  12 +
> >  21 files changed, 638 insertions(+), 143 deletions(-)
>
> This looks OK to me, can you make the shared commit please?

Thanks, I pushed to mlx5-next

50acec06f392 net/mlx5: Export packet reformat alloc/dealloc functions
31ca3648f01b net/mlx5: Pass a namespace for packet reformat ID allocation
bea4e1f6c6c5 net/mlx5: Expose new packet reformat capabilities
60786f0987c0 {net, RDMA}/mlx5: Rename encap to reformat packet
e0e7a3861b6c net/mlx5: Move header encap type to IFC header file
61444b458b01 net/mlx5: Break encap/decap into two separated flow table creation flags
c3c062f80665 net/mlx5: Add support for more namespaces when allocating modify header
90c1d1b8da67 net/mlx5: Export modify header alloc/dealloc functions
8ce78257965e net/mlx5: Add proper NIC TX steering flow tables support
2226dcb424bf net/mlx5: Cleanup flow namespace getter switch logic


>
> Thanks,
> Jason

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbj2ZSAAoJEORje4g2clinggIP/3QBoWxQ5FZbo+dAjNspi8E8
go64SgAliwR9g3uZpR1e9ano63ihfFQ5nxavUEINke2xwJ6R8YI+xQkrMtI34Nt9
TAzlDwPxsct8/+JP1evquYxGbfOQuLROrke0AfpxtWts72i+TiAPGzzSmmQS1alr
hqMxbO8x4Ocx3XGjcdJN3fadQmwU08UDBq6XySnx+T09GF1fVhsfFXaNitV2AYKP
NT3/A0VgDAy0WJQdafoY/ZM0O4EaHiTM/yQygvW8F9asCiSNaooC0/A0MKp3eYJ8
33qOKnenuWB0OQdmlw1vUOP6Z4LBDZLbtJa6Avyd+wk/btXdUG8lKxfYKsItiM0o
xvGcQXD2K2myDJ+XePuihpsP4xw+9zvk2lMUUYSx488e3JUMSfuHyqFqP8/aWaH1
78DKhU6shZ/bZSWYFvX+xCKhlPGJLVnm4FzhuVNp3JiMIYrD5QvkqHOGZKy3BY1W
d8RvdrgzJUfbYvZl+oPwYH+aAZHudPQ6VNrOJOvNXD5j9OcQuBIbGdxeyFtKFD/e
IlaD7TBd4kyUpatMQl//VL+Mwl0mE0Vd26tMnf6UaPrJm4E6yphuhxIhowm89HEN
Hwy0mtaWkBwQ5vdh5I3BbQuyLbefYbW4XW67OquiF3/VESXB6hMmDPpQZPwBSlTy
bJvgzzghzphzuJh4Xi9h
=1Wpw
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
