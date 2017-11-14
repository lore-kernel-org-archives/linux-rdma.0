From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 0/6] More Debian packaging cleanup
Date: Tue, 14 Nov 2017 21:02:41 +0100
Message-ID: <20171114200247.25890-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series contain some packaging clean-up.

Benjamin Drung (6):
  debian: Let libibverbs1 16 break ibverbs-providers 15
  debian: Replace priority extra by optional
  debian: Relax dh-systemd build dependency
  debian: Bump Standards-Version to 4.1.1
  debian: Drop lintian overrides for false positives
  debian: Run wrap-and-sort

 debian/control                         | 10 +++-------
 debian/libibumad-dev.lintian-overrides |  3 ---
 debian/libibumad3.lintian-overrides    |  2 --
 debian/libibverbs-dev.install          |  2 +-
 debian/rdma-core.install               |  2 +-
 5 files changed, 5 insertions(+), 14 deletions(-)
 delete mode 100644 debian/libibumad-dev.lintian-overrides
 delete mode 100644 debian/libibumad3.lintian-overrides

-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
