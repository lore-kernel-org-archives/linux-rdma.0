From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 27 May 2010 15:18:13 -0700
Message-ID: <ada6329vviy.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This is pretty much settled down to fixes -- one semantic patch
cleanup from Julia Lawall and then some fixes to the new qib driver.

The following changes since commit ec96e2fe954c23a54bfdf2673437a39e193a1822:

  Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm (2010-05-25 12:06:33 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Julia Lawall (1):
      IB/ucm: Use memdup_user()

Ralph Campbell (3):
      IB/qib: Fix undefined symbol error when CONFIG_PCI_MSI=n
      IB/qib: Use a single txselect module parameter for serdes tuning
      IB/qib: Remove DCA support until feature is finished

Roland Dreier (2):
      IB/qib: Don't rely on (undefined) order of function parameter evaluation
      Merge branches 'misc' and 'qib' into for-next

 drivers/infiniband/core/ucm.c           |   11 +-
 drivers/infiniband/hw/qib/qib_fs.c      |   25 +-
 drivers/infiniband/hw/qib/qib_iba6120.c |   12 -
 drivers/infiniband/hw/qib/qib_iba7322.c |  771 +++++++------------------------
 drivers/infiniband/hw/qib/qib_init.c    |    6 +
 5 files changed, 203 insertions(+), 622 deletions(-)

-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
