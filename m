From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 0/3] libibverbs: Add I/O memory registration verbs
Date: Thu, 29 Jul 2010 11:31:46 -0500
Message-ID: <20100729163030.14901.87547.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series adds support for the new I/O memory registration services
to libibverbs.

---

Tom Tucker (3):
      libibverbs: Add reg/unreg I/O memory verbs
      libibverbs: Add reg/unreg I/O memory commands to kern ABI
      libibverbs: Fix libtool configure warning


 configure.in                  |    1 +
 include/infiniband/driver.h   |    6 ++++++
 include/infiniband/kern-abi.h |   32 +++++++++++++++++++++++++++++++-
 include/infiniband/verbs.h    |   14 ++++++++++++++
 src/cmd.c                     |   41 +++++++++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |    5 +++++
 src/verbs.c                   |   35 +++++++++++++++++++++++++++++++++++
 7 files changed, 133 insertions(+), 1 deletions(-)

-- 
Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
