From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Thu, 6 Apr 2017 00:54:02 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67C8DAB7@CRSMSX101.amr.corp.intel.com>
References: <20170404191732.31895-1-leon@kernel.org>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8CAA0@CRSMSX101.amr.corp.intel.com>
 <20170404200335.GB20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404200335.GB20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>=20
> On Tue, Apr 04, 2017 at 07:50:21PM +0000, Weiny, Ira wrote:
> > >
> > > Hi Doug,
> > >
> > > This patchset mostly comes from Erez with one exception in the first =
patch.
> > >
> > > That patch origins from two different commits, first from Niranjana
> > > who added RDMA netdev interface and second from Erez who added IPoIB
> support.
> > >
> > > During the preparation to submission, I squashed their commits into
> > > one and refactored code to allow submission as a standalone topic
> > > without creating dependecies between different submissions. This
> > > caused to change in author line.
> > > I hope that it doesn't really matter and it won't stop you from mergi=
ng it.
> >
> > I'm confused by how you expect Niranjana's patch to be merged in this
> situation?
> >
> > Doug, will you take care of the conflict between these 2 submitted patc=
hes?
> >
> > [PATCH 02/11] IB/opa-vnic: Virtual Network Interface Controller (VNIC)
> > interface And [PATCH rdma-next 1/6] IB/IPoIB: Introduce RDMA netdev
> > interface and IPoIB structs
>=20
> Ira,
>=20
> The IPoIB and HFI-VNIC are independent series, so topics should be self-
> contained. If the merge conflict worries you, Niranjana or me could easil=
y base
> our patch sets on another topic, but we need to know the acceptance (yes/=
no)
> and order between them.

I guess my expectation was that upon your agreement of this new interface, =
Doug would accept Niranjanas change and you could build on top of that rath=
er than just taking part of Niranjanas patch and expecting Doug to see ther=
e are common hunks.  Perhaps I'm missing something and git is smart enough =
to deal with it?

Does this mean you have reviewed and are comfortable with Niranjanas new rd=
ma_netdev changes?  If so it seems Doug could accept them.

Ira

>=20
> Thanks
>=20
> >
> > Ira
> >
> > >
> > > Per-your request, I based this patch set on v4.11-rc3.
> > >
> > > Thanks,
> > > 	Leon
> > >
> > > CC: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > CC: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > ---
> > >
> > > The rest comes from Erez:
> > >
> > >     The IPoIB protocol encapsulates IP packets over Infiniband datagr=
ams.
> > >     As a direct RDMA Upper Layer Protocol (ULP), IPoIB cannot support=
 HW
> > >     features that are specific to the IP protocol stack.
> > >
> > >     Nevertheless, RDMA interfaces have been extended to support some =
of
> the
> > >     prominent IP offload features, such as TCP/UDP checksum and TSO.
> > >     This provided reasonable performance gain for IPoIB but is still
> > >     insufficient to cope with the increasing network bandwidth demand=
.
> > >
> > >     However, New features are exisiting in common network interfaces =
that
> > >     are very hard to implement in IPoIB interfaces while it uses the =
RDMA
> > >     layer, examples include TSS and RSS, tunneling offloads, and XDP.
> > >     Rather than continuously porting IP network interface development=
s into
> > >     the RDMA stack, we propose adding an abstract network data-path
> > >     interfaces to RDMA devices.
> > >
> > >     In order to present a consistent interface to users, the IPoIB UL=
P
> > >     continues to represent the network device to the IP stack.
> > >     The common code also manages the IPoIB control plane, such as res=
olving
> > >     path queries and registering to multicast groups.
> > >     Data path operations are forwarded to devices that implement the =
new
> > >     API, or fallback to the standard implementation otherwise.
> > >     Using the forgoing approach, we show how IPoIB closes the perform=
ance
> > >     gap compared to state-of-the-art Ethernet network interfaces.
> > >
> > >     The implementation idea is to use the api of
> > >     alloc_rdma_netdev/free_rdma_netdev to expose a struct that has da=
ta
> > >     members and set of functions that are used for IB network interfa=
ces,
> > >     like attach/detach multicast to qp, and send IB packet.
> > >
> > >     The functions are specific for IB operations and are not part of =
the
> > >     common api the the netdev struct exposes via the ndo functions.
> > >     1. multicast handling - attach/detach
> > >     2. send operation - the ndo start_xmit has only 2 parameters and =
the IB
> > >     send needs the destination qp and the ah object, there were few o=
ptions
> > >     to handle it via the netdev ndo, but they don't make more sense t=
han
> > >     using a specific send function (we are rdma_netdev after all)
> > >
> > >     The IPoIB code will be adapted to enable the option of accelerati=
ng the
> > >     network interface, but the code will work as before if the HW bel=
ow
> > >     doesn't support the acceleration.
> > >     That means that in the default mode of ipoib I tried to keep it a=
s much
> > >     as it was before, not to force it to adopt the new api, where the=
re is
> > >     no code sharing between the ipoib and the vnic/hfi.
> > >     The default code uses the controll and the data, the accelerator =
uses
> > >     only the control flows andstructors.
> > >     The changes of the default ipoib can be made on top of that serie=
s.
> > >
> > >     Each HW vendor can supply the acceleration for the IPoIB or to le=
ave
> > >     IPoIB to work as before.
> > >
> > > Thanks,
> > > 	Erez
> > >
> > > Erez Shitrit (5):
> > >   IB/IPoIB: Separate control and data related initializations
> > >   IB/IPoIB: Separate control from HW operation on ipoib_open/stop ndo
> > >   IB/IPoIB: Rename qpn to be dqpn in ipoib_send and post_send functio=
ns
> > >   IB/IPoIB: Formatting before adding accelerator to driver
> > >   IB/IPoIB: Support acceleration options callbacks
> > >
> > > Leon Romanovsky (1):
> > >   IB/IPoIB: Introduce RDMA netdev interface and IPoIB structs
> > >
> > >  drivers/infiniband/ulp/ipoib/ipoib.h           |  40 +--
> > >  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  66 ++---
> > >  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   6 +-
> > >  drivers/infiniband/ulp/ipoib/ipoib_fs.c        |   4 +-
> > >  drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 339 +++++++++++++--=
----------
> > >  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 312 +++++++++++++++=
++---
> ---
> > >  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  39 +--
> > >  drivers/infiniband/ulp/ipoib/ipoib_netlink.c   |  12 +-
> > >  drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  64 ++---
> > >  drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   9 +-
> > >  include/rdma/ib_verbs.h                        |  41 +++
> > >  11 files changed, 565 insertions(+), 367 deletions(-)
> > >
> > > --
> > > 2.12.0
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
