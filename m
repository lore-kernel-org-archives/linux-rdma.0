From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/53] IB/qib: Add Makefile
Date: Thu, 19 Nov 2009 17:07:45 -0800
Message-ID: <alpine.LFD.1.10.0911191700500.21294@topaz.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com> <20091119233706.30356.20051.stgit@chromite.mv.qlogic.com> <adaeinu6owu.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaeinu6owu.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 19 Nov 2009, Roland Dreier wrote:

| 
|  > +ccflags-y += -DQIB_KERN_TYPE=0 -DQIB_IDSTR='"QLogic kernel.org driver"'
| 
| Do we really need to put this in the Makefile?  Why can't this be done
| in some header file?  What the heck is the KERN_TYPE anyway?

A way of distinguishing qlogic-built drivers from elsewhere.  We'll fix
this; it shouldn't be needed in the upstream driver.

| 
| I think the convention is to do this with multiple files per line, ie
| 
| ib_qib-y :=	qip_cq.o qib_diag.o qib_dma.o ... \

Last time we did that, we got asked to change it to one per line.  If
conventions have changed, no problem.

|  > +ib_qib-$(CONFIG_PCI_MSI) += qib_iba6120.o
| 
| Seems you put the 6120 in the module device table even if PCI_MSI isn't
| set... does the driver build without MSI enabled?

Yes.  It just doesn't work well.  It works well enough to tell people
what the problem is, which is what we wanted.

| And are you dropping 6110 support (I see no HT_IRQ stuff)?  So do we
| need to keep ipath around for that?

6110 is out of this driver, and people (customers) are aware that support has
been dropped.  The current (non-verbs) userland software won't work on those
boards any longer, and customers were using them primarily for non-verbs
MPI.

The ipath driver has some significant problems with verbs, and those
problems have been fixed based on the significant restructuring and
rewrites in the ib_qib driver, so it's unlikely that any customer would
want to continue to use the ib_ipath driver in any case.

It seems to me that people who want the ib_ipath driver are likely to 
use it only on older kernels where it was known to work OK, in any case.
Testing on ib_ipath (by QLogic, at least) stopped with the 2.6.24 kernel.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
