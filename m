From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC 00/19] Add unified Intel Ethernet RDMA driver (irdma)
Date: Tue, 12 Feb 2019 15:43:43 -0600
Message-ID: <20190212214402.23284-1-shiraz.saleem@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, "Saleem, Shiraz" <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: "Saleem, Shiraz" <shiraz.saleem@intel.com>

This patchset adds a unified Intel Ethernet RDMA driver that
supports a new network device E810 (iWARP and RoCEv2 capable)
and the existing X722 iWARP device. The driver architecture
provides the extensibility for future generations of Intel HW
supporting RDMA.

The underlying LAN driver for X722 ("i40e") and E810 ("ice")
have their own peer/client interface that this unified RDMA
driver registers to. The netdev_priv structure of each LAN
driver accessed by the netdev_priv() interface exposes their
peer register/unregister function pointers for use by the RDMA
driver. This solution revives an earlier submission [1] intended for
a different purpose. It now serves to unify the RDMA driver and
we are requesting feedback.

The unified driver is currently being tested on X722 with rdma-core-v22.
X722 is supported by this driver, but only if CONFIG_INFINIBAND_I40IW
is disabled in the kernel. We desire to deprecate or phase out i40iw
from the kernel and can submit patches to do the same. We would like to
move forward with this unified driver model for current and future HW.

This series was built against rdma-next.
commit a2bfd708b17a ("RDMA/iwpm: move kdoc comments to functions")
It includes both net and rdma patches for the purposes
of review. It will be split into two separate patch series, one for
net-next and rdma-next once RFC is accepted.

[1] https://patchwork.kernel.org/patch/10419583/

Anirudh Venkataramanan (2):
  net/ice: Create framework for VSI queue context
  net/ice: Add support for ice peer devices and drivers

Michael J. Ruhl (1):
  RDMA/irdma: Add dynamic tracing for CM

Mustafa Ismail (13):
  RDMA/irdma: Add driver framework definitions
  RDMA/irdma: Implement device initialization definitions
  RDMA/irdma: Implement HW Admin Queue OPs
  RDMA/irdma: Add HMC backing store setup functions
  RDMA/irdma: Add privileged UDA queue implementation
  RDMA/irdma: Add QoS definitions
  RDMA/irdma: Add connection manager
  RDMA/irdma: Add PBLE resource manager
  RDMA/irdma: Implement device supported verb APIs
  RDMA/irdma: Add RoCEv2 UD OP support
  RDMA/irdma: Add user/kernel shared libraries
  RDMA/irdma: Add miscellaneous utility definitions
  RDMA/irdma: Add ABI definitions

