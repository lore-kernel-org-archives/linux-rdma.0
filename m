From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 00/50] Add OPA gen1 driver
Date: Thu, 30 Jul 2015 15:17:27 -0400
Message-ID: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patch series adds the OPA device driver.
 
Like qib the driver has 2 main interfaces, Verbs and a new PSM2 interface.
 
The PSM2 interface evolves PSM for OPA due to hardware specific changes.
 
As a verbs driver the device functions as an InfiniBand device and
supports the standard features of the IBTA specification v1.3 with
the exceptions noted below.
 
Addressing is accomplished via IBTA compatible headers which leaves
Path Record resolution, rdmacm, and IB CM functionality intact.
 
Furthermore, the interaction between this driver and the ib_core,
rdmacm, ib_cm, ib_sa, and ULP modules are handled completely via the
existing verbs interfaces.  This includes compliance with the IB SA queries
(most importantly Path Records and Multicast Joins) and CM protocols which
are documented in the IBTA spec.
 
The following exceptions to the IBTA specification exist:
 
Enhanced and additional SMA and PMA MADs are utilized for management.  As
previously discussed on the list and accepted by Doug; device support for
these new MADs is reported through the new immutable data interface.
 
Larger MTU values can _optionally_ be passed through the verbs interface
to indicate 8K and "10K" MTUs.  This is opaque to users of Path Record
queries.  More importantly the _standard_ IBTA MTUs are fully supported.
 
A larger packet sequence number is used internally by the driver.
 
Additional QoS features, which are opaque to the user, are supported via
additional SL to VL tables.

The public information can be reviewed at:

http://www.intel.com/content/www/us/en/omni-path/omni-path-fabric-overview.html

The patches are based on the the following repo/branch:
	git://github.com/dledford/linux.git: to-be-rebased/for-4.3

The patches add the files and headers and the last
patch adds the build hooks.

Differences from v3
- Get rid of BUG_ON() usage
- 125 internal fixes
- Removed some more unneeded sysfs files
- Add documentation on sysfs usage
- ported from qib
  o commit d1adbfa5dd58642cde08f2f7773f37b6fafc7b64
  o commit 83efc96cd2dbb42971831dda007b521cf6d92ac5

Differences from v2 to v3:
- Remove verbs sysfs counters since they can be metered via other mechanisms
- Move ib-ish defintions from mad.h to ib_mad.h since they are driver
  independent
- Modified create_cq to better implements the API changes

Differences from v1 to v2:
- larger files split are split up due to filesize issues
- 0 day build issues with cpumask usage
- 0 day RCU sparse issues
- Adjustments for create_cq() and query_device() to compile

---

Dennis Dalessandro (1):
      IB: Add CNP opcode enumeration.

Ira Weiny (1):
      IB/core: Add header definitions

Jubin John (1):
      IB/core: Add opa driver to kbuild

