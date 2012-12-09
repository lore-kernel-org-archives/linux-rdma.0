From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] Fix opensm clang warnings
Date: Sun, 9 Dec 2012 03:03:25 -0800 (PST)
Message-ID: <alpine.BSF.2.00.1212090302530.64779@toaster.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix clang errors on Fedora 17 [that are also triggered on FreeBSD with clang]
with the opensm component.

Garrett Cooper (3):
   Fix -Wtautological-compare warnings with clang
   Fix -Wformat-security warnings with clang
   Avoid linker error with clang 3.0

  libvendor/osm_vendor_ibumad.c |  5 +--
  opensm/osm_helper.c           | 96 +++++++++++++++++++++----------------------
  opensm/osm_qos_parser_y.y     |  6 +--
  opensm/st.c                   |  2 -
  osmtest/osmtest.c             |  2 +-
  5 files changed, 52 insertions(+), 59 deletions(-)

-- 
1.8.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
