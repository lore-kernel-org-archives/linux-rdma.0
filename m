From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH for v3.14 0/5] Coccicheck / coccinelle catched errors on ib/hw
Date: Mon, 10 Mar 2014 23:06:24 +0100
Message-ID: <cover.1394485254.git.ydroneaud@opteya.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>, Roland Dreier <roland@kernel.org>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Faisal Latif <faisal.latif@intel.com>, "Tatyana E. Nikolova" <tatyana.e.nikolova@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: linux-rdma@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>, stable@vger.kernel.org, infinipath@intel.com, Julia Lawall <julia.lawall@lip6.fr>, cocci@systeme.lip6.fr
List-Id: linux-rdma@vger.kernel.org

Hi all,

Please find small but important fixes on InfiniBand/iWARP RDMA drivers for
problems found while using coccinelle (spatch) or coccicheck.

I'm trying to patch callers of ib_copy_{from,to}_udata() to use the error
code returned by functions using a semantic patch to be applied with
coccinelle. The current semantic patch could be found in a git repository
hosted on gitorious.org [1].

But while I'm not yet ready to submit the resulting patches to rewrite calls
to ib_copy_{from,to}_udata(), I'm submitting today important fixes for errors
encountered during the conversion: I've found that three callers were not
setting proper error code when failing.

The third one is especially nasty as it would make (specific) application
crashes on most configuration, or, if the kernel wasn't protecting itself
from NULL pointer dereferences, it could allow some exploits to be successfully
executed. Hopefully, /proc/sys/vm/mmap_min_addr is here to protect us.
But more, it's only applicable to NetEffect iWARP driver, so I believe the
vulnerability is so impracticable that it's not even worth mentioning it.
People interested could find some details in the README file from a dedicated
git repository along a test program used to try to trigger the NULL pointer
dereference, again hosted on gitorious.og [2]. It's mostly theoretical as
I haven't access to a NetEffect iWARP HCA to really exercise the test program
against the iw_nes driver.

I've done a limited manual review of other infiniband/hw/ drivers with the help
of another semantic patch from mine [3] (I'm a bit ashamed of it, as it's very
crude and don't use all of the feature offered by coccinelle) and found no
other potential kernel NULL dereference that could be triggered from uverbs
layer. But you, driver maintainers, should not trust me and do your own review.

The last patches are fixes for warnings reported by coccicheck.
For those who don't use it so much, coccicheck can be executed
just like sparse or smatch when building the kernel using:

    make C=2 CHECK=scripts/coccicheck <targets>

You will see that it's able to catch errors that the two others
static analyzers are not reporting. I'm proposing fixes for the most noticeable
ones.

Thanks for reviewing, testing and applying for v3.14 and stable.

Regards.

Links:

[1] https://www.gitorious.org/opteya/coccib/source/75ebf2c1033c64c1d81df13e4ae44ee99c989eba:ib_copy_udata.cocci
[2] https://www.gitorious.org/opteya/ib-hw-nes-create-qp-null
[3] https://www.gitorious.org/opteya/coccib/source/75ebf2c1033c64c1d81df13e4ae44ee99c989eba:NULL.cocci

Yann Droneaud (5):
  IB/ehca: returns an error on ib_copy_to_udata() failure
  IB/mthca: returns an error on ib_copy_to_udata() failure
  IB/nes: returns an error on ib_copy_from_udata() failure instead of
    NULL
  IB/qib: add missing braces in do_qib_user_sdma_queue_create()
  IB/qib: fixup indentation in qib_ib_rcv()

 drivers/infiniband/hw/ehca/ehca_cq.c         | 1 +
 drivers/infiniband/hw/mthca/mthca_provider.c | 1 +
 drivers/infiniband/hw/nes/nes_verbs.c        | 2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c     | 3 ++-
 drivers/infiniband/hw/qib/qib_verbs.c        | 4 ++--
 5 files changed, 7 insertions(+), 4 deletions(-)

-- 
1.8.5.3
