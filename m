From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 27/53] IB/qib: Add qib_pcie.c
Date: Thu, 19 Nov 2009 17:00:13 -0800
Message-ID: <alpine.LFD.1.10.0911191654000.21294@topaz.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com> <20091119233918.30356.5469.stgit@chromite.mv.qlogic.com> <adaaayi6onr.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaaayi6onr.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 19 Nov 2009, Roland Dreier wrote:
|  > +static void qib_msix_setup(struct qib_devdata *dd, int pos, u32 *msixcnt,
|  > +			   struct msix_entry *msix_entry)
|  > +{
|  > +	int ret;
|  > +	u32 tabsize = 0;
|  > +	u16 msix_flags;
|  > +
|  > +	pci_read_config_word(dd->pcidev, pos + PCI_MSIX_FLAGS, &msix_flags);
|  > +	tabsize = 1 + (msix_flags & PCI_MSIX_FLAGS_QSIZE);
|  > +	if (tabsize > *msixcnt)
|  > +		tabsize = *msixcnt;
|  > +	ret = pci_enable_msix(dd->pcidev, msix_entry, tabsize);
| 
| all the monkeying with config space seems dubious... fallback should
| handle the table size, and I don't think drivers should be peeking and
| poking in config space anyway.  Fix the PCI core if some generic
| function is missing...

It's needed on device resets.  The core kernel code (at least up through
2.6.27, we'll have to reverify on 2.6.32), doesn't handle that
sufficiently well, with the result that no further interrupts are
delivered.

These are driver-synchronous resets, so I guess we could add core code
to save and restore these, but I'd be surprised if very many (any?) other
drivers would ever use them.

We can also try to develop patches to the core pci code for the actual device
reset (as opposed to helper functions), but that would be potentially
risky, and I don't know that many pcie drivers could or would use that
functionality.

|  > +/**
|  > + * We save the msi lo and hi values, so we can restore them after
|  > + * chip reset (the kernel PCI infrastructure doesn't yet handle that
|  > + * correctly.
|  > + */
| 
| again... if the core doesn't do something right, fix it rather than
| hacking around it in a driver.

Same answer, I guess.

If it's seen as a big enough obstacle, we can drop this from the
upstream driver, and maintain it only in the qlogic and ofed-shipped
drivers, but I'd prefer not to do that, of course.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
