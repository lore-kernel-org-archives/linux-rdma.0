From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v3 0/2] IB/hfi1: Cleanup PCIe link configuration
Date: Tue, 17 Apr 2018 09:32:32 -0500
Message-ID: <20180417143232.GH28657@bhelgaas-glaptop.roam.corp.google.com>
References: <20180417002825.2737-1-fred@fredlawl.com>
 <20180417065343.GA29193@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180417065343.GA29193@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Frederick Lawler <fred@fredlawl.com>, bhelgaas@google.com, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, dledford@redhat.com, jgg@mellanox.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Bartlomiej Dudek <bartlomiej.dudek@intel.com>
List-Id: linux-rdma@vger.kernel.org

[+cc Bartlomiej, who recently changed do_pcie_gen3_transition(), LKML]

On Mon, Apr 16, 2018 at 11:53:43PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 16, 2018 at 07:28:23PM -0500, Frederick Lawler wrote:
> > The IB/hfi1 driver uses custom macros to configure the target link speed. Some 
> > macros were previously replaced, but not fully. This patch series addresses the
> > configuration inconsistencies by adding PCI_EXP_LNKCTL2_TLS* macros to PCI,
> > and then use them in the following IB/hfi1 patch.
> 
> Btw, why is the driver configuring the PCIe link speed?  Isn't this
> something we should be handling in the PCI core?

Good question.  I think this sort of code definitely should not be in
drivers unless it's to work around some kind of defect in the device.

I think the intent of the spec is that neither the OS nor the driver
has to deal with link training and the link should train to the
highest speed supported by both ends.  For example, PCIe r4.0, sec 1.2
says

  Initialization – During hardware initialization, each PCI Express
  Link is set up following a negotiation of Lane widths and frequency
  of operation by the two agents at each end of the Link. No firmware
  or operating system software is involved.

Maybe the Intel guys can comment on why HFI needs this code.
Presumably they didn't write it just for fun, so I assume there's
some reason.

Bjorn
