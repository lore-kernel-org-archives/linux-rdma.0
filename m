From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Thu, 6 Apr 2017 08:28:20 +0300
Message-ID: <20170406052820.GB2269@mtr-leonro.local>
References: <20170404191732.31895-1-leon@kernel.org>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8CAA0@CRSMSX101.amr.corp.intel.com>
 <20170404200335.GB20443@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8DAB7@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67C8DAB7-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 06, 2017 at 12:54:02AM +0000, Weiny, Ira wrote:
> >
> > On Tue, Apr 04, 2017 at 07:50:21PM +0000, Weiny, Ira wrote:
> > > >
> > > > Hi Doug,
> > > >
> > > > This patchset mostly comes from Erez with one exception in the first patch.
> > > >
> > > > That patch origins from two different commits, first from Niranjana
> > > > who added RDMA netdev interface and second from Erez who added IPoIB
> > support.
> > > >
> > > > During the preparation to submission, I squashed their commits into
> > > > one and refactored code to allow submission as a standalone topic
> > > > without creating dependecies between different submissions. This
> > > > caused to change in author line.
> > > > I hope that it doesn't really matter and it won't stop you from merging it.
> > >
> > > I'm confused by how you expect Niranjana's patch to be merged in this
> > situation?
> > >
> > > Doug, will you take care of the conflict between these 2 submitted patches?
> > >
> > > [PATCH 02/11] IB/opa-vnic: Virtual Network Interface Controller (VNIC)
> > > interface And [PATCH rdma-next 1/6] IB/IPoIB: Introduce RDMA netdev
> > > interface and IPoIB structs
> >
> > Ira,
> >
> > The IPoIB and HFI-VNIC are independent series, so topics should be self-
> > contained. If the merge conflict worries you, Niranjana or me could easily base
> > our patch sets on another topic, but we need to know the acceptance (yes/no)
> > and order between them.
>
> I guess my expectation was that upon your agreement of this new interface, Doug would accept Niranjanas change and you could build on top of that rather than just taking part of Niranjanas patch and expecting Doug to see there are common hunks.  Perhaps I'm missing something and git is smart enough to deal with it?

It is not related to smart git. Parallel submissions should be independent,
this is the why I'm submitting all our topics based on one common ground (usually -rcX),
despite the fact that sometimes there is merge conflict between them.

As long Doug works in this mode, we are obligated to continue.

>
> Does this mean you have reviewed and are comfortable with Niranjanas new rdma_netdev changes?  If so it seems Doug could accept them.

We already discussed it in email and privately, I'm agree with you that IPoIB and HFI-VNIC
are better to be separated, due to conceptually difference and future code maintenance.
The proposed rdma_netdev suits well both patch sets, so I'm very comfortable with them.

However, I'm not comfortable with ULP location, for the code which is not interoperable
between different systems (nodes). After OFA, I realized that it wouldn't work in Susan's
LANL mixed cluster, which is pretty awful for the common ULP.

The code itself needs proprietary software (ethernet manager) to be
operable and it placed in ULP based on some promise that future drivers
will be added to hfi family. Right now, it is not the case.

You asked, I answered :)

