From: Mustafa Ismail <mustafa.ismail@intel.com>
Subject: [PATCH v2 0/2] Fix modify_qp failure
Date: Fri, 14 Jul 2017 09:41:29 -0500
Message-ID: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, dledford@redhat.com
Cc: swise@opengridcomputing.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, e1000-rdma@lists.sourceforge.net, shiraz.saleem@intel.com
List-Id: linux-rdma@vger.kernel.org

Commit 5ecce4c9b17b("Check port number supplied by user verbs cmds") causes
modify_qp to fail because port_num is only valid when the mask is set.

Additionally, for iWARP, the port_num is not initialized which also
causes modify_qp to fail.

This series fixes both issues.

Changes to V2:
* Add reviewed-by
* Cc: <stable@vger.kernel.org>

Mustafa Ismail (2):
  RDMA/uverbs: Fix the check for port number
  RDMA/core: Initialize port_num in qp_attr

 drivers/infiniband/core/cma.c        | 2 ++
 drivers/infiniband/core/uverbs_cmd.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.7.4
