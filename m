From: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/4] ibacm: acmp retry issues
Date: Tue, 14 Nov 2017 11:43:00 -0500
Message-ID: <20171114164006.24557.72093.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While testing the retry mechanism for the acmp provider, I observed
that the retry event_wait() did not appear to be working correctly.
After studying the issue a bit more, I discovered that there were a
couple of issues.

This patch set addresses those issues.

v2 - added patch for MONOTONIC time base
v3 - Updated and cleaned various type cast issues

---

Michael J. Ruhl (4):
      ibacm: Fix an incorrect expiration check for the retry timer
      ibacm: Calculate correct tv_nsec value in event_wait()
      ibacm: Fix a retry loop calculation race condition
      ibacm: Use MONOTONIC time base to avoid timer expiration issues


 ibacm/linux/osd.h          |   25 ++++++++++++++++---------
 ibacm/prov/acmp/src/acmp.c |   12 +++++++-----
 2 files changed, 23 insertions(+), 14 deletions(-)

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
