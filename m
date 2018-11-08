From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 0/4] Remove VLAN_TAG_PRESENT from drivers
Date: Thu, 08 Nov 2018 18:44:46 +0100
Message-ID: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>, Faisal Latif <faisal.latif@intel.com>, Pravin B Shelar <pshelar@ovn.org>, Shiraz Saleem <shiraz.saleem@intel.com>, dev@openvswitch.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This series removes VLAN_TAG_PRESENT use from network drivers in
preparation to removing its special meaning.

Michał Mirosław (4):
  i40iw: remove use of VLAN_TAG_PRESENT
  cnic: remove use of VLAN_TAG_PRESENT
  gianfar: remove use of VLAN_TAG_PRESENT
  OVS: remove use of VLAN_TAG_PRESENT

 drivers/infiniband/hw/i40iw/i40iw_cm.c        |  8 +++----
 drivers/net/ethernet/broadcom/cnic.c          |  2 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  8 +++----
 net/openvswitch/actions.c                     | 13 +++++++----
 net/openvswitch/flow.c                        |  4 ++--
 net/openvswitch/flow.h                        |  2 +-
 net/openvswitch/flow_netlink.c                | 22 +++++++++----------
 7 files changed, 31 insertions(+), 28 deletions(-)

-- 
2.19.1
