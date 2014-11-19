From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/3] Ibacm/ibacmp bug fixes
Date: Wed, 19 Nov 2014 09:46:44 -0500
Message-ID: <1416408407-6774-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch series fixes a print format error and two bugs related to SM restart.


Kaike Wan (3):
  ibacmp: missing '%' in acm_log format
  ibacm: close the provider endpoint when it fails to assign a name to
    a core endpoint
  ibacm/ibacmp: fix a crash when SM restarts

 prov/acmp/src/acmp.c |    6 +++++-
 src/acm.c            |    9 ++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
