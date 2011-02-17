From: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Improved node descriptions
Date: Thu, 17 Feb 2011 16:30:57 -0500
Message-ID: <20110217213017.25708.95042.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The common practice in IB fabrics is to set the description of an HCA to be
the hostname of the machine plus a description (i.e., "myhost hca-1",
"myhost hca-2", etc..)

This has a limitation, however.  The first is that if the machine's
hostname is set via DHCP, the HCA description may be set before the hostname
is, leading to an incorrect description. This can also occur if the machine's
hostname changes for some other reason after boot.

This can cause difficulties and confusion when trying to maintain a large
fabric - if all your nodes are described as "localhost HCA-1" it can be very
difficult to figure out which node is suffering from symbol errors.

This patch addresses the problem by providing a function to build the node
description. If the provided source string for the description contains an
'@' character, the function will substitute the current utsname.

This ensures that even after a fabric has been completely initialized, if
a node's hostname changes, that change will be reflected in the next sweep
of the SM, but also maintains compatibility with existing code since the
behavior is unchanged if the description string does not contain an '@'
character.

---

Michael Heinz (2):
      Improved node descriptions
      Making it easier to diagnose fabric problems by improving the node descriptions.


 drivers/infiniband/core/mad.c           |   18 ++++++++++++++++++
 drivers/infiniband/hw/ipath/ipath_mad.c |    2 +-
 drivers/infiniband/hw/mlx4/mad.c        |    3 ++-
 drivers/infiniband/hw/mthca/mthca_mad.c |    3 ++-
 drivers/infiniband/hw/qib/qib_mad.c     |    2 +-
 include/rdma/ib_mad.h                   |    8 ++++++++
 6 files changed, 32 insertions(+), 4 deletions(-)

-- 
Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
