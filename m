From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch libibverbs 0/5] Minor updates
Date: Sun, 14 Oct 2012 13:02:58 -0400
Message-ID: <cover.1350234101.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a short series of fixes for minor issues.  The most important
being a memcpy buffer overrun on ppc arch for the compatibility wrapper.
The rest are usability fixes for the example programs.

Doug Ledford (5):
  Add an error when the user specifies an invalid port
  Don't allow port == 0 as an option
  Fix the compatibility wrapper on ppc
  Don't print link phys state on iWARP
  Don't try to send UD messages larger than MTU

 examples/devinfo.c     |   15 +++++++++++----
 examples/ud_pingpong.c |   14 ++++++++++++++
 src/compat-1_0.c       |   42 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 65 insertions(+), 6 deletions(-)

-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
