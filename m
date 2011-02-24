From: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] Improved Node Descriptions
Date: Wed, 23 Feb 2011 21:24:38 -0500
Message-ID: <20110224022124.26808.62012.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
Cc: todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The common practice in IB fabrics is to set the description of an HCA to be 
the hostname of the machine plus a description (i.e., "myhost hca-1", "myhost 
hca-2", etc..)

This has a limitation, however.  The first is that if the machine's hostname 
is set via DHCP, the HCA description may be set before the hostname is, leading 
to an incorrect description. This can also occur if the machine's hostname 
changes for some other reason after boot.

This can cause difficulties and confusion when trying to maintain a large 
fabric - if all your nodes are described as "localhost HCA-1" it can be very 
difficult to figure out which node is suffering from symbol errors.

This patch addresses the problem by providing a function to build the node 
description. If the provided source string for the description contains a '%h' 
it will be replaced at read time with the hostname of the node. If the provided 
source string contains a '%d' it will be replaced at read time with the name of 
the HCA.  For example, the first Mellanox HCA on a node called "homer" would 
have the default description:

homer: mthca0 MT25208 InfiniHostEx Mellanox Technologies

While the default description for the second QLogic HCA on node-a13 would be: 

node-a2: qib0 QLogic kernel.org driver

This ensures that even after a fabric has been completely initialized, if a 
node's hostname changes, that change will be reflected in the next sweep of the 
SM, but also maintains compatibility with existing code since the behavior is 
unchanged if the description string does not contain a '%' character.

Changes from Version 1:

Replaced the original substitution of the hostname for '@' with an 
implementation of the '%h' and '%d' fields, and changed the default node 
description for Mellanox and QLogic HCA types to default to 
"%h: %d <description>" where '<description>' is the old default message.

---

Michael Heinz (2):
      Function for improved node descriptions
      Add support for ib_build_node_desc() to the HCAs.


 drivers/infiniband/core/mad.c                |   33 ++++++++++++++++++++++++++
 drivers/infiniband/hw/ipath/ipath_mad.c      |    2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    4 ++-
 drivers/infiniband/hw/mlx4/mad.c             |    2 +-
 drivers/infiniband/hw/mlx4/main.c            |    3 ++
 drivers/infiniband/hw/mthca/mthca_mad.c      |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    3 ++
 drivers/infiniband/hw/qib/qib_mad.c          |    2 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |    2 +-
 include/rdma/ib_mad.h                        |    9 +++++++
 10 files changed, 53 insertions(+), 9 deletions(-)

-- 
Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
