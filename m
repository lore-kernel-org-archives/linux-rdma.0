From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/53] IB/qib: Add Kconfig
Date: Thu, 19 Nov 2009 16:02:34 -0800
Message-ID: <adaiqd66p2d.fsf@roland-alpha.cisco.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	<20091119233701.30356.78628.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119233701.30356.78628.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 19 Nov 2009 15:37:01 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A couple of random things, based on reading for a few minutes... will
try to get more in depth later...

 > +++ b/drivers/infiniband/hw/qib/Kconfig
 > @@ -0,0 +1,9 @@
 > +config INFINIBAND_QIB
 > +	tristate "QLogic IB Driver"
 > +	depends on 64BIT && INFINIBAND
 > +	---help---
 > +	This is a driver for QLogic PCIe QLE IB host channel adapters,
 > +	including InfiniBand verbs support.  This driver allows these
 > +	devices to be used with both kernel upper level protocols such
 > +	as IP-over-InfiniBand as well as with userspace applications
 > +	(in conjunction with InfiniBand userspace access).

I think you need to say something about the relationship between ib_qib
and ib_ipath ... in fact the migration plan needs to be thought through
more overall I think.  My suggestion would be to keep ib_ipath available
for ~one year, so plan on removing ib_ipath from the kernel around the
beginning of 2011... and in the meantime, the ib_qib merge should do the
following:

 - in ib_qip Kconfig and also in updated ib_ipath Kconfig, mention that
   there are two alternative drivers for older Qlogic HCAs.
 - if both drivers are enabled, have ib_ipath take older HCAs; only put
   new HCA support in ib_qib in that case.  And print a warning that
   ib_ipath is going away when it binds to an HCA.
 - add something to Documentation/feature-removal about transition plan.

(The way the e1000 / e1000e driver split was handled might be
instructive to look at too)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
