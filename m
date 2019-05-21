From: Parav Pandit <parav@mellanox.com>
Subject: [PATCH iproute2-next 0/4] Enrich rdma tool for net namespace commands
Date: Tue, 21 May 2019 09:22:40 -0500
Message-ID: <20190521142244.8452-1-parav@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, stephen@networkplumber.org, leonro@mellanox.com, parav@mellanox.com
List-Id: linux-rdma@vger.kernel.org

RDMA subsystem can be running in either of the modes.
(a) Sharing RDMA devices among multiple net namespaces or
(b) Exclusive mode where RDMA device is bound to single net namespace 

This patch series adds
(1) query command to query rdma subsystem sharing mode
(2) set command to change rdma subsystem sharing mode
(3) assign rdma device to a net namespace

rdma tool examples:
(a) Query current rdma subsys net namespace sharing mode 
$ rdma sys show
netns shared

(b) Change rdma subsys mode to exclusive mode
$ rdma sys set netns exclusive

$ rdma sys show
netns exclusive

(c) Assign rdma device to a specific newly created net namespace
$ ip netns add foo
$ rdma dev set mlx5_1 netns foo 


Parav Pandit (4):
  rdma: Add an option to query,set net namespace sharing sys parameter
  rdma: Add man pages for rdma system commands
  rdma: Add an option to set net namespace of rdma device
  rdma: Add man page for rdma dev set netns command

 man/man8/rdma-dev.8    |  18 +++++-
 man/man8/rdma-system.8 |  82 +++++++++++++++++++++++
 man/man8/rdma.8        |   7 +-
 rdma/Makefile          |   2 +-
 rdma/dev.c             |  37 +++++++++++
 rdma/rdma.c            |   3 +-
 rdma/rdma.h            |   1 +
 rdma/sys.c             | 143 +++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c           |   1 +
 9 files changed, 289 insertions(+), 5 deletions(-)
 create mode 100644 man/man8/rdma-system.8
 create mode 100644 rdma/sys.c

-- 
2.19.2
