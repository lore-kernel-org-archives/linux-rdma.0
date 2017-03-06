From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Mon, 6 Mar 2017 12:40:52 -0700
Message-ID: <20170306194052.GB31672@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-7-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170301172920.GA11340@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301175521.GB14791@obsidianresearch.com>
 <20170301221420.GA18548@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301230506.GB2820@obsidianresearch.com>
 <20170303214514.GA12996@ssaleem-MOBL4.amr.corp.intel.com>
 <20170303222244.GA678@obsidianresearch.com>
 <20170306191631.GB34252@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170306191631.GB34252-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 06, 2017 at 01:16:31PM -0600, Shiraz Saleem wrote:
> On Fri, Mar 03, 2017 at 03:22:44PM -0700, Jason Gunthorpe wrote:
> > On Fri, Mar 03, 2017 at 03:45:14PM -0600, Shiraz Saleem wrote:
> > 
> > > This is not quite how our DB logic works. There are additional HW
> > > steps and nuances in the flow. Unfortunately, to explain this, we
> > > need to provide details of our internal HW flow for the DB logic. We
> > > are unable to do so at this time.
> > 
> > Well, it is very problematic to help you define what a cross-arch
> > barrier should do if you can't explain what you need to have happen
> > relative to PCI-E.
> 
> Unfortunately, we can help with this only at the point when this information 
> is made public. If you must have an explanation for all barriers defined in 
> utils, an option here is to leave this barrier in i40iw and migrate it to 
> utils when documentation is available. 

Well, it is impossible to document what other arches are expected to
do if you can't define what you need.

Talking about the CPU alone does not define the interaction required
with PCI.

The reason we have these special barriers and do not just use C11's
atomic_thread_fence is specifically because some arches make a small
distinction on ordering relative to PCI and ordering relative to other
CPUs.

> > > Mfence guarantees that load won't be reordered before the store, and
> > > thus we are using it.
> > 
> > If that is all then the driver can use LFENCE and the
> > udma_from_device_barrier() .. Is that OK?
> 
> The write valid WQE needs to be globally visible before read tail. LFENCE does not 
> guarantee this. MFENCE does.

I was thinking

SFENCE
LFENCE

So, okay, here are two more choices.

1) Use a C11 barrier:

 atomic_thread_fence(memory_order_seq_cst);

This produces what you want on x86-64:

0000000000000590 <i40iw_qp_post_wr>:
     590:       0f ae f0                mfence 
     593:       48 8b 47 28             mov    0x28(%rdi),%rax
     597:       8b 57 40                mov    0x40(%rdi),%edx

x86-32 does:

00000600 <i40iw_qp_post_wr>:
     600:       53                      push   %ebx
     601:       8b 44 24 08             mov    0x8(%esp),%eax
     605:       f0 83 0c 24 00          lock orl $0x0,(%esp)

Which is basically the same as the "lock; addl $0,0(%%esp)" the old
macros used.

Take your chances on other arches.

2) Explicitly optimize x86 and have other arches skip the
   shadow optimization

Here is a patch that does #2, I'm guessing about the implementation..

What do you think?

diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index b20748e9f09199..e61bb049686cc5 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -33,6 +33,7 @@
 *******************************************************************************/
 
 #include <stdint.h>
+#include <stdatomic.h>
 
 #include "i40iw_osdep.h"
 #include "i40iw_status.h"
@@ -85,13 +86,21 @@ static enum i40iw_status_code i40iw_nop_1(struct i40iw_qp_uk *qp)
  * i40iw_qp_post_wr - post wr to hrdware
  * @qp: hw qp ptr
  */
+#if defined(__x86_64__) || defined(__i386__)
 void i40iw_qp_post_wr(struct i40iw_qp_uk *qp)
 {
 	u64 temp;
 	u32 hw_sq_tail;
 	u32 sw_sq_head;
 
-	udma_to_device_barrier(); /* valid bit is written and loads completed before reading shadow */
+	/* valid bit is written and loads completed before reading shadow
+	 *
+	 * Whatever is happening here does not match our common macros for
+	 * producer/consumer DMA and may not be portable, however on x86-64
+	 * the required barrier is MFENCE, get a 'portable' version via C11
+	 * atomic.
+	 */
+	atomic_thread_fence(memory_order_seq_cst);
 
 	/* read the doorbell shadow area */
 	get_64bit_val(qp->shadow_area, I40IW_BYTE_0, &temp);
@@ -114,6 +123,15 @@ void i40iw_qp_post_wr(struct i40iw_qp_uk *qp)
 
 	qp->initial_ring.head = qp->sq_ring.head;
 }
+#else
+void i40iw_qp_post_wr(struct i40iw_qp_uk *qp)
+{
+	/* We do not know how to do the shadow area optimization on this arch,
+	 * disable it. */
+	db_wr32(qp->qp_id, qp->wqe_alloc_reg);
+	qp->initial_ring.head = qp->sq_ring.head;
+}
+#endif
 
 /**
  * i40iw_qp_ring_push_db -  ring qp doorbell
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
