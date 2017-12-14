From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH v4 net-next 0/8] Hisilicon Network Subsystem 3 VF Ethernet Driver
Date: Thu, 14 Dec 2017 18:03:01 +0000
Message-ID: <20171214180309.14480-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patch-set contains the support of the HNS3 (Hisilicon Network Subsystem 3)
Virtual Function Ethernet driver for hip08 family of SoCs. The Physical Function
driver is already part of the Linux mainline. 

This VF driver has its Hardware Compatibility Layer and has commom/unified ENET
layer/client/ethtool code with the PF driver. It also has support of mailbox to
communicate with the HNS3 PF driver. The basic architecture of VF driver is
derivative of the PF driver. Just like PF driver, this driver is also PCI
Express based.

This driver is the ongoing development work and HNS3 VF Ethernet driver would be
incrementally enhanced with more new features.

High Level Architecture:

                     [ Ethtool ]
	                 | 
                 [ Ethernet Client ] ... [ RoCE Client ] 
                         |                     |           
                   [ HNAE Device ]             |________       
                         |                     |       |
    ---------------------------------------------      |
                                                       |
     [ HNAE3 Framework (Register/unregister) ]         |
                                                       |
    ---------------------------------------------      |
                         |                             |
                 [ VF HCLGE Layer ]                    |
                  |             |                      |
                  |             |                      |
                  |             |                      |
                  |     [ VF Mailbox (To PF via IMP) ] |                 
                  |             |                      |   
             [ IMP command Interface ]  [ IMP command Interface ]
                        |                              |
                        |                              |
           (A B O V E  R U N S  O N  G U E S T  S Y S T E M)
    -------------------------------------------------------------
              Q E M U / V F I O / K V M (on Host System)
    -------------------------------------------------------------
            HIP08  H A R D W A R E (limited to VF by SMMU)

   [ IMP/Mgmt Processor (hardware common to system/cmd based) ]


                Fig 1.   HNS3 Virtual Function Driver


                    

    	[ dcbnl ]  [ Ethtool ]
            |          |
   	[  Ethernet Client  ]  [ ODP/UIO Client ] . . .[ RoCE Client ]     
              |_____________________|                 |
                         |                   _________|        
                   [ HNAE Device ]           |        |
                         |                   |        |
    ---------------------------------------------     |
                                                      |
     [ HNAE3 Framework (Register/unregister) ]        |
                                                      |
    ---------------------------------------------     |
                         |                            |
                  [ HCLGE Layer ]                     |
         ________________|_________________           |
        |                |                 |          |
     [ DCB ]             |                 |          |
        |                |                 |          |
  [ Scheduler/Shaper ] [ MDIO ]      [ PF Mailbox ]   |
        |                |                 |          |
        |________________|_________________|          |     
                         |                            |
             [ IMP command Interface ]     [ IMP command Interface ] 
    ----------------------------------------------------------------
              HIP08  H A R D W A R E                  

  [ IMP/Mgmt Processor (hardware common to system/cmd based) ]


               Fig 2.    Existing HNS3 PF Driver (added with mailbox)


Change Log Summary:
Patch V4: Addressed SPDX related comment by Philippe Ombredanne
Patch V3: Addressed SPDX change requested by Philippe Ombredanne
Patch V2: 1. Addressed some comments by David Miller.
	  2. Addressed some internal comments on various patches
Patch V1: Initial Submit


Salil Mehta (8):
  net: hns3: Add HNS3 VF IMP(Integrated Management Proc) cmd interface
  net: hns3: Add mailbox support to VF driver
  net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support
  net: hns3: Add HNS3 VF driver to kernel build framework
  net: hns3: Unified HNS3 {VF|PF} Ethernet Driver for hip08 SoC
  net: hns3: Add mailbox support to PF driver
  net: hns3: Change PF to add ring-vect binding & resetQ to mailbox
  net: hns3: Add mailbox interrupt handling to PF driver

 drivers/net/ethernet/hisilicon/Kconfig             |   28 +-
 drivers/net/ethernet/hisilicon/hns3/Makefile       |    7 +
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   88 ++
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   14 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    7 +-
 .../hisilicon/hns3/{hns3pf => }/hns3_dcbnl.c       |    2 +-
 .../hisilicon/hns3/{hns3pf => }/hns3_enet.c        |    2 +
 .../hisilicon/hns3/{hns3pf => }/hns3_enet.h        |    0
 .../hisilicon/hns3/{hns3pf => }/hns3_ethtool.c     |   22 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |    8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  207 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   17 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  410 ++++++
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |    9 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  342 +++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  256 ++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 1490 ++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  164 +++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  181 +++
 19 files changed, 3132 insertions(+), 122 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
 rename drivers/net/ethernet/hisilicon/hns3/{hns3pf => }/hns3_dcbnl.c (97%)
 rename drivers/net/ethernet/hisilicon/hns3/{hns3pf => }/hns3_enet.c (99%)
 rename drivers/net/ethernet/hisilicon/hns3/{hns3pf => }/hns3_enet.h (100%)
 rename drivers/net/ethernet/hisilicon/hns3/{hns3pf => }/hns3_ethtool.c (97%)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c

-- 
2.7.4
