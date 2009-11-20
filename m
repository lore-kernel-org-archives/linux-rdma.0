From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 27/53] IB/qib: Add qib_pcie.c
Date: Thu, 19 Nov 2009 16:11:20 -0800
Message-ID: <adaaayi6onr.fsf@roland-alpha.cisco.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	<20091119233918.30356.5469.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119233918.30356.5469.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 19 Nov 2009 15:39:18 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > +#ifdef CONFIG_PCIEAER
 > +#include <linux/aer.h>
 > +#endif

I don't think this ifdef is needed... <linux/aer.h> looks fine to
include even if PCIEAER isn't set.

 > +#ifndef PCI_MSIX_FLAGS
 > +#define PCI_MSIX_FLAGS 2
 > +#endif
 > +#ifndef PCI_MSIX_FLAGS_ENABLE
 > +#define  PCI_MSIX_FLAGS_ENABLE  (1 << 15)
 > +#endif
 > +#ifndef PCI_MSIX_FLAGS_QSIZE
 > +#define PCI_MSIX_FLAGS_QSIZE 0x7FF
 > +#endif

None of this is needed ... all these constants are defined, right?

 > +#ifdef CONFIG_PCIEAER
 > +	/* enable basic AER reporting.  Perhaps more later */
 > +	if (pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR)) {
 > +		ret = pci_enable_pcie_error_reporting(pdev);
 > +		if (ret)
 > +			qib_early_err(&pdev->dev,
 > +				      "Unable to enable pcie error reporting"
 > +				      ": %d\n", ret);
 > +	} else
 > +		qib_dbg("AER capability not found! AER reports not enabled\n");
 > +#endif

ifdef here isn't needed either, I don't think.  And neither is the test
for the capability... just call pci_enable_pcie_error_reporting always
and it will return an error if the config option isn't set or the cap
isn't found.

 > +#ifdef CONFIG_PCI_MSI

again, ifdef not needed, right?

 > +static void qib_msix_setup(struct qib_devdata *dd, int pos, u32 *msixcnt,
 > +			   struct msix_entry *msix_entry)
 > +{
 > +	int ret;
 > +	u32 tabsize = 0;
 > +	u16 msix_flags;
 > +
 > +	pci_read_config_word(dd->pcidev, pos + PCI_MSIX_FLAGS, &msix_flags);
 > +	tabsize = 1 + (msix_flags & PCI_MSIX_FLAGS_QSIZE);
 > +	if (tabsize > *msixcnt)
 > +		tabsize = *msixcnt;
 > +	ret = pci_enable_msix(dd->pcidev, msix_entry, tabsize);

all the monkeying with config space seems dubious... fallback should
handle the table size, and I don't think drivers should be peeking and
poking in config space anyway.  Fix the PCI core if some generic
function is missing...

 > +/**
 > + * We save the msi lo and hi values, so we can restore them after
 > + * chip reset (the kernel PCI infrastructure doesn't yet handle that
 > + * correctly.
 > + */

again... if the core doesn't do something right, fix it rather than
hacking around it in a driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
