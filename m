From: Rami Rosen <ramirose@gmail.com>
Subject: [PATCH] rdmacg: fix a typo in rdmacg documentation
Date: Tue, 23 Oct 2018 18:01:06 +0300
Message-ID: <20181023150106.7332-1-ramirose@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pandit.parav@gmail.com
Cc: tj@kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Rami Rosen <ramirose@gmail.com>
List-Id: linux-rdma@vger.kernel.org

This patch fixes a typo in RDMA cgroup documentation.

Signed-off-by: Rami Rosen <ramirose@gmail.com>
---
 Documentation/cgroup-v1/rdma.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-v1/rdma.txt
index af618171e0eb..9bdb7fd03f83 100644
--- a/Documentation/cgroup-v1/rdma.txt
+++ b/Documentation/cgroup-v1/rdma.txt
@@ -27,7 +27,7 @@ cgroup.
 Currently user space applications can easily take away all the rdma verb
 specific resources such as AH, CQ, QP, MR etc. Due to which other applications
 in other cgroup or kernel space ULPs may not even get chance to allocate any
-rdma resources. This can leads to service unavailability.
+rdma resources. This can lead to service unavailability.
 
 Therefore RDMA controller is needed through which resource consumption
 of processes can be limited. Through this controller different rdma
-- 
2.17.1
