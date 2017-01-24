From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] pci: drop link_reset
Date: Tue, 24 Jan 2017 17:00:34 +0200
Message-ID: <20170124165945-mutt-send-email-mst@kernel.org>
References: <1484775540-8405-1-git-send-email-mst@redhat.com>
 <1484785188.2406.73.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484785188.2406.73.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, Linas Vepstas <linasvepstas@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-pci@vger.kernel.org, linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2017 at 07:19:48PM -0500, Doug Ledford wrote:
> On Wed, 2017-01-18 at 23:39 +0200, Michael S. Tsirkin wrote:
> > No hardware seems to actually call link_reset, and
> > no driver implements it as more than a nop stub.
> > 
> > This drops the mentions of the callback from everywhere.
> > It's dropped from the documentation as well, but
> > the doc really needs to be updated to reflect
> > reality better (e.g. on pcie slot reset is the link reset).
> > 
> > This will be done in a later patch.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> This is going to conflict with the two patches I have in my for-next
> branch related to this same thing (it drops the stubs from qib and
> hfi1).  It would be easiest if I just added this to my for-next and
> fixed up the conflicts prior to submission.
> 
> > ---
> >  Documentation/PCI/pci-error-recovery.txt | 24 +++-------------------
> > --
> >  drivers/infiniband/hw/hfi1/pcie.c        | 10 ----------
> >  drivers/infiniband/hw/qib/qib_pcie.c     |  8 --------
> >  drivers/media/pci/ngene/ngene-cards.c    |  7 -------
> >  include/linux/pci.h                      |  3 ---
> >  5 files changed, 3 insertions(+), 49 deletions(-)
> > 
> > diff --git a/Documentation/PCI/pci-error-recovery.txt
> > b/Documentation/PCI/pci-error-recovery.txt
> > index ac26869..da3b217 100644
> > --- a/Documentation/PCI/pci-error-recovery.txt
> > +++ b/Documentation/PCI/pci-error-recovery.txt
> > @@ -78,7 +78,6 @@ struct pci_error_handlers
> >  {
> >  	int (*error_detected)(struct pci_dev *dev, enum
> > pci_channel_state);
> >  	int (*mmio_enabled)(struct pci_dev *dev);
> > -	int (*link_reset)(struct pci_dev *dev);
> >  	int (*slot_reset)(struct pci_dev *dev);
> >  	void (*resume)(struct pci_dev *dev);
> >  };
> > @@ -104,8 +103,7 @@ if it implements any, it must implement
> > error_detected(). If a callback
> >  is not implemented, the corresponding feature is considered
> > unsupported.
> >  For example, if mmio_enabled() and resume() aren't there, then it
> >  is assumed that the driver is not doing any direct recovery and
> > requires
> > -a slot reset. If link_reset() is not implemented, the card is
> > assumed to
> > -not care about link resets. Typically a driver will want to know
> > about
> > +a slot reset.  Typically a driver will want to know about
> >  a slot_reset().
> >  
> >  The actual steps taken by a platform to recover from a PCI error
> > @@ -232,25 +230,9 @@ proceeds to STEP 4 (Slot Reset)
> >  
> >  STEP 3: Link Reset
> >  ------------------
> > -The platform resets the link, and then calls the link_reset()
> > callback
> > -on all affected device drivers.  This is a PCI-Express specific
> > state
> > +The platform resets the link.  This is a PCI-Express specific step
> >  and is done whenever a non-fatal error has been detected that can be
> > -"solved" by resetting the link. This call informs the driver of the
> > -reset and the driver should check to see if the device appears to be
> > -in working condition.
> > -
> > -The driver is not supposed to restart normal driver I/O operations
> > -at this point.  It should limit itself to "probing" the device to
> > -check its recoverability status. If all is right, then the platform
> > -will call resume() once all drivers have ack'd link_reset().
> > -
> > -	Result codes:
> > -		(identical to STEP 3 (MMIO Enabled)
> > -
> > -The platform then proceeds to either STEP 4 (Slot Reset) or STEP 5
> > -(Resume Operations).
> > -
> > ->>> The current powerpc implementation does not implement this
> > callback.
> > +"solved" by resetting the link.
> >  
> >  STEP 4: Slot Reset
> >  ------------------
> > diff --git a/drivers/infiniband/hw/hfi1/pcie.c
> > b/drivers/infiniband/hw/hfi1/pcie.c
> > index 4ac8f33..ebd941f 100644
> > --- a/drivers/infiniband/hw/hfi1/pcie.c
> > +++ b/drivers/infiniband/hw/hfi1/pcie.c
> > @@ -598,15 +598,6 @@ pci_slot_reset(struct pci_dev *pdev)
> >  	return PCI_ERS_RESULT_CAN_RECOVER;
> >  }
> >  
> > -static pci_ers_result_t
> > -pci_link_reset(struct pci_dev *pdev)
> > -{
> > -	struct hfi1_devdata *dd = pci_get_drvdata(pdev);
> > -
> > -	dd_dev_info(dd, "HFI1 link_reset function called,
> > ignored\n");
> > -	return PCI_ERS_RESULT_CAN_RECOVER;
> > -}
> > -
> >  static void
> >  pci_resume(struct pci_dev *pdev)
> >  {
> > @@ -625,7 +616,6 @@ pci_resume(struct pci_dev *pdev)
> >  const struct pci_error_handlers hfi1_pci_err_handler = {
> >  	.error_detected = pci_error_detected,
> >  	.mmio_enabled = pci_mmio_enabled,
> > -	.link_reset = pci_link_reset,
> >  	.slot_reset = pci_slot_reset,
> >  	.resume = pci_resume,
> >  };
> > diff --git a/drivers/infiniband/hw/qib/qib_pcie.c
> > b/drivers/infiniband/hw/qib/qib_pcie.c
> > index 6abe1c6..c379b83 100644
> > --- a/drivers/infiniband/hw/qib/qib_pcie.c
> > +++ b/drivers/infiniband/hw/qib/qib_pcie.c
> > @@ -682,13 +682,6 @@ qib_pci_slot_reset(struct pci_dev *pdev)
> >  	return PCI_ERS_RESULT_CAN_RECOVER;
> >  }
> >  
> > -static pci_ers_result_t
> > -qib_pci_link_reset(struct pci_dev *pdev)
> > -{
> > -	qib_devinfo(pdev, "QIB link_reset function called,
> > ignored\n");
> > -	return PCI_ERS_RESULT_CAN_RECOVER;
> > -}
> > -
> >  static void
> >  qib_pci_resume(struct pci_dev *pdev)
> >  {
> > @@ -707,7 +700,6 @@ qib_pci_resume(struct pci_dev *pdev)
> >  const struct pci_error_handlers qib_pci_err_handler = {
> >  	.error_detected = qib_pci_error_detected,
> >  	.mmio_enabled = qib_pci_mmio_enabled,
> > -	.link_reset = qib_pci_link_reset,
> >  	.slot_reset = qib_pci_slot_reset,
> >  	.resume = qib_pci_resume,
> >  };
> > diff --git a/drivers/media/pci/ngene/ngene-cards.c
> > b/drivers/media/pci/ngene/ngene-cards.c
> > index 423e8c8..8438c1c 100644
> > --- a/drivers/media/pci/ngene/ngene-cards.c
> > +++ b/drivers/media/pci/ngene/ngene-cards.c
> > @@ -781,12 +781,6 @@ static pci_ers_result_t
> > ngene_error_detected(struct pci_dev *dev,
> >  	return PCI_ERS_RESULT_CAN_RECOVER;
> >  }
> >  
> > -static pci_ers_result_t ngene_link_reset(struct pci_dev *dev)
> > -{
> > -	printk(KERN_INFO DEVICE_NAME ": link reset\n");
> > -	return 0;
> > -}
> > -
> >  static pci_ers_result_t ngene_slot_reset(struct pci_dev *dev)
> >  {
> >  	printk(KERN_INFO DEVICE_NAME ": slot reset\n");
> > @@ -800,7 +794,6 @@ static void ngene_resume(struct pci_dev *dev)
> >  
> >  static const struct pci_error_handlers ngene_errors = {
> >  	.error_detected = ngene_error_detected,
> > -	.link_reset = ngene_link_reset,
> >  	.slot_reset = ngene_slot_reset,
> >  	.resume = ngene_resume,
> >  };
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 30d6c16..316379c 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -661,9 +661,6 @@ struct pci_error_handlers {
> >  	/* MMIO has been re-enabled, but not DMA */
> >  	pci_ers_result_t (*mmio_enabled)(struct pci_dev *dev);
> >  
> > -	/* PCI Express link has been reset */
> > -	pci_ers_result_t (*link_reset)(struct pci_dev *dev);
> > -
> >  	/* PCI slot has been reset */
> >  	pci_ers_result_t (*slot_reset)(struct pci_dev *dev);
> >  
> -- 
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>    
> Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

Linus resolves such conflicts easily, but if Bjorn acks,
that's fine with me too.

-- 
MST