Mike Marciniszyn (47):
      IB/hfi1: add chip specific support part1
      IB/hfi1: add chip specific support part2
      IB/hfi1: add chip specific support part3
      IB/hfi1: add chip specific support part4
      IB/hfi1: add chip register definitions
      IB/hfi1: add chip specific headers
      IB/hfi1: add common header file definitions
      IB/hfi1: add completion queue processing
      IB/hfi1: add debugfs handling
      IB/hfi1: add char device instantiation code
      IB/hfi1: add diagnostic hooks
      IB/hfi1: add dma operation hooks
      IB/hfi1: add low level receive functions
      IB/hfi1: add eeprom hooks
      IB/hfi1: add PSM driver control/data path
      IB/hfi1: add firmware hooks
      IB/hfi1: add general hfi header file
      IB/hfi1: add module init hooks
      IB/hfi1: add interrupt hooks
      IB/hfi1: add progress delay/restart hooks
      IB/hfi1: add rkey/lkey validation
      IB/hfi1: add OPA mad handling part1
      IB/hfi1: add OPA mad handling part2
      IB/hfi1: add local mad header
      IB/hfi1: add user/kernel memory sharing hooks
      IB/hfi1: add memory region handling
      IB/hfi1: add misc OPA defines
      IB/hfi1: add pcie routines
      IB/hfi1: add pio handling
      IB/hfi1: add platform config definitions
      IB/hfi1: add qp handling
      IB/hfi1: add qsfp handling
      IB/hfi1: add RC QP handling
      IB/hfi1: add common routines for RC/UC
      IB/hfi1: add sdma routines
      IB/hfi1: add sdma header file
      IB/hfi1: add SRQ handling
      IB/hfi1: add sysfs routines and documentation
      IB/hfi1: add tracepoint debug routines
      IB/hfi1: add QSFP twsi routines
      IB/hfi1: add UC QP handling
      IB/hfi1: add UD QP handling
      IB/hfi1: add low level page locking
      IB/hfi1: add PSM sdma hooks
      IB/hfi1: add general verbs handling
      IB/hfi1: add multicast routines
      IB/hfi1: add driver make/config files


 Documentation/infiniband/sysfs.txt           |   22 
 drivers/infiniband/Kconfig                   |    1 
 drivers/infiniband/hw/Makefile               |    1 
 drivers/infiniband/hw/hfi1/Kconfig           |   37 
 drivers/infiniband/hw/hfi1/Makefile          |   19 
 drivers/infiniband/hw/hfi1/chip.c            |10798 ++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/chip.h            | 1035 ++
 drivers/infiniband/hw/hfi1/chip_registers.h  | 1289 +++
 drivers/infiniband/hw/hfi1/common.h          |  415 +
 drivers/infiniband/hw/hfi1/cq.c              |  558 +
 drivers/infiniband/hw/hfi1/debugfs.c         |  899 ++
 drivers/infiniband/hw/hfi1/debugfs.h         |   78 
 drivers/infiniband/hw/hfi1/device.c          |  142 
 drivers/infiniband/hw/hfi1/device.h          |   61 
 drivers/infiniband/hw/hfi1/diag.c            | 1873 +++++
 drivers/infiniband/hw/hfi1/dma.c             |  186 
 drivers/infiniband/hw/hfi1/driver.c          | 1241 +++
 drivers/infiniband/hw/hfi1/eprom.c           |  475 +
 drivers/infiniband/hw/hfi1/eprom.h           |   55 
 drivers/infiniband/hw/hfi1/file_ops.c        | 2140 +++++
 drivers/infiniband/hw/hfi1/firmware.c        | 1620 ++++
 drivers/infiniband/hw/hfi1/hfi.h             | 1821 ++++
 drivers/infiniband/hw/hfi1/init.c            | 1722 ++++
 drivers/infiniband/hw/hfi1/intr.c            |  207 
 drivers/infiniband/hw/hfi1/iowait.h          |  186 
 drivers/infiniband/hw/hfi1/keys.c            |  411 +
 drivers/infiniband/hw/hfi1/mad.c             | 4257 ++++++++++
 drivers/infiniband/hw/hfi1/mad.h             |  325 +
 drivers/infiniband/hw/hfi1/mmap.c            |  192 
 drivers/infiniband/hw/hfi1/mr.c              |  546 +
 drivers/infiniband/hw/hfi1/opa_compat.h      |  129 
 drivers/infiniband/hw/hfi1/pcie.c            | 1253 +++
 drivers/infiniband/hw/hfi1/pio.c             | 1771 ++++
 drivers/infiniband/hw/hfi1/pio.h             |  224 +
 drivers/infiniband/hw/hfi1/pio_copy.c        |  858 ++
 drivers/infiniband/hw/hfi1/platform_config.h |  286 +
 drivers/infiniband/hw/hfi1/qp.c              | 1687 ++++
 drivers/infiniband/hw/hfi1/qp.h              |  235 +
 drivers/infiniband/hw/hfi1/qsfp.c            |  546 +
 drivers/infiniband/hw/hfi1/qsfp.h            |  222 +
 drivers/infiniband/hw/hfi1/rc.c              | 2426 ++++++
 drivers/infiniband/hw/hfi1/ruc.c             |  948 ++
 drivers/infiniband/hw/hfi1/sdma.c            | 2962 +++++++
 drivers/infiniband/hw/hfi1/sdma.h            | 1123 +++
 drivers/infiniband/hw/hfi1/srq.c             |  397 +
 drivers/infiniband/hw/hfi1/sysfs.c           |  761 ++
 drivers/infiniband/hw/hfi1/trace.c           |  211 +
 drivers/infiniband/hw/hfi1/trace.h           | 1421 +++
 drivers/infiniband/hw/hfi1/twsi.c            |  518 +
 drivers/infiniband/hw/hfi1/twsi.h            |   68 
 drivers/infiniband/hw/hfi1/uc.c              |  585 +
 drivers/infiniband/hw/hfi1/ud.c              |  885 ++
 drivers/infiniband/hw/hfi1/user_pages.c      |  156 
 drivers/infiniband/hw/hfi1/user_sdma.c       | 1444 +++
 drivers/infiniband/hw/hfi1/user_sdma.h       |   89 
 drivers/infiniband/hw/hfi1/verbs.c           | 2144 +++++
 drivers/infiniband/hw/hfi1/verbs.h           | 1149 +++
 drivers/infiniband/hw/hfi1/verbs_mcast.c     |  385 +
 drivers/infiniband/hw/qib/qib_mad.h          |  147 
 include/rdma/ib_mad.h                        |  138 
 include/rdma/ib_pack.h                       |    1 
 include/rdma/opa_port_info.h                 |  433 +
 include/rdma/opa_smi.h                       |   47 
 include/uapi/rdma/hfi/hfi1_user.h            |  427 +
 64 files changed, 58549 insertions(+), 139 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi1/Kconfig
 create mode 100644 drivers/infiniband/hw/hfi1/Makefile
 create mode 100644 drivers/infiniband/hw/hfi1/chip.c
 create mode 100644 drivers/infiniband/hw/hfi1/chip.h
 create mode 100644 drivers/infiniband/hw/hfi1/chip_registers.h
 create mode 100644 drivers/infiniband/hw/hfi1/common.h
 create mode 100644 drivers/infiniband/hw/hfi1/cq.c
 create mode 100644 drivers/infiniband/hw/hfi1/debugfs.c
 create mode 100644 drivers/infiniband/hw/hfi1/debugfs.h
 create mode 100644 drivers/infiniband/hw/hfi1/device.c
 create mode 100644 drivers/infiniband/hw/hfi1/device.h
 create mode 100644 drivers/infiniband/hw/hfi1/diag.c
 create mode 100644 drivers/infiniband/hw/hfi1/dma.c
 create mode 100644 drivers/infiniband/hw/hfi1/driver.c
 create mode 100644 drivers/infiniband/hw/hfi1/eprom.c
 create mode 100644 drivers/infiniband/hw/hfi1/eprom.h
 create mode 100644 drivers/infiniband/hw/hfi1/file_ops.c
 create mode 100644 drivers/infiniband/hw/hfi1/firmware.c
 create mode 100644 drivers/infiniband/hw/hfi1/hfi.h
 create mode 100644 drivers/infiniband/hw/hfi1/init.c
 create mode 100644 drivers/infiniband/hw/hfi1/intr.c
 create mode 100644 drivers/infiniband/hw/hfi1/iowait.h
 create mode 100644 drivers/infiniband/hw/hfi1/keys.c
 create mode 100644 drivers/infiniband/hw/hfi1/mad.c
 create mode 100644 drivers/infiniband/hw/hfi1/mad.h
 create mode 100644 drivers/infiniband/hw/hfi1/mmap.c
 create mode 100644 drivers/infiniband/hw/hfi1/mr.c
 create mode 100644 drivers/infiniband/hw/hfi1/opa_compat.h
 create mode 100644 drivers/infiniband/hw/hfi1/pcie.c
 create mode 100644 drivers/infiniband/hw/hfi1/pio.c
 create mode 100644 drivers/infiniband/hw/hfi1/pio.h
 create mode 100644 drivers/infiniband/hw/hfi1/pio_copy.c
 create mode 100644 drivers/infiniband/hw/hfi1/platform_config.h
 create mode 100644 drivers/infiniband/hw/hfi1/qp.c
 create mode 100644 drivers/infiniband/hw/hfi1/qp.h
 create mode 100644 drivers/infiniband/hw/hfi1/qsfp.c
 create mode 100644 drivers/infiniband/hw/hfi1/qsfp.h
 create mode 100644 drivers/infiniband/hw/hfi1/rc.c
 create mode 100644 drivers/infiniband/hw/hfi1/ruc.c
 create mode 100644 drivers/infiniband/hw/hfi1/sdma.c
 create mode 100644 drivers/infiniband/hw/hfi1/sdma.h
 create mode 100644 drivers/infiniband/hw/hfi1/srq.c
 create mode 100644 drivers/infiniband/hw/hfi1/sysfs.c
 create mode 100644 drivers/infiniband/hw/hfi1/trace.c
 create mode 100644 drivers/infiniband/hw/hfi1/trace.h
 create mode 100644 drivers/infiniband/hw/hfi1/twsi.c
 create mode 100644 drivers/infiniband/hw/hfi1/twsi.h
 create mode 100644 drivers/infiniband/hw/hfi1/uc.c
 create mode 100644 drivers/infiniband/hw/hfi1/ud.c
 create mode 100644 drivers/infiniband/hw/hfi1/user_pages.c
 create mode 100644 drivers/infiniband/hw/hfi1/user_sdma.c
 create mode 100644 drivers/infiniband/hw/hfi1/user_sdma.h
 create mode 100644 drivers/infiniband/hw/hfi1/verbs.c
 create mode 100644 drivers/infiniband/hw/hfi1/verbs.h
 create mode 100644 drivers/infiniband/hw/hfi1/verbs_mcast.c
 create mode 100644 include/rdma/opa_port_info.h
 create mode 100644 include/uapi/rdma/hfi/hfi1_user.h

-- 
Mike
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
