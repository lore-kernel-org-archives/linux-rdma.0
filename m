From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: An IB SRP target
Date: Mon, 14 Feb 2011 16:18:57 -0800
Message-ID: <1297729137.29207.69.camel@haakon2.linux-iscsi.org>
References: <201102142109.19150.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102142109.19150.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-02-14 at 21:09 +0100, Bart Van Assche wrote:
> This patch adds the kernel module ib_srpt, which is a SCSI RDMA Protocol
> (SRP) target implementation conforming to the SRP r16a specification.
> 
> This driver was originally developed by Vu Pham and has been optimized by
> Bart Van Assche.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Nicholas A. Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> ---
>  drivers/infiniband/Kconfig              |    2 +
>  drivers/infiniband/Makefile             |    1 +
>  drivers/infiniband/ulp/srpt/Kconfig     |   12 +
>  drivers/infiniband/ulp/srpt/Makefile    |    2 +
>  drivers/infiniband/ulp/srpt/ib_dm_mad.h |  139 ++
>  drivers/infiniband/ulp/srpt/ib_srpt.c   | 4012 +++++++++++++++++++++++++++++++
>  drivers/infiniband/ulp/srpt/ib_srpt.h   |  406 ++++
>  7 files changed, 4574 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/infiniband/ulp/srpt/Kconfig
>  create mode 100644 drivers/infiniband/ulp/srpt/Makefile
>  create mode 100644 drivers/infiniband/ulp/srpt/ib_dm_mad.h
>  create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.c
>  create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.h
> 

Hi Bart,

Thank you for your contibution.  I will plan to spend time in the next
days reviewing the TCM interaction pieces, but have gone ahead and
pushed as-is into a working branch @ lio-core-2.6.git/tcm_ib_srpt
(.38-rc4).  Please send along any further code updates, and I will make
sure they hit this branch.

Also just a FYI, in order to compile ib_srpt against the latest LIO
upstream tree, the original srp_tmr_to_tcm() code was modified with the
following patch to use the new TMR_* prefixed definitions from
include/target/target_core_tmr.h.

Thanks!

--nab

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e63775b..cfcb1bc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1860,15 +1860,15 @@ static int srp_tmr_to_tcm(int fn)
 {
        switch (fn) {
        case SRP_TSK_ABORT_TASK:
-               return ABORT_TASK;
+               return TMR_ABORT_TASK;
        case SRP_TSK_ABORT_TASK_SET:
-               return ABORT_TASK_SET;
+               return TMR_ABORT_TASK_SET;
        case SRP_TSK_CLEAR_TASK_SET:
-               return CLEAR_TASK_SET;
+               return TMR_CLEAR_TASK_SET;
        case SRP_TSK_LUN_RESET:
-               return LUN_RESET;
+               return TMR_LUN_RESET;
        case SRP_TSK_CLEAR_ACA:
-               return CLEAR_ACA;
+               return TMR_CLEAR_ACA;
        default:
                return -1;
        }



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