Shiraz Saleem (3):
  net/i40e: Add peer register/unregister to struct i40e_netdev_priv
  RDMA/irdma: Add Kconfig and Makefile
  RDMA/irdma: Update MAINTAINERS file

 MAINTAINERS                                      |   10 +-
 drivers/infiniband/Kconfig                       |    1 +
 drivers/infiniband/hw/Makefile                   |    1 +
 drivers/infiniband/hw/irdma/Kconfig              |   11 +
 drivers/infiniband/hw/irdma/Makefile             |   31 +
 drivers/infiniband/hw/irdma/cm.c                 | 4621 ++++++++++++++++
 drivers/infiniband/hw/irdma/cm.h                 |  425 ++
 drivers/infiniband/hw/irdma/ctrl.c               | 6165 ++++++++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h               | 2053 +++++++
 drivers/infiniband/hw/irdma/hmc.c                |  716 +++
 drivers/infiniband/hw/irdma/hmc.h                |  221 +
 drivers/infiniband/hw/irdma/hw.c                 | 2484 +++++++++
 drivers/infiniband/hw/irdma/i40iw_hw.c           |  207 +
 drivers/infiniband/hw/irdma/i40iw_hw.h           |  164 +
 drivers/infiniband/hw/irdma/i40iw_if.c           |  250 +
 drivers/infiniband/hw/irdma/icrdma_hw.c          |   74 +
 drivers/infiniband/hw/irdma/icrdma_hw.h          |   60 +
 drivers/infiniband/hw/irdma/irdma.h              |  187 +
 drivers/infiniband/hw/irdma/irdma_if.c           |  430 ++
 drivers/infiniband/hw/irdma/main.c               |  496 ++
 drivers/infiniband/hw/irdma/main.h               |  709 +++
 drivers/infiniband/hw/irdma/osdep.h              |  153 +
 drivers/infiniband/hw/irdma/pble.c               |  520 ++
 drivers/infiniband/hw/irdma/pble.h               |  135 +
 drivers/infiniband/hw/irdma/protos.h             |  118 +
 drivers/infiniband/hw/irdma/puda.c               | 1694 ++++++
 drivers/infiniband/hw/irdma/puda.h               |  186 +
 drivers/infiniband/hw/irdma/status.h             |   70 +
 drivers/infiniband/hw/irdma/trace.c              |  113 +
 drivers/infiniband/hw/irdma/trace.h              |    4 +
 drivers/infiniband/hw/irdma/trace_cm.h           |  459 ++
 drivers/infiniband/hw/irdma/type.h               | 1705 ++++++
 drivers/infiniband/hw/irdma/uda.c                |  416 ++
 drivers/infiniband/hw/irdma/uda.h                |   87 +
 drivers/infiniband/hw/irdma/uda_d.h              |  383 ++
 drivers/infiniband/hw/irdma/uk.c                 | 1680 ++++++
 drivers/infiniband/hw/irdma/user.h               |  463 ++
 drivers/infiniband/hw/irdma/utils.c              | 2566 +++++++++
 drivers/infiniband/hw/irdma/verbs.c              | 4267 +++++++++++++++
 drivers/infiniband/hw/irdma/verbs.h              |  191 +
 drivers/infiniband/hw/irdma/ws.c                 |  449 ++
 drivers/infiniband/hw/irdma/ws.h                 |   40 +
 drivers/net/ethernet/intel/i40e/i40e.h           |    1 +
 drivers/net/ethernet/intel/i40e/i40e_client.h    |   10 +
 drivers/net/ethernet/intel/i40e/i40e_main.c      |    7 +
 drivers/net/ethernet/intel/ice/Makefile          |    1 +
 drivers/net/ethernet/intel/ice/ice.h             |   14 +
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h  |   32 +
 drivers/net/ethernet/intel/ice/ice_common.c      |  189 +
 drivers/net/ethernet/intel/ice/ice_common.h      |    9 +
 drivers/net/ethernet/intel/ice/ice_idc.c         | 1527 ++++++
 drivers/net/ethernet/intel/ice/ice_idc.h         |  402 ++
 drivers/net/ethernet/intel/ice/ice_idc_int.h     |   99 +
 drivers/net/ethernet/intel/ice/ice_lib.c         |   24 +
 drivers/net/ethernet/intel/ice/ice_lib.h         |    2 +
 drivers/net/ethernet/intel/ice/ice_main.c        |  143 +-
 drivers/net/ethernet/intel/ice/ice_sched.c       |  177 +-
 drivers/net/ethernet/intel/ice/ice_switch.c      |   23 +
 drivers/net/ethernet/intel/ice/ice_switch.h      |   11 +
 drivers/net/ethernet/intel/ice/ice_type.h        |    3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |   25 -
 include/uapi/rdma/irdma-abi.h                    |  140 +
 include/uapi/rdma/rdma_user_ioctl_cmds.h         |    1 +
 63 files changed, 37762 insertions(+), 93 deletions(-)
 create mode 100644 drivers/infiniband/hw/irdma/Kconfig
 create mode 100644 drivers/infiniband/hw/irdma/Makefile
 create mode 100644 drivers/infiniband/hw/irdma/cm.c
 create mode 100644 drivers/infiniband/hw/irdma/cm.h
 create mode 100644 drivers/infiniband/hw/irdma/ctrl.c
 create mode 100644 drivers/infiniband/hw/irdma/defs.h
 create mode 100644 drivers/infiniband/hw/irdma/hmc.c
 create mode 100644 drivers/infiniband/hw/irdma/hmc.h
 create mode 100644 drivers/infiniband/hw/irdma/hw.c
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_hw.c
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_hw.h
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
 create mode 100644 drivers/infiniband/hw/irdma/icrdma_hw.c
 create mode 100644 drivers/infiniband/hw/irdma/icrdma_hw.h
 create mode 100644 drivers/infiniband/hw/irdma/irdma.h
 create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
 create mode 100644 drivers/infiniband/hw/irdma/main.c
 create mode 100644 drivers/infiniband/hw/irdma/main.h
 create mode 100644 drivers/infiniband/hw/irdma/osdep.h
 create mode 100644 drivers/infiniband/hw/irdma/pble.c
 create mode 100644 drivers/infiniband/hw/irdma/pble.h
 create mode 100644 drivers/infiniband/hw/irdma/protos.h
 create mode 100644 drivers/infiniband/hw/irdma/puda.c
 create mode 100644 drivers/infiniband/hw/irdma/puda.h
 create mode 100644 drivers/infiniband/hw/irdma/status.h
 create mode 100644 drivers/infiniband/hw/irdma/trace.c
 create mode 100644 drivers/infiniband/hw/irdma/trace.h
 create mode 100644 drivers/infiniband/hw/irdma/trace_cm.h
 create mode 100644 drivers/infiniband/hw/irdma/type.h
 create mode 100644 drivers/infiniband/hw/irdma/uda.c
 create mode 100644 drivers/infiniband/hw/irdma/uda.h
 create mode 100644 drivers/infiniband/hw/irdma/uda_d.h
 create mode 100644 drivers/infiniband/hw/irdma/uk.c
 create mode 100644 drivers/infiniband/hw/irdma/user.h
 create mode 100644 drivers/infiniband/hw/irdma/utils.c
 create mode 100644 drivers/infiniband/hw/irdma/verbs.c
 create mode 100644 drivers/infiniband/hw/irdma/verbs.h
 create mode 100644 drivers/infiniband/hw/irdma/ws.c
 create mode 100644 drivers/infiniband/hw/irdma/ws.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 create mode 100644 include/uapi/rdma/irdma-abi.h

-- 
1.8.3.1
