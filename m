From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 0/2] Add receive flow steering support
Date: Thu,  6 Feb 2014 14:20:31 +0200
Message-ID: <1391689233-12968-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

These two patches add flow-steering support to libibverbs

The patches are against your tree + the IP addressing UD patches
sent earlier this week.

Or.

Matan Barak (2):
  Add general definitions to support uverbs extensions
  Add receive flow steering support

 include/infiniband/driver.h   |    4 +
 include/infiniband/kern-abi.h |  135 ++++++++++++++++++++++++++++++++++++++++-
 include/infiniband/verbs.h    |  128 ++++++++++++++++++++++++++++++++++++++-
 src/cmd.c                     |  105 ++++++++++++++++++++++++++++++++
 src/device.c                  |    4 +
 src/ibverbs.h                 |   29 +++++++++
 src/libibverbs.map            |    2 +
 7 files changed, 405 insertions(+), 2 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
