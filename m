From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/qib: detour pcie_caps for certain chip sets
Date: Thu, 12 Jan 2012 13:27:50 -0700
Message-ID: <20120112202750.GG31021@obsidianresearch.com>
References: <20120112030049.31831.62692.stgit@kop-dev-sles11-04.qlogic.org>
 <20120112054830.GB32082@obsidianresearch.com>
 <35AAF1E4A771E142979F27B51793A4888885A5E388@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <35AAF1E4A771E142979F27B51793A4888885A5E388-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2012 at 08:02:52AM -0800, Mike Marciniszyn wrote:
> > Should whatever this issue is be a general PCI fixup? Like broken MSI,
> > etc.
> >
> Can you point me to some details on this?

I can explain the broken MSI stuff, as an example. As I noted I'm not
sure what you are working around here, but if there are limits imposed
on otherwise correct values in the PCI capabilities block then I think
it is broadly applicable to handle this in core code...

There are flags in pci.h like:

        PCI_BUS_FLAGS_NO_MSI   = (__force pci_bus_flags_t) 1,

Which are quirk things.. Look in drivers/pci/quirks.c to see how it is
set.

So broadly you'd make a new appropriate bus flag to control
whatever you are working around and then test and set it in quirks,
and provide core code to traverse the bus path from a device to ensure
nothing in the path sets that quirk.

Really depends what the problem actually is.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
