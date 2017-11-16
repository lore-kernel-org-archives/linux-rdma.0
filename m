From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 0/2] Debian packaging changes for 15-2
Date: Thu, 16 Nov 2017 13:29:35 +0100
Message-ID: <20171116122937.31770-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In addition to my previous set of packaging changes, here are the remaining
changes from my rdma-core 15-2 upload to Debian unstable. Let's see if
rdma-core builds now on all architectures. Build log overview:
https://buildd.debian.org/status/package.php?p=rdma-core

In addition, I added myself to MAINTAINERS.

Benjamin Drung (2):
  debian: Don't install disabled providers on archs that miss coherent
    DMA
  Add myself as Debian packaging maintainer

 MAINTAINERS  |  5 +++++
 debian/rules | 12 ++++++++++++
 2 files changed, 17 insertions(+)

-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
