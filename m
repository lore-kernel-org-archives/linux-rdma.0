From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Tue, 4 Apr 2017 23:03:35 +0300
Message-ID: <20170404200335.GB20443@mtr-leonro.local>
References: <20170404191732.31895-1-leon@kernel.org>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8CAA0@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wHmMVWdCgqSO3x88"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67C8CAA0-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--wHmMVWdCgqSO3x88
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2017 at 07:50:21PM +0000, Weiny, Ira wrote:
> >
> > Hi Doug,
> >
> > This patchset mostly comes from Erez with one exception in the first patch.
> >
> > That patch origins from two different commits, first from Niranjana who added
> > RDMA netdev interface and second from Erez who added IPoIB support.
> >
> > During the preparation to submission, I squashed their commits into one and
> > refactored code to allow submission as a standalone topic without creating
> > dependecies between different submissions. This caused to change in author
> > line.
> > I hope that it doesn't really matter and it won't stop you from merging it.
>
> I'm confused by how you expect Niranjana's patch to be merged in this situation?
>
> Doug, will you take care of the conflict between these 2 submitted patches?
>
> [PATCH 02/11] IB/opa-vnic: Virtual Network Interface Controller (VNIC) interface
> And
> [PATCH rdma-next 1/6] IB/IPoIB: Introduce RDMA netdev interface and IPoIB structs

Ira,

The IPoIB and HFI-VNIC are independent series, so topics should be
self-contained. If the merge conflict worries you, Niranjana or me could
easily base our patch sets on another topic, but we need to know
the acceptance (yes/no) and order between them.

Thanks

>
> Ira
>
> >
> > Per-your request, I based this patch set on v4.11-rc3.
> >
> > Thanks,
> > 	Leon
> >
> > CC: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > CC: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >
> > The rest comes from Erez:
> >
> >     The IPoIB protocol encapsulates IP packets over Infiniband datagrams.
> >     As a direct RDMA Upper Layer Protocol (ULP), IPoIB cannot support HW
> >     features that are specific to the IP protocol stack.
> >
> >     Nevertheless, RDMA interfaces have been extended to support some of the
> >     prominent IP offload features, such as TCP/UDP checksum and TSO.
> >     This provided reasonable performance gain for IPoIB but is still
> >     insufficient to cope with the increasing network bandwidth demand.
> >
> >     However, New features are exisiting in common network interfaces that
> >     are very hard to implement in IPoIB interfaces while it uses the RDMA
> >     layer, examples include TSS and RSS, tunneling offloads, and XDP.
> >     Rather than continuously porting IP network interface developments into
> >     the RDMA stack, we propose adding an abstract network data-path
> >     interfaces to RDMA devices.
> >
> >     In order to present a consistent interface to users, the IPoIB ULP
> >     continues to represent the network device to the IP stack.
> >     The common code also manages the IPoIB control plane, such as resolving
> >     path queries and registering to multicast groups.
> >     Data path operations are forwarded to devices that implement the new
> >     API, or fallback to the standard implementation otherwise.
> >     Using the forgoing approach, we show how IPoIB closes the performance
> >     gap compared to state-of-the-art Ethernet network interfaces.
> >
> >     The implementation idea is to use the api of
> >     alloc_rdma_netdev/free_rdma_netdev to expose a struct that has data
> >     members and set of functions that are used for IB network interfaces,
> >     like attach/detach multicast to qp, and send IB packet.
> >
> >     The functions are specific for IB operations and are not part of the
> >     common api the the netdev struct exposes via the ndo functions.
> >     1. multicast handling - attach/detach
> >     2. send operation - the ndo start_xmit has only 2 parameters and the IB
> >     send needs the destination qp and the ah object, there were few options
> >     to handle it via the netdev ndo, but they don't make more sense than
> >     using a specific send function (we are rdma_netdev after all)
> >
> >     The IPoIB code will be adapted to enable the option of accelerating the
> >     network interface, but the code will work as before if the HW below
> >     doesn't support the acceleration.
> >     That means that in the default mode of ipoib I tried to keep it as much
> >     as it was before, not to force it to adopt the new api, where there is
> >     no code sharing between the ipoib and the vnic/hfi.
> >     The default code uses the controll and the data, the accelerator uses
> >     only the control flows andstructors.
> >     The changes of the default ipoib can be made on top of that series.
> >
> >     Each HW vendor can supply the acceleration for the IPoIB or to leave
> >     IPoIB to work as before.
> >
> > Thanks,
> > 	Erez
> >
> > Erez Shitrit (5):
> >   IB/IPoIB: Separate control and data related initializations
> >   IB/IPoIB: Separate control from HW operation on ipoib_open/stop ndo
> >   IB/IPoIB: Rename qpn to be dqpn in ipoib_send and post_send functions
> >   IB/IPoIB: Formatting before adding accelerator to driver
> >   IB/IPoIB: Support acceleration options callbacks
> >
> > Leon Romanovsky (1):
> >   IB/IPoIB: Introduce RDMA netdev interface and IPoIB structs
> >
> >  drivers/infiniband/ulp/ipoib/ipoib.h           |  40 +--
> >  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  66 ++---
> >  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   6 +-
> >  drivers/infiniband/ulp/ipoib/ipoib_fs.c        |   4 +-
> >  drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 339 +++++++++++++------------
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 312 +++++++++++++++++------
> >  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  39 +--
> >  drivers/infiniband/ulp/ipoib/ipoib_netlink.c   |  12 +-
> >  drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  64 ++---
> >  drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   9 +-
> >  include/rdma/ib_verbs.h                        |  41 +++
> >  11 files changed, 565 insertions(+), 367 deletions(-)
> >
> > --
> > 2.12.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> > of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wHmMVWdCgqSO3x88
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljj/BYACgkQ5GN7iDZy
WKcXuA/+ME59vZeFdBO+jqNTHJ+pVKAQBTcUvdMB9LDIzQQocWTRqCIbptEGlTlk
Z4Vo8qj6/bZZBlR1nbK6ugASfEWP56N5w6rI8YuIZsITUGDqE/IwiinStQ4kchU3
039FLrPFgSmVw39SZ+lFI9wkp+QPAtP6LUBpk0G/c/wwMTvuc6oth15FjezkQK39
dwAPr0c5MaeoOoRKK9gZuAAe0QufMMTc1Qhqb+BK9qEjyiYI2CaLeokbz/sKgnaP
XOiCKOBZHEnzZCaH63SuHI8MqR9xVj3KPdszlRwFZLUiV+Cz+ovWgxvSQzHPb1sD
INMB1l4r1SZwJO2pZC0tMFKJwOhOQ82bg3+MmPxTbr/8BfI61bBY8P3XHv5a/33H
AMBMgrNHaBitahqp4Ln9D4VH95v1rAtgx9mMkOxtcnUjNMNVo2PNid7eJ5ERwsKL
2LsIkEGsYLpbsXE35E8IqWfXdkhamm7lBoQ3MzX1OnqxOiAYo1sFYt9+gzjC73DG
dXdP75OBfctMjdpMYLV9vnIcTHZBtdIZzJw0lSJKqc4KGhNn5wraRvp2/PQChaVa
f7YP1AZ4qYI2l84LEHmsMTZUYmhTNzTkL8DrY+Mn83fZye/COfqkmlALvjPQ6TaR
nYgx+P8F+hPmheTGWoGXQ/3rk/VeO1Boi63Ua194KdEETdOPyoA=
=H/OR
-----END PGP SIGNATURE-----

--wHmMVWdCgqSO3x88--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
