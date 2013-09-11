From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH krping 0/2] krping fixes to work with latest kernels
Date: Wed, 11 Sep 2013 17:20:22 +0300
Message-ID: <1378909224-27399-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Steve,

This little series from Alex makes krping from git://git.openfabrics.org/~swise/krping.git
usable for latest upstream kernels, something we find very useful for testing
the upstream RDMA stack when developing variuos features.

Or.

Alex Tabachnik (2):
  Fixes and changes to support latest kernels
  Update Makefile

 Makefile |   33 +++------------------------------
 krping.c |   33 +++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 44 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
