From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 0/3] Fix remaining Debian build failures
Date: Thu, 16 Nov 2017 17:32:43 +0100
Message-ID: <20171116163246.29736-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the remaining build failures on
https://buildd.debian.org/status/package.php?p=rdma-core and the Travis CI
build failure.

Benjamin Drung (3):
  debian: Include architecture.mk for DEB_HOST_ARCH definition
  debian: Add alpha, hppa, sh4 as non-coherent DMA archs
  debian: Do not require valgrind on x32

 debian/control | 2 +-
 debian/rules   | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
