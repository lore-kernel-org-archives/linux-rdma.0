From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Mon, 23 Apr 2018 14:41:04 -0600
Message-ID: <20180423144104.2dad7495@w520.home>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
        <20180419202632.GE14063@ziepe.ca>
        <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
        <290e9530-dcde-9c10-7ae0-59ac4c509db4@codeaurora.org>
        <20180420140049.GP28657@bhelgaas-glaptop.roam.corp.google.com>
        <20180420090420.03fb1e6c@w520.home>
        <10d9cf68-29ed-d205-a25f-b8dade53cdd8@codeaurora.org>
        <20180423131044.53471670@w520.home>
        <20180423202311.GA164898@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180423202311.GA164898@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Deucher <alexander.deucher@amd.com>, Rajat Jain <rajatja@google.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Apr 2018 15:23:11 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> On Mon, Apr 23, 2018 at 01:10:44PM -0600, Alex Williamson wrote:
> > On Mon, 23 Apr 2018 13:28:22 -0400
> > Sinan Kaya <okaya@codeaurora.org> wrote:
> >   
> > > On 4/20/2018 11:04 AM, Alex Williamson wrote:  
> > > > Is there a concern here about whether the endpoint device driver or the
> > > > PCI core really knows better about link retraining?  This makes me
> > > > remember my unfinished (and need to revisit) Pericom quirk[1] where
> > > > errata in the PCIe switch requires that upstream and downstream links
> > > > are balanced (ie. same link rate) or else enabling ACS results in
> > > > packets not properly flowing through the switch.  If an endpoint driver
> > > > starts deciding to retrain links, overriding quirks in the PCI core,
> > > > then such topology manipulation isn't possible.  Why does the
> > > > driver .probe() function think it can retrain at a higher link rate
> > > > than PCI core?  Thanks,    
> > > 
> > > The example given is for some serdes firmware load to happen in probe and
> > > then performing a retrain to reach to a better speed.
> > > 
> > > It becomes a chicken and egg problem. 
> > > 
> > > 1. Endpoint HW trains to gen1 by default pre-boot.
> > > 2. PCI core enumerates the device.
> > > 3. Endpoint driver gets loaded
> > > 4. Driver does the firmware programming followed by a link retrain.
> > > 
> > > I think it is the responsibility of the PCI core to provide reset APIs.
> > > However, expecting endpoint drivers to be knowledgeable about hotplug is
> > > too much.
> > > 
> > > We can certainly contain AER change into pci directory by moving the slot
> > > reset function to drivers/pci.h file.
> > > 
> > > But, we need to think about what to do about VFIO and other endpoint
> > > initiated reset cases. My suggestion was to move this into a single API and
> > > remove all other APIs from include/linux/pci.h.  
> > 
> > I'm a little confused about the relation between reset and retrain.
> > AIUI we can retrain the link without any sort of endpoint reset and if
> > some sort of driver/firmware setup is required on the endpoint to
> > achieve the target link speed, then I'd think we only want to retrain.  
> 
> In hfi1, do_pcie_gen3_transition() resets the device.  I don't know if
> retraining the link would be sufficient; maybe the reset is required
> to make the device use the new firmware.  I guess we already export
> reset interfaces, so if we add a retrain interface, drivers could
> choose what they need.
> 
> > How this is going to work with vfio is an interesting question.  We're
> > only providing access to the device, not the link to the device.  
> 
> > Multifunction endpoints become a big problem if one function starts
> > requesting link retraining while another is in use elsewhere.  
> 
> Can we just make it the driver's problem by returning -EPERM if one
> function requests a retrain while another function is in use?

Yes, this is basically how we handle bus resets through vfio-pci, if
there are multiple devices affected by a bus reset, slots or functions,
the caller needs to prove ownership of all of them before we do a bus
reset.  That's great for video cards where we have the GPU and audio
functions typically assigned together anyway, but I don't know that
it's a great solution for IB where you're more likely to want to assign
separate functions to separate users and nobody can get the device to
run at full speed unless all the functions are assigned to one user.
Thanks,

Alex
