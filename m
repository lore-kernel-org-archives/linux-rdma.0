From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 00/22] Add SRIOV support for IB interfaces
Date: Fri,  3 Aug 2012 11:40:36 +0300
Message-ID: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set adds SRIOV support for IB interfaces.

Patches 1-4 are "precondition" patches.
Patches 5-22 actually implement the feature.

NOTE:  Patch 18 depends on patch IB/mlx4: fix possible deadlock with sm=
_lock spinlock
       (a separately-submitted patch) being applied previously to the f=
or-next git.

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

Some Limitations
----------------
1. FMRs are not currently supported on slaves. This will be corrected i=
n a
   future submission.
2. RoCE is not currently supported on slaves. This will be corrected in=
 a
   future submission.

Changes for V2
--------------

1. Patches already accepted by Roland in the V1 set are removed from V2=
=2E
   The following (precondition) patches submitted in V1 were accepted:
	1:  net/mlx4_core: Pass an invalid PCI id number to VFs
	3:  IB/mlx4: Add debug printouts
	6:  IB/sa: Add GuidInfoRecord query support
	7:  IB/core: move macros from cm_msgs.h to ib_cm.h
	8:  {NET,IB}/mlx4: Use port management change event instead of smp_sno=
op
	9:  net/mlx4_core: For SRIOV, initialize ib port-capabilities for all =
slaves
	10: net/mlx4_core: Implement mechanism for reserved qkeys
	11: net/mlx4_core: Allow guests to support IB ports
	12: {NET,IB}/mlx4_core: place phys gid and pkey tbl sizes in mlx4_phys=
_caps
		struct and paravirtualize them

2. patches (new numbering) "5: net/mlx4_core: Add proxy and tunnel QPs =
to the reserved QP area"
   and "8: IB/mlx4: SRIOV multiplex and demultiplex MADs"
   were adjusted to account for changes introduced by commits to mlx4_c=
ore from other gits in the
   kernel V3.5 merge=20

3. A fix to event processing in the V2 patch set was added to patch
   "18: IB/mlx4: Miscellaneous adjustments to SRIOV IB support" :

   Add spinlock to slave_event(), since it is called both in interrupt
   context and in process context (due to patch 6, and also if smp_snoo=
p
   is used).
   This fix was found and implemented by Saeed Mahameed <saeedm@mellano=
x.com>
=20
4. Two new patches were added to V2:
   21: {NET,IB}/mlx4: Modify proxy/tunnel QP mechanism so that guests d=
o no calculations
   22: IB/mlx4: Create pv contexts for active VFs when PF (master) ib d=
river initializes

5. The workaround for the KVM IRQ management problem is no longer neede=
d.  The KVM group
   fixed the problem in kernel 3.5-rc7.

Changes for V1
--------------

1. librdmacm now supports multiple VF/PF on the same host (patch 29).
2. Several patches cleaned up (these were indicated in the V0 changelog=
s).
   Major cleanups in patch 22 and patch 24.
