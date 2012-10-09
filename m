From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/5] [librdmacm] librdmacm: batch of fixes
Date: Tue,  9 Oct 2012 14:27:47 +0200
Message-ID: <1349785672-1921-1-git-send-email-dotanb@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here is a small batch of fixes for librdmacm.

Dotan Barak (5):
  rsocket: add missing va_end() after calling va_end()
  rsocket: added missing break
  rstream: initialize return value in server_connect()
  rstream: added missing return is accept() failed
  rping: added checks to the return values functions

 examples/rping.c   |   21 ++++++++++++++++++---
 examples/rstream.c |    3 ++-
 src/rsocket.c      |    2 ++
 3 files changed, 22 insertions(+), 4 deletions(-)

-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
