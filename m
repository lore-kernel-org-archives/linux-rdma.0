From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 00/29] Add SRIOV support for IB interfaces
Date: Mon, 11 Jun 2012 13:45:41 +0300
Message-ID: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set adds SRIOV support for IB interfaces.

Patches 1-13 are "precondition" patches.
Patches 14-29 actually implement the feature.

This patch set introduces Infiniband SRIOV support for ConnectX2 and Co=
nnectX3
devices.  Each function presents itself as an independent vHCA (virtual=
 HCA) to
the host while a single HCA is observable by the network, which is unaw=
are of
the vHCAs.  No changes are required by the IB subsystem, ULPs, and apps=
 to
support SRIOV, and vHCAs are interoperable with any existing (non-virtu=
alized)
IB deployments.
=20
We term this model for SRIOV implementation the shared-port model.

Sharing the same physical port(s) among multiple vHCAs is achieved as f=
ollows:
=20
1. Each vHCA port presents its own virtual GID table.
=20
Currently, the virtual GID table comprises a single entry (at index 0) =
that
maps to a unique index in the physical GID table.  The vHCA of the PF m=
aps to
physical GID index 0. To obtain GIDs for other vHCAs, alias GUIDs are r=
equested
from the SM.  These are GUIDs which the SM places, per port, in the por=
t's guid
table after the 0'th slot (which is read-only and determined by the FW)=
=2E
The host admin can assign GIDs to vHCAs using a sysfs interface (see be=
low).
=20
2. Each vHCA port presents its own virtual PKey table.
=20
The virtual PKey table is a mapping of selected indexes of the physical=
 pkey table.
The host admin can control which pkey indexes are mapped to which virtu=
al indexes
using a sysfs interface (see below). Note that the physical PKey table =
may contain
both full and partial memberships of the same PKey to allow different m=
embership
types in different virtual tables.
=20
3. Each vHCA port has its own virtual port state.
=20
A vHCA port is up if the following conditions apply:
- The physical port is up
- The virtual GID table contains the GIDs requested by the host admin
- The SM has acknowledged the requested GIDs since the last time that
  the physical port came up
=20
4. Other port attributes are shared, e.g., GID prefix, LID,  SM LID, LM=
C mask.
=20
5. Special QPs are para-virtualized.
=20
vHCAs are not given direct access to QP0/1. Rather, these QPs are opera=
ted by a
special context hosted by the PF, which mediates access to/from vHCAs.
This is done by opening a =E2=80=9Ctunnel=E2=80=9D per vHCA port per QP=
0/1. A tunnel comprises
a pair of UD QPs:  a =E2=80=9CTunnel QP=E2=80=9D in the PF-context and =
a =E2=80=9CProxy QP=E2=80=9D in the vHCA.
All vHCA MAD traffic must pass through the corresponding tunnel.
vHCA QPs cannot be assigned to VL15 and are denied of the well-known QK=
ey.=20
=20
QP0 access is restricted to the PF vHCA. VF vHCAs also have (virtual) Q=
P0=E2=80=99s,
but they never receive any SMPs and all SMPs sent are discarded.
QP1 traffic is allowed for all vHCAs, but special care is required to b=
ridge
the gap between the host and network views.

Specifically:
- Transaction IDs are mapped to guarantee uniqueness among vHCAs
- CM para-virtualization
  o   Incoming requests are steered to the correct vHCA according to th=
e embedded GID
  o   Local communication IDs are mapped to ensure uniqueness among vHC=
As
- Multicast para-virtualization
  o   The PF context aggregates membership state from all vHCAs
  o   The SA is contacted only when the aggregate membership changes
  o   If the aggregate does not change, the PF context will provide the
       requesting vHCA with the proper response
=20
Incoming MADs are steered according to:
- the DGID If a GRH is present
- the mapped transaction ID for response MADs
- the embedded GID in CM requests
- the remote communication ID in other CM messages

To allow the host admin to control the virtual GID and PKey tables of v=
HCAs,
a new sysfs =E2=80=98iov=E2=80=99 sub-tree has been added under the PF =
infiniband device.
Details on this mechanism can be found in the change log of:
   IB/mlx4: Add iov directory in sysfs under the ib device

Known Issues
------------
1. librdmacm will currently not support multiple VF/PF on the same host=
=2E
   This will be fixed in V1.
2. FMRs are not currently supported on slaves. This will be corrected i=
n a
   future submission.
3. RoCE is not currently supported on slaves. This will be corrected in=
 a
   future submission.
4. Due to a (correct) change in kernel IRQ management in kernel 3.5-rc1=
 (see
   commit 1c6c69525b40), the KVM module no longer succeeds in passing i=
