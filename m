From: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] updated patch for improving node descriptions.
Date: Fri, 18 Feb 2011 16:29:08 -0500
Message-ID: <20110218212723.21364.92709.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Updated the code as per Roland's requests, except for one part:

Roland, I tried to rework the main function to be cleaner, because of the
need to split the hostname from the domain name and the need to not
modify the original source string, using library functions made things
worse than the existing pointer math.

---

Michael Heinz (2):
      Function for improved node descriptions
      Add support for ib_build_node_desc() to the HCAs.


 drivers/infiniband/core/mad.c           |   19 +++++++++++++++++++
 drivers/infiniband/hw/ipath/ipath_mad.c |    2 +-
 drivers/infiniband/hw/mlx4/mad.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c |    2 +-
 drivers/infiniband/hw/qib/qib_mad.c     |    2 +-
 include/rdma/ib_mad.h                   |    9 +++++++++
 6 files changed, 32 insertions(+), 4 deletions(-)

-- 
Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
