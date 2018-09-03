From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: [PATCH v3 0/3] IB/ipoib: Use dev_port to disambiguate port numbers
Date: Mon,  3 Sep 2018 19:13:13 +0300
Message-ID: <20180903161316.25121-1-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Arseny Maslennikov <ar@cs.msu.ru>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Pre-3.15 userspace had trouble distinguishing different ports
of a NIC on a single PCI bus/device/function. To solve this,
a sysfs field `dev_port' was introduced quite a while ago
(commit v3.14-rc3-739-g3f85944fe207), and some relevant device
drivers were fixed to use it, but not in case of IPoIB.

The convention for some reason never got documented in the kernel, but
was immediately adopted by userspace (notably udev[1][2], biosdevname[3])

1/3 documents the sysfs field — that's why I'm CC-ing netdev.

This series was tested on and applies to 4.19-rc2.

[1] https://lists.freedesktop.org/archives/systemd-devel/2014-June/020788.html
[2] https://lists.freedesktop.org/archives/systemd-devel/2014-July/020804.html
[3] https://github.com/CloudAutomationNTools/biosdevname/blob/c795d51dd93a5309652f0d635f12a3ecfabfaa72/src/eths.c#L38

v1->v2: replace a line instead of inserting and then removing.
v2->v3: restore both attributes, output a notice of deprecation to kmsg.

Arseny Maslennikov (3):
  Documentation/ABI: document /sys/class/net/*/dev_port
  IB/ipoib: Use dev_port to expose network interface port numbers
  IB/ipoib: Log sysfs 'dev_id' accesses from userspace

 Documentation/ABI/testing/sysfs-class-net | 18 ++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 40 +++++++++++++++++++++++
 2 files changed, 58 insertions(+)

-- 
2.19.0.rc1
