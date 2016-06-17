From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: hfi1 use of PCI internals
Date: Fri, 17 Jun 2016 09:58:29 -0400
Message-ID: <20160617135828.GA26133@phlsvsds.ph.intel.com>
References: <20160616162052.GA2144@localhost> <tnm1toa71hsw1.fsf@phwtpriv05.ph.intel.com> <20160616200817.GA17778@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160616200817.GA17778@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 16, 2016 at 03:08:17PM -0500, Bjorn Helgaas wrote:
>As far as I can tell, none of these PCI questions were raised on
>linux-pci, so we never even had a chance to have a conversation about
>them.

I'll let Ashutosh handle the technical details here since he is most 
familiar with the code in question. I just want to mention that the move out 
of staging doesn't imply the driver is done being developed. We are very 
much open to discussing whatever the PCI folks see as needing to be 
addressed.

-Denny
