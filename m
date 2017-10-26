From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 26 Oct 2017 14:05:08 -0400
Message-ID: <1509041108.3325.67.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This is the fix for the oops that I alerted you to earlier this week
and it's the only thing in the pull request.  Here's the boilerplate:

The following changes since commit 789f903fd75036f937409a9a1616a5a5e5cc5bae:

  i40iw: Fix port number for query QP (2017-10-04 15:28:49 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

for you to fetch changes up to b4d91aeb6e120b7e2f207021c31b914895c69bc4:

  RDMA/netlink: OOPs in rdma_nl_rcv_msg() from misinterpreted flag (2017-10-25 14:54:43 -0400)

----------------------------------------------------------------
Fourth -rc update for 4.14 kernel

- Fix an oops issue in the new RDMA netlink code

----------------------------------------------------------------
Michael J. Ruhl (1):
      RDMA/netlink: OOPs in rdma_nl_rcv_msg() from misinterpreted flag

 drivers/infiniband/core/netlink.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
