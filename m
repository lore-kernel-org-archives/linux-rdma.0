From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/53] IB/qib: Add Makefile
Date: Thu, 19 Nov 2009 16:05:53 -0800
Message-ID: <adaeinu6owu.fsf@roland-alpha.cisco.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	<20091119233706.30356.20051.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119233706.30356.20051.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 19 Nov 2009 15:37:06 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > +ccflags-y += -DQIB_KERN_TYPE=0 -DQIB_IDSTR='"QLogic kernel.org driver"'

Do we really need to put this in the Makefile?  Why can't this be done
in some header file?  What the heck is the KERN_TYPE anyway?

 > +ib_qib-y := \
 > +	qib_cq.o \
 > +	qib_diag.o \
 > +	qib_dma.o \
 > +	qib_driver.o \
 > +	qib_eeprom.o \
 > +	qib_file_ops.o \
 > +	qib_fs.o \
 > +	qib_init.o \
 > +	qib_intr.o \
 > +	qib_keys.o \

I think the convention is to do this with multiple files per line, ie

ib_qib-y :=	qip_cq.o qib_diag.o qib_dma.o ... \
		...

 > +ib_qib-$(CONFIG_PCI_MSI) += qib_iba6120.o

Seems you put the 6120 in the module device table even if PCI_MSI isn't
set... does the driver build without MSI enabled?

And are you dropping 6110 support (I see no HT_IRQ stuff)?  So do we
need to keep ipath around for that?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