>
> Ira
>
> >
> > Thanks
> >
> > >
> > > Ira
> > >
> > > >
> > > > Per-your request, I based this patch set on v4.11-rc3.
> > > >
> > > > Thanks,
> > > > 	Leon
> > > >
> > > > CC: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > CC: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > ---
> > > >
> > > > The rest comes from Erez:
> > > >
> > > >     The IPoIB protocol encapsulates IP packets over Infiniband datagrams.
> > > >     As a direct RDMA Upper Layer Protocol (ULP), IPoIB cannot support HW
> > > >     features that are specific to the IP protocol stack.
> > > >
> > > >     Nevertheless, RDMA interfaces have been extended to support some of
> > the
> > > >     prominent IP offload features, such as TCP/UDP checksum and TSO.
> > > >     This provided reasonable performance gain for IPoIB but is still
> > > >     insufficient to cope with the increasing network bandwidth demand.
> > > >
> > > >     However, New features are exisiting in common network interfaces that
> > > >     are very hard to implement in IPoIB interfaces while it uses the RDMA
> > > >     layer, examples include TSS and RSS, tunneling offloads, and XDP.
> > > >     Rather than continuously porting IP network interface developments into
> > > >     the RDMA stack, we propose adding an abstract network data-path
> > > >     interfaces to RDMA devices.
> > > >
> > > >     In order to present a consistent interface to users, the IPoIB ULP
> > > >     continues to represent the network device to the IP stack.
> > > >     The common code also manages the IPoIB control plane, such as resolving
> > > >     path queries and registering to multicast groups.
> > > >     Data path operations are forwarded to devices that implement the new
> > > >     API, or fallback to the standard implementation otherwise.
> > > >     Using the forgoing approach, we show how IPoIB closes the performance
> > > >     gap compared to state-of-the-art Ethernet network interfaces.
> > > >
> > > >     The implementation idea is to use the api of
> > > >     alloc_rdma_netdev/free_rdma_netdev to expose a struct that has data
> > > >     members and set of functions that are used for IB network interfaces,
> > > >     like attach/detach multicast to qp, and send IB packet.
> > > >
> > > >     The functions are specific for IB operations and are not part of the
> > > >     common api the the netdev struct exposes via the ndo functions.
> > > >     1. multicast handling - attach/detach
> > > >     2. send operation - the ndo start_xmit has only 2 parameters and the IB
> > > >     send needs the destination qp and the ah object, there were few options
> > > >     to handle it via the netdev ndo, but they don't make more sense than
> > > >     using a specific send function (we are rdma_netdev after all)
> > > >
> > > >     The IPoIB code will be adapted to enable the option of accelerating the
> > > >     network interface, but the code will work as before if the HW below
> > > >     doesn't support the acceleration.
> > > >     That means that in the default mode of ipoib I tried to keep it as much
> > > >     as it was before, not to force it to adopt the new api, where there is
> > > >     no code sharing between the ipoib and the vnic/hfi.
> > > >     The default code uses the controll and the data, the accelerator uses
> > > >     only the control flows andstructors.
> > > >     The changes of the default ipoib can be made on top of that series.
> > > >
> > > >     Each HW vendor can supply the acceleration for the IPoIB or to leave
> > > >     IPoIB to work as before.
> > > >
> > > > Thanks,
> > > > 	Erez
> > > >
> > > > Erez Shitrit (5):
> > > >   IB/IPoIB: Separate control and data related initializations
> > > >   IB/IPoIB: Separate control from HW operation on ipoib_open/stop ndo
> > > >   IB/IPoIB: Rename qpn to be dqpn in ipoib_send and post_send functions
> > > >   IB/IPoIB: Formatting before adding accelerator to driver
> > > >   IB/IPoIB: Support acceleration options callbacks
> > > >
> > > > Leon Romanovsky (1):
> > > >   IB/IPoIB: Introduce RDMA netdev interface and IPoIB structs
> > > >
> > > >  drivers/infiniband/ulp/ipoib/ipoib.h           |  40 +--
> > > >  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  66 ++---
> > > >  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   6 +-
> > > >  drivers/infiniband/ulp/ipoib/ipoib_fs.c        |   4 +-
> > > >  drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 339 +++++++++++++------------
> > > >  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 312 +++++++++++++++++---
> > ---
> > > >  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  39 +--
> > > >  drivers/infiniband/ulp/ipoib/ipoib_netlink.c   |  12 +-
> > > >  drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  64 ++---
> > > >  drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   9 +-
> > > >  include/rdma/ib_verbs.h                        |  41 +++
> > > >  11 files changed, 565 insertions(+), 367 deletions(-)
> > > >
> > > > --
> > > > 2.12.0
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe
> > > > linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljl0fQACgkQ5GN7iDZy
WKc9tRAAqBT7z1Px+HOG4Q6UDUx+kMd6a4c4k1j9ZymnUtovlcEU3yKT7IQIbY8g
y6m59CfUvLZ0VVILWuDiGCMIFMmVfX2qfop1nh7Hvd1Dev+OMcjAVM4Q1cpMs3nO
fhqdJNPXuUH7uqr1z+nsoF4Mi/en5Xh4v2gFVgFS3IkZY38qQk/GLJTo6c3sJ+M5
5NkUhCykRhtyE+MDgD0lTMA5HDkdhK9VtChKt9pAwFTAh0/FfXLEpwOFHtZ58yod
xCT+zyL6h/33FszwScXNxhQ57pTJKMSTqrybjVK9PLu6AHUuf6jrUAnUyWYzmS9K
yJn9iMMW/sBUXJRWWywXHg4Q013hFHaApQgI9KpTxz2XYIs2nUFjbQvA9kIPdvOw
08C2EiYyjDYq1AIVIANBONMcBojuHLjaIej8FFjZaAN00E6uIIXCJbNNn2ewZxGz
7fUNMPQqfgR0lNrJ9D6jn6QSKuNzI+CsfLpOf2mQhspUfglQo1G/HaTHyUPZWhBM
hlH68ArsLMHRr00Q5vdq/MTkhh52YplmIv1yLybv5YKgmAu/7dxkbFUjWCpOS0mi
Wvo0ed/8zS3g6+0ED+fV0z99eO9q6cR1gbdaFBBdOtErRMFQ+uxsLFELjsrGq2YH
u8/01aVkSGSjZOC1IsVXMLM+3GhJUmy/CP2EX4Nh8I2mRMZBBLI=
=mf1Y
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
