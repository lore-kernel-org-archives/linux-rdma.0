From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 07/10] IB/qib: Replace deprecated pci functions
 with new API
Date: Tue, 27 Jun 2017 17:02:39 -0400
Message-ID: <1498597359.2527.4.camel@redhat.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
         <20170609230004.26710.93484.stgit@scvm10.sc.intel.com>
         <20170612095751.GA2396@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612095751.GA2396-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-12 at 02:57 -0700, Christoph Hellwig wrote:
> On Fri, Jun 09, 2017 at 04:00:06PM -0700, Dennis Dalessandro wrote:
> > From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > pci_enable_msix_range() and pci_disable_msix() have been
> > deprecated.
> > Updating to the new pci_alloc_irq_vectors() interface.
> 
> This should go a lot further to remove all the dealing with
> low-level pci bits and storing the absolute vector number.
> 
> Untested idea below.

Not that I disagree with cleanups, but on the basis of each patch being
a separate change unto itself, I took the PCI interrupt API cleanups
and the further cleanups you suggest should be a distinct patch anyway.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
