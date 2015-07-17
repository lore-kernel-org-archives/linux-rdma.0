From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RESEND PATCH v2 0/2] x86/mm/pat: modify nopat requirement warning
Date: Fri, 17 Jul 2015 14:07:23 -0700
Message-ID: <1437167245-28273-1-git-send-email-mcgrof@do-not-panic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@elte.hu
Cc: bp@suse.de, andy@silverblocksystems.net, mchehab@osg.samsung.com, dledford@redhat.com, dan.j.williams@intel.com, benh@kernel.crashing.org, luto@amacapital.net, julia.lawall@lip6.fr, jkosina@suse.cz, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Ingo,

Boris is on vacation so sending this through you. This is just a resend of
the v2 series. The issue here was the WARN() splat on built-in kernels due
to ivtv's funky probe which will trigger even if you don't have any ivtv
hardware. I've moved this to only trigger upon a device detection.

We also spoke about not doing any of this and and letting it silently fail
for these drivers but since this is only for two drivers and the ipath diver
will be removed only the ivtv driver would be left with this work around. I'd
like to enforce the semantics for usage of arch_phys_wc_add() with ioremap_wc()
and making an exception just for ivtv does not seem worth the gains of having
strong semantics. After all the ioremap_wc() + arch_phys_wc_add() are in I'll
then try to add an SmPL rule check to enforce semantics on the ioremap_wc() +
arch_phys_wc_add() API. Hope is that maintainers can vet new code for its
correct usage in the future with 'make coccicheck M=path' on their subsystems.

For your reference we discussed this and I mentioned my semantics preference
and you were OK with this [0] so just resending this series as it fell through
the cracks as Boris is on vacation now.

Although the WARN() --> pr_warn() change is not techically needed for ipath,
we make both checks consistent and less chatty. Since the ivtv change is
splattering all v4.2 kernels that patch may be worthy for v4.2 inclusion. I
did not peg the Cc: stable tag so leave this up to you to decide.

Please let me know if this is OK or if there are any other oustandind issues.

[0] http://lkml.kernel.org/r/20150707070306.GB9784@gmail.com

Luis R. Rodriguez (2):
  x86/mm/pat, drivers/infiniband/ipath: replace WARN() with pr_warn()
  x86/mm/pat, drivers/media/ivtv: move pat warn and replace WARN() with
    pr_warn()

 drivers/infiniband/hw/ipath/ipath_driver.c |  6 ++++--
 drivers/media/pci/ivtv/ivtvfb.c            | 15 +++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty
