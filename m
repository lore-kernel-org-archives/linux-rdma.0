From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: [PATCH v3 1/3] Documentation/ABI: document /sys/class/net/*/dev_port
Date: Mon,  3 Sep 2018 19:13:14 +0300
Message-ID: <20180903161316.25121-2-ar@cs.msu.ru>
References: <20180903161316.25121-1-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180903161316.25121-1-ar@cs.msu.ru>
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
 Documentation/ABI/testing/sysfs-class-net | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index 2f1788111cd9..ec2232f6a949 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -91,6 +91,24 @@ Description:
 		stacked (e.g: VLAN interfaces) but still have the same MAC
 		address as their parent device.
 
+What:		/sys/class/net/<iface>/dev_port
+Date:		February 2014
+KernelVersion:	3.15
+Contact:	netdev@vger.kernel.org
+Description:
+		Indicates the port number of this network device, formatted
+		as a decimal value. Some NICs have multiple independent ports
+		on the same PCI bus, device and function. This attribute allows
+		userspace to distinguish the respective interfaces.
+
+		Note: some device drivers started to use 'dev_id' for this
+		purpose since long before 3.15 and have not adopted the new
+		attribute ever since. To query the port number, some tools look
+		exclusively at 'dev_port', while others only consult 'dev_id'.
+		If a network device has multiple client adapter ports as
+		described in the previous paragraph and does not set this
+		attribute to its port number, it's a kernel bug.
+
 What:		/sys/class/net/<iface>/dormant
 Date:		March 2006
 KernelVersion:	2.6.17
-- 
2.19.0.rc1
