From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH net-next 0/8] Hisilicon Network Subsystem 3 VF Ethernet Driver
Date: Sun, 3 Dec 2017 12:32:59 +0000
Message-ID: <20171203123307.19820-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch-set contains the support of the HNS3 (Hisilicon Network Subsystem 3)
Virtual Function Ethernet driver for hip08 family of SoCs. The Physical Function
driver is already part of the Linux mainline. 

This VF driver has its Hardware Compatibility Layer and has commom/unified ENET
layer/client/ethtool code with the PF driver. The basic architecture of VF driver
is derivative of the PF driver. Just like PF driver, this driver is also PCI
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

		[ IMP/Mgmt Processor ] (hardware common to system/cmd based)


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

		[ IMP/Mgmt Processor ]  (hardware common to system/cmd based)


               Fig 2.    Existing HNS3 PF Driver (added with mailbox)


NOTE: This patch depends upon https://lkml.org/lkml/2017/11/30/1079

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
 drivers/net/ethernet/hisilicon/hns3/Makefile       |    7 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   94 ++
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   14 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    7 +-
 .../hisilicon/hns3/{hns3pf => }/hns3_dcbnl.c       |    2 +-
 .../hisilicon/hns3/{hns3pf => }/hns3_enet.c        |    2 +
 .../hisilicon/hns3/{hns3pf => }/hns3_enet.h        |    0
 .../hisilicon/hns3/{hns3pf => }/hns3_ethtool.c     |   22 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |    7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  203 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   17 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  415 ++++++
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |    8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  341 +++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  262 ++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 1491 ++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  170 +++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  187 +++
 19 files changed, 3157 insertions(+), 120 deletions(-)
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
2.11.0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
