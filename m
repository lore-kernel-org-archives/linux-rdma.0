From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/1] IPoIB: Improve parent interface p_key handling.
Date: Wed, 11 Jun 2014 15:21:27 -0400
Message-ID: <20140611191947.31937.75434.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes from v2:
Handle pkey change event for a case when interface is down
(pointed out by Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>).

Changes from v1:
p_key check for 'Invalid' value was moved to
ipoib_pkey_dev_check_presence() that is used now in ipoib_ib_dev_open()
for p_key validation.
Whitespace and format adjusted.

---

Alex Estrin (1):
      IPoIB: Improve parent interface p_key handling.


 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   35 +++++++++++++++++++------------
 1 files changed, 21 insertions(+), 14 deletions(-)

--
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
