From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 0/3] Misc fixes
Date: Wed, 30 Mar 2016 18:39:17 +0300
Message-ID: <1459352360-32663-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series handles few issues:
- Add an example to ibv_create_flow man page.
- Handle few issues in ibv_xsrq_pingpong example.

Thanks,
Yishai


Noa Osherovich (2):
  Fix exchange message size in ibv_xsrq_pinpong example
  Add GID support to ibv_xsrq_pingpong example

Yishai Hadas (1):
  Add an example to ibv_create_flow man page

 examples/pingpong.c      | 10 -------
 examples/pingpong.h      |  1 -
 examples/xsrq_pingpong.c | 72 ++++++++++++++++++++++++++++++++++++++++--------
 man/ibv_create_flow.3    | 62 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 23 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
