From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/2] libibmad: Modernize auto files.
Date: Mon, 26 Sep 2016 02:20:53 -0400
Message-ID: <1474870855-21158-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Update the Makefile and configure.in files to avoid autogen warnings.

Ira Weiny (2):
  libibmad: Makefile.am: Fix INCLUDES warning
  configure.ac: Update configure.in to configure.ac

 Makefile.am  |  2 +-
 configure.ac | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in | 66 ------------------------------------------------------------
 3 files changed, 67 insertions(+), 67 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
