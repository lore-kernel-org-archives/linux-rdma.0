From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] Please pull an NFSoRDMA fix
Date: Thu, 5 Feb 2015 15:46:06 -0500
Message-ID: <54D3D68E.3000303@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Trond,

The following changes since commit a0a1d50cd1e80652142af5cddcde500d06c71bdd:

  xprtrdma: Update the GFP flags used in xprt_rdma_allocate() (2015-01-30 12:18:48 -0500)

are available in the git repository at:

  git://git.linux-nfs.org/projects/anna/nfs-rdma.git tags/nfs-rdma-for-3.20-part-2

for you to fetch changes up to b625a61698619c7af652de2701a2fb17c5c5d66e:

  xprtrdma: Address sparse complaint in rpcr_to_rdmar() (2015-02-05 15:38:29 -0500)

Thanks,
Anna

----------------------------------------------------------------
NFS: RDMA Client Sparse Fixes

This patch fixes a sparse warning in the initial submission.

Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>

----------------------------------------------------------------
Chuck Lever (1):
      xprtrdma: Address sparse complaint in rpcr_to_rdmar()

 net/sunrpc/xprtrdma/xprt_rdma.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
