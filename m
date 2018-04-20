From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Fri, 20 Apr 2018 08:54:00 -0600
Message-ID: <20180420145400.GA30433@ziepe.ca>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
 <20180419202632.GE14063@ziepe.ca>
 <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419214722.GO28657@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Sinan Kaya <okaya@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Deucher <alexander.deucher@amd.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 19, 2018 at 04:47:23PM -0500, Bjorn Helgaas wrote:
 
> I *thought* the hardware was supposed to automatically negotiate to
> the highest rate supported by both sides without any help at all from
> software.  But since several drivers have code to do it themselves, I
> wonder if I'm missing something, or maybe there's something the PCI
> core should be doing that it isn't, and the driver code is basically
> working around that PCI core deficiency.

The HW is supposed to do that, but Gen3 is electrically *hard*.

I'm not surprised that some HW has run into trouble where the driver
might have to be involved to tweak the SERDES.. eg there is now often
on-device software involved here and updating the SERDES 'firmware'
may be needed.

Jason
