From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Thu, 30 Nov 2017 13:39:37 +0100
Message-ID: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch set contains the packaging changes from the Debian unstable 15.1-1
upload.

Benjamin Drung (3):
  debian: Add m68k as non-coherent DMA architecture
  debian: Mark libraries as Multi-Arch: same
  debian: Update changelog to include Debian uploads

 debian/changelog | 31 +++++++++++++++++++++++++++++++
 debian/control   |  6 ++++++
 debian/rules     |  2 +-
 3 files changed, 38 insertions(+), 1 deletion(-)

-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
