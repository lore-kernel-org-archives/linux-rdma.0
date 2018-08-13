From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: [PATCH 0/3] net, IB/ipoib: Use dev_port to disambiguate
Date: Mon, 13 Aug 2018 14:42:21 +0300
Message-ID: <20180813114224.7065-1-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Arseny Maslennikov <ar@cs.msu.ru>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Pre-3.15 userspace had trouble distinguishing different ports of a NIC
on a single PCI bus/device/function. To solve this, a sysfs field `dev_port'
was introduced quite a while ago (commit v3.14-rc3-739-g3f85944fe207), and
some relevant device drivers were fixed to use it, but not in case of IPoIB.

The convention for some reason never got documented in the kernel, but
was immediately adopted by userspace (notably udev[1][2], biosdevname[3])

3/3 documents the sysfs field — that's why I'm CC-ing netdev.

This series was tested on current LTS and 4.18.

[1] https://lists.freedesktop.org/archives/systemd-devel/2014-June/020788.html
[2] https://lists.freedesktop.org/archives/systemd-devel/2014-July/020804.html
[3] https://github.com/CloudAutomationNTools/biosdevname/blob/c795d51dd93a5309652f0d635f12a3ecfabfaa72/src/eths.c#L38

Arseny Maslennikov (3):
  IB/ipoib: Use dev_port to expose network interface port numbers
  IB/ipoib: Stop using dev_id to expose port numbers
  Documentation/ABI: document /sys/class/net/*/dev_port

 Documentation/ABI/testing/sysfs-class-net | 10 ++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.18.0
