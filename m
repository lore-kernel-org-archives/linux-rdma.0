From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 11 Jan 2017 11:10:42 -0700
Message-ID: <20170111181042.GC22783@obsidianresearch.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 10, 2017 at 03:57:52PM -0800, Tadeusz Struk wrote:
> We can fix this by enforcing the correct port order at module load time.
> To reorder the ports to match the numbering labels on the back of the
> device we need to delay registering devices with the ib_core until
> we

Sorry, no way - this is horrifying.

If you need stable names for RDMA devices then you need to add proper
infrastructure to the kernel to rename RDMA devices from user space
via udev. ala netdev.

or change the ib_core to allow your driver to specify the full name
and manage things in your driver.

No way on this insane block probe approach.

Jason