nterrupts
   through to guests.  (see the discussion thread beginning at
   https://lkml.org/lkml/2012/6/1/261).  Until this KVM issue is fixed,=
 anyone
   wishing to use SRIOV-IB (or SRIOV-Ethernet) with ConnectX2 or Connec=
tX3
   devices on guest O/Ses should revert commit 1c6c69525b40
   (as a TEMPORARY workaround) in order to enable the guests to operate=
 the mlx4 driver.

   VFs may still be bound to the host (via setting the "probe_vf" mlx4_=
core
   module parameter to a non-zero value in a conf file under /etc/modpr=
obe.d)=20
   without reverting the commit mentioned above.

In addition, several of the patches have notations indicating things th=
at
will be fixed in V1.

Amir Vadai (1):
  IB/mlx4: Add CM paravirtualization

Erez Shitrit (1):
  IB/sa: Add GuidInfoRecord query support.

Jack Morgenstein (26):
  net/mlx4_core: Pass an invalid PCI id number to VFs
  IB/mlx4: Mask out high order bit of port_num in mlx4_ib_create_ah
  IB/mlx4: Add run-time switchable error path debug output capability
  IB/core: change pkey table lookups to support full and partial
    membership for the same pkey
  IB/core: Add ib_find_exact_cached_pkey() to search for 16-bit pkey
    match
  IB/core: move macros from cm_msgs.h to ib_cm.h
  {NET,IB}/mlx4: Use port management change event instead of smp_snoop
  net/mlx4_core: For SRIOV, initialize ib port-capabilities for all
    slaves
  net/mlx4_core: Implement mechanism for reserved qkeys
  net/mlx4_core: Allow guests to support IB ports
  net/mlx4_core: place phys gid and pkey tbl sizes in mlx4_phys_caps
    struct and paravirtualize them
  IB/mlx4: SRIOV IB context objects and proxy/tunnel sqp support
  net/mlx4_core: Add proxy and tunnel QPs to the reserved QP area
  IB/mlx4: Initialize SRIOV IB support for slaves in master context
  {NET/IB}mlx4: Implement QP paravirtualization
  IB/mlx4: SRIOV multiplex and demultiplex MADs
  {NET,IB}/mlx4: MAD_IFC paravirtualization
  net/mlx4_core: Add IB port-state machine, and port mgmt event
    propagation infrastructure
  {NET,IB}/mlx4: Add alias_guid mechanism
  IB/mlx4: Propagate pkey and guid change port management events to
    slaves
  IB/mlx4: Add iov directory in sysfs under the ib device
  net/mlx4_core: Adjustments to SET_PORT for SRIOV-IB
  IB/mlx4: Initialize guid-cache index 0 (default guid)
  net/mlx4_core: INIT/CLOSE port logic for IB ports in SRIOV mode
  IB/mlx4: Miscellaneous adjustments to SRIOV IB support
  {NET/IB}mlx4: Activate SRIOV mode for IB

Oren Duer (1):
  IB/mlx4: Added Multicast Groups (MCG) para-virtualization for SRIOV

 drivers/infiniband/core/cache.c                    |   42 +-
 drivers/infiniband/core/cm_msgs.h                  |   12 -
 drivers/infiniband/core/device.c                   |   17 +-
 drivers/infiniband/core/sa_query.c                 |  133 ++
 drivers/infiniband/hw/mlx4/Makefile                |    2 +-
 drivers/infiniband/hw/mlx4/ah.c                    |    4 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |  791 +++++++++
 drivers/infiniband/hw/mlx4/cm.c                    |  437 +++++
 drivers/infiniband/hw/mlx4/cq.c                    |   31 +-
 drivers/infiniband/hw/mlx4/mad.c                   | 1712 ++++++++++++=
+++++++-
 drivers/infiniband/hw/mlx4/main.c                  |  284 +++-
 drivers/infiniband/hw/mlx4/mcg.c                   | 1254 ++++++++++++=
++
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  368 +++++-
 drivers/infiniband/hw/mlx4/qp.c                    |  663 +++++++-
 drivers/infiniband/hw/mlx4/sysfs.c                 |  808 +++++++++
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |  179 ++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |    5 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |  257 +++-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  235 +++-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |    3 +
 drivers/net/ethernet/mellanox/mlx4/intf.c          |    5 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  103 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  115 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |   21 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |   66 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  220 +++-
 include/linux/mlx4/device.h                        |  168 ++-
 include/linux/mlx4/driver.h                        |    5 +-
 include/linux/mlx4/qp.h                            |    3 +-
 include/rdma/ib_cache.h                            |   16 +
 include/rdma/ib_cm.h                               |   12 +
 include/rdma/ib_sa.h                               |   33 +
 32 files changed, 7653 insertions(+), 351 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx4/alias_GUID.c
 create mode 100644 drivers/infiniband/hw/mlx4/cm.c
 create mode 100644 drivers/infiniband/hw/mlx4/mcg.c
 create mode 100644 drivers/infiniband/hw/mlx4/sysfs.c

Cc: dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
