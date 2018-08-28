From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: [PATCH 3/3] Documentation/ABI: document /sys/class/net/*/dev_port
Date: Wed, 29 Aug 2018 00:01:17 +0300
Message-ID: <20180828210117.6437-4-ar@cs.msu.ru>
References: <20180828210117.6437-1-ar@cs.msu.ru>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180828210117.6437-1-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Arseny Maslennikov <ar@cs.msu.ru>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The sysfs field was introduced 4 years ago along with fixes to various
drivers that erroneously used `dev_id' for that purpose, but it was not
properly documented anywhere.
See commit v3.14-rc3-739-g3f85944fe207.

Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
---
 Documentation/ABI/testing/sysfs-class-net | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index 2f1788111cd9..1593d8997ade 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -91,6 +91,16 @@ Description:
 		stacked (e.g: VLAN interfaces) but still have the same MAC
 		address as their parent device.
 
+What:		/sys/class/net/<iface>/dev_port
+Date:		February 2014
+KernelVersion:	3.15
+Contact:	netdev@vger.kernel.org
+Description:
+		Indicates the port number of this network device, formatted
+		as a decimal value. Some NICs have multiple independent ports
+		on the same PCI bus, device and function. This field allows
+		userspace to distinguish the respective interfaces.
+
 What:		/sys/class/net/<iface>/dormant
 Date:		March 2006
 KernelVersion:	2.6.17
-- 
2.18.0
