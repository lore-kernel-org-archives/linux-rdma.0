From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] IPoIB TX NAPI
Date: Mon, 16 Oct 2017 08:48:58 +0300
Message-ID: <20171016054901.32479-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is very common in modern network devices to use NAPI in RX and TX,
in the UD/TX flows IPoIB uses a polling mechanism (not as it does in
the CM mode).

Except of the motivation to use the same mechanism for IPoIB as for
netdevices, there are number of issues in current polling mechanism:
 * SKBs that are kept longer than they should be and there are applications
   that warn about that (some firewalls for example).
 * Statistics that are not updated to the real value. It blocks support
   for time synchronization protocols over the IPoIB protocol, like PTP
   and so on.
 * The TX in CM mode already uses NAPI, there is no reason to keep two
   different ways for TX one for UD and one for the CM.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-16-2

	Thanks

Cc: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---------------------------------------

Erez Shitrit (3):
  IB/ipoib: Get rid of the tx_outstanding variable in all modes
  IB/ipoib: Use NAPI in UD/TX flows
  IB/ipoib: Change number of TX wqe to 64

 drivers/infiniband/ulp/ipoib/ipoib.h       |  14 ++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |  46 ++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    | 127 ++++++++++++++++++-----------
 drivers/infiniband/ulp/ipoib/ipoib_main.c  |  25 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  17 ++--
 5 files changed, 143 insertions(+), 86 deletions(-)

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
