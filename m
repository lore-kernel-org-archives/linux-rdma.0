From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH] libmthca: Add support for I/O memory registration verbs
Date: Thu, 29 Jul 2010 11:36:45 -0500
Message-ID: <20100729163624.15024.57249.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset adds support for the new I/O memory registration verbs to
libmthca.

---

Tom Tucker (1):
      libmthca: Add support for the reg_io_mr verb.


 src/mthca-abi.h |    4 ++++
 src/mthca.c     |    2 ++
 src/mthca.h     |    4 ++++
 src/verbs.c     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 0 deletions(-)

-- 
Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
