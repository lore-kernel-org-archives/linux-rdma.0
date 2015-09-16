From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Wed, 16 Sep 2015 11:00:58 -0400
Message-ID: <1442415658-56124-1-git-send-email-dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This is a move only, no functional changes.  I tried to get it in prior
to the rc1 release, but we were waiting on IBM to get back to us that
they were OK with the deprecation and eventual removal of this driver.
That OK didn't materialize until last week, so integration and testing
time pushed us beyond the rc1 release.  If you don't mind, I would
appreciate keeping this in this release so that all three drivers we
are deprecating and removing are all on the same schedule.  Thanks!

The following changes since commit d1178cbcdcf91900ccf10a177350d7945703c151:

  IB/ipoib: Suppress warning for send only join failures (2015-09-03 17:11:05 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

for you to fetch changes up to 447e9a4d27484175a84daaa8e03d35c650f443b7:

  IB/ehca: Deprecate driver, move to staging, schedule deletion (2015-09-11 18:13:35 -0400)

----------------------------------------------------------------
Changes for 4.3-rc1

- Move ehca driver to staging/rdma and schedule for deletion

----------------------------------------------------------------
Doug Ledford (1):
      IB/ehca: Deprecate driver, move to staging, schedule deletion

 drivers/infiniband/Kconfig                                          | 1 -
 drivers/infiniband/hw/Makefile                                      | 1 -
 drivers/staging/rdma/Kconfig                                        | 2 ++
 drivers/staging/rdma/Makefile                                       | 1 +
 drivers/{infiniband/hw => staging/rdma}/ehca/Kconfig                | 3 ++-
 drivers/{infiniband/hw => staging/rdma}/ehca/Makefile               | 0
 drivers/staging/rdma/ehca/TODO                                      | 4 ++++
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_av.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_classes.h         | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_classes_pSeries.h | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_cq.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_eq.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_hca.c             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_irq.c             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_irq.h             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_iverbs.h          | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_main.c            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mcast.c           | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mrmw.c            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mrmw.h            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_pd.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_qes.h             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_qp.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_reqs.c            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_sqp.c             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_tools.h           | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_uverbs.c          | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hcp_if.c               | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hcp_if.h               | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hcp_phyp.c             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hcp_phyp.h             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hipz_fns.h             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hipz_fns_core.h        | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hipz_hw.h              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ipz_pt_fn.c            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ipz_pt_fn.h            | 0
 36 files changed, 9 insertions(+), 3 deletions(-)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/Kconfig (69%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/Makefile (100%)
 create mode 100644 drivers/staging/rdma/ehca/TODO
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_av.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_classes.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_classes_pSeries.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_cq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_eq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_hca.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_irq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_irq.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_iverbs.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_main.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mcast.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mrmw.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mrmw.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_pd.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_qes.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_qp.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_reqs.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_sqp.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_tools.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_uverbs.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hcp_if.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hcp_if.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hcp_phyp.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hcp_phyp.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hipz_fns.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hipz_fns_core.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hipz_hw.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ipz_pt_fn.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ipz_pt_fn.h (100%)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