3. Eliminated code duplication in Port Management Change event code (pa=
tch 8).
4. Now use pr_debug, instead of mlx4_ib_debug, and there is no module p=
arameter
   (Roland's recommendation).
5. mlx4_master_func_num() to get the master's "slave_id", to make code =
more readable.
6. Fixed illegal use of port num field for a force-loopback bit in ib_a=
h structure
   (V0 patch 2 -- eliminated). The force-loopback bit is now set for Tu=
nnel QPs in=20
   mlx4_ib_post send (patch 17).
7. New patch 2 (not related to 6 above) to reserve bits in enum ib_qp_c=
reate_flags.
8. V0 patch 26 is now rolled into V1 patch 22. This allowed us to elimi=
nate function
   mlx4_ib_indexed_gid from patch 22 (replaced by using __mlx4_ib_query=
_gid() from V0 patch 26).


Amir Vadai (1):
  IB/mlx4: Add CM paravirtualization

Erez Shitrit (1):
  IB/sa: Add GuidInfoRecord query support.

Jack Morgenstein (26):
  net/mlx4_core: Pass an invalid PCI id number to VFs
  IB/core: Reserve bits in enum ib_qp_create_flags for low-level driver
    use
  IB/mlx4: Add debug printouts
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
  {NET,IB}/mlx4_core: place phys gid and pkey tbl sizes in
    mlx4_phys_caps struct and paravirtualize them
  IB/mlx4: SRIOV IB context objects and proxy/tunnel sqp support
  net/mlx4_core: Add proxy and tunnel QPs to the reserved QP area
  IB/mlx4: Initialize SRIOV IB support for slaves in master context
  {NET,IB}/mlx4: Implement QP paravirtualization and maintain
    phys_pkey_cache for smp_snoop
  IB/mlx4: SRIOV multiplex and demultiplex MADs
  {NET,IB}/mlx4: MAD_IFC paravirtualization
  net/mlx4_core: Add IB port-state machine, and port mgmt event
    propagation infrastructure
  {NET,IB}/mlx4: Add alias_guid mechanism
  IB/mlx4: Propagate pkey and guid change port management events to
    slaves
  IB/mlx4: Add iov directory in sysfs under the ib device
  net/mlx4_core: Adjustments to SET_PORT for SRIOV-IB
  net/mlx4_core: INIT/CLOSE port logic for IB ports in SRIOV mode
  IB/mlx4: Miscellaneous adjustments to SRIOV IB support
  {NET,IB}/mlx4: Activate SRIOV mode for IB
  {NET,IB}/mlx4: Paravirtualize Node Guids for slaves.

Oren Duer (1):
  IB/mlx4: Added Multicast Groups (MCG) para-virtualization for SRIOV

 drivers/infiniband/core/cache.c                    |   42 +-
 drivers/infiniband/core/cm_msgs.h                  |   12 -
 drivers/infiniband/core/device.c                   |   17 +-
 drivers/infiniband/core/sa_query.c                 |  133 ++
 drivers/infiniband/hw/mlx4/Makefile                |    2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |  688 ++++++++
 drivers/infiniband/hw/mlx4/cm.c                    |  437 +++++
 drivers/infiniband/hw/mlx4/cq.c                    |   31 +-
 drivers/infiniband/hw/mlx4/mad.c                   | 1684 ++++++++++++=
+++++++-
 drivers/infiniband/hw/mlx4/main.c                  |  285 +++-
 drivers/infiniband/hw/mlx4/mcg.c                   | 1254 ++++++++++++=
+++
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  360 +++++-
 drivers/infiniband/hw/mlx4/qp.c                    |  651 +++++++-
 drivers/infiniband/hw/mlx4/sysfs.c                 |  794 +++++++++
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |  190 +++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |    5 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |  259 +++-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  227 +++-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |    3 +
 drivers/net/ethernet/mellanox/mlx4/intf.c          |    5 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  124 ++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  116 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |   21 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |   67 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  220 +++-
 include/linux/mlx4/device.h                        |  179 ++-
 include/linux/mlx4/driver.h                        |    5 +-
 include/linux/mlx4/qp.h                            |    3 +-
 include/rdma/ib_cache.h                            |   16 +
 include/rdma/ib_cm.h                               |   12 +
 include/rdma/ib_sa.h                               |   33 +
 include/rdma/ib_verbs.h                            |    3 +
 32 files changed, 7520 insertions(+), 358 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx4/alias_GUID.c
 create mode 100644 drivers/infiniband/hw/mlx4/cm.c
 create mode 100644 drivers/infiniband/hw/mlx4/mcg.c
 create mode 100644 drivers/infiniband/hw/mlx4/sysfs.c

Cc: dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

Amir Vadai (1):
  IB/mlx4: Add CM paravirtualization

Jack Morgenstein (20):
  IB/core: Reserve bits in enum ib_qp_create_flags for low-level driver
    use
  IB/core: change pkey table lookups to support full and partial
    membership for the same pkey
  IB/core: Add ib_find_exact_cached_pkey() to search for 16-bit pkey
    match
  IB/mlx4: SRIOV IB context objects and proxy/tunnel sqp support
  net/mlx4_core: Add proxy and tunnel QPs to the reserved QP area
  IB/mlx4: Initialize SRIOV IB support for slaves in master context
  {NET,IB}/mlx4: Implement QP paravirtualization and maintain
    phys_pkey_cache for smp_snoop
  IB/mlx4: SRIOV multiplex and demultiplex MADs
  {NET,IB}/mlx4: MAD_IFC paravirtualization
  net/mlx4_core: Add IB port-state machine, and port mgmt event
    propagation infrastructure
  {NET,IB}/mlx4: Add alias_guid mechanism
  IB/mlx4: Propagate pkey and guid change port management events to
    slaves
  IB/mlx4: Add iov directory in sysfs under the ib device
  net/mlx4_core: Adjustments to SET_PORT for SRIOV-IB
  net/mlx4_core: INIT/CLOSE port logic for IB ports in SRIOV mode
  IB/mlx4: Miscellaneous adjustments to SRIOV IB support
  {NET,IB}/mlx4: Activate SRIOV mode for IB
  {NET,IB}/mlx4: Paravirtualize Node Guids for slaves
  {NET,IB}/mlx4: Modify proxy/tunnel QP mechanism so that guests do no
    calculations
  IB/mlx4: Create pv contexts for active VFs when PF (master) ib driver
    initializes

Oren Duer (1):
  IB/mlx4: Added Multicast Groups (MCG) para-virtualization for SRIOV

 drivers/infiniband/core/cache.c                    |   42 +-
 drivers/infiniband/core/device.c                   |   17 +-
 drivers/infiniband/hw/mlx4/Makefile                |    2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |  688 +++++++++
 drivers/infiniband/hw/mlx4/cm.c                    |  437 ++++++
 drivers/infiniband/hw/mlx4/cq.c                    |   31 +-
 drivers/infiniband/hw/mlx4/mad.c                   | 1573 ++++++++++++=
+++++++-
 drivers/infiniband/hw/mlx4/main.c                  |  273 +++-
 drivers/infiniband/hw/mlx4/mcg.c                   | 1254 ++++++++++++=
++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  341 +++++-
 drivers/infiniband/hw/mlx4/qp.c                    |  656 +++++++-
 drivers/infiniband/hw/mlx4/sysfs.c                 |  794 ++++++++++
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |  191 +++-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |  245 +++-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  244 ++-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   11 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   91 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   50 +
 drivers/net/ethernet/mellanox/mlx4/port.c          |   10 +
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  100 ++-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  220 +++-
 include/linux/mlx4/device.h                        |   69 +-
 include/linux/mlx4/driver.h                        |    2 +
 include/linux/mlx4/qp.h                            |    3 +-
 include/rdma/ib_cache.h                            |   16 +
 include/rdma/ib_verbs.h                            |    3 +
 26 files changed, 7080 insertions(+), 283 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx4/alias_GUID.c
 create mode 100644 drivers/infiniband/hw/mlx4/cm.c
 create mode 100644 drivers/infiniband/hw/mlx4/mcg.c
 create mode 100644 drivers/infiniband/hw/mlx4/sysfs.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
