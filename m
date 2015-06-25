From: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [infiniband-diags PATCH 0/2] libudev usage fixes
Date: Thu, 25 Jun 2015 16:12:00 +0200
Message-ID: <1435241522-7721-1-git-send-email-mschmidt@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,
the first patch simplifies code.
The second patch fixes an overlinking issue.
Regards,
Michal

Michal Schmidt (2):
  rdma-ndd: never use udev_get_sys_path()
  build-sys: avoid overlinking to libudev

 Makefile.am    |  6 ++++++
 configure.ac   | 10 +++++-----
 src/rdma-ndd.c | 19 +++++--------------
 3 files changed, 16 insertions(+), 19 deletions(-)

-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
