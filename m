From: Doug Ledford <dledford@redhat.com>
Subject: Re: PCI/IB: add support for pci driver attribute groups
Date: Fri, 18 Aug 2017 11:44:26 -0400
Message-ID: <1503071066.2598.15.camel@redhat.com>
References: <20170719130106.GE17776@kroah.com>
         <20170801214046.GB26498@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170801214046.GB26498@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Faisal Latif <faisal.latif@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-01 at 16:40 -0500, Bjorn Helgaas wrote:
> On Wed, Jul 19, 2017 at 03:01:06PM +0200, Greg KH wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Some drivers (specifically the nes IB driver), want to create a lot
> > of
> > sysfs driver attributes.  Instead of open-coding the creation and
> > removal of these files (and getting it wrong btw), it's a better
> > idea to
> > let the driver core handle all of this logic for us.
> > 
> > So add a new field to the pci driver structure, **groups, that
> > allows
> > pci drivers to specify an attribute group list it wishes to have
> > created
> > when it is registered with the driver core.
> > 
> > Big bonus is now the driver doesn't race with userspace when the
> > sysfs
> > files are created vs. when the kobject is announced, so any
> > script/tool
> > that actually wanted to use these files will not have to poll
> > waiting
> > for them to show up.
> > 
> > Cc: Faisal Latif <faisal.latif@intel.com>
> > Cc: Doug Ledford <dledford@redhat.com>
> > Cc: Sean Hefty <sean.hefty@intel.com>
> > Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> If you want me to take this let me know; otherwise I'll assume Doug
> will
> merge it.

I've picked it up for for-next.  Thanks.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
