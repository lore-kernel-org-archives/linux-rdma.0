From: Stephen Bates <Stephen.Bates-PwyqCcigF0Q@public.gmane.org>
Subject: RE: [PATCH RFC 1/1] Add support for ZONE_DEVICE IO memory with
 struct pages.
Date: Tue, 15 Mar 2016 17:00:34 +0000
Message-ID: <36F6EBABA23FEF4391AF72944D228901EB7280F2@BBYEXM01.pmc-sierra.internal>
References: <1457979277-26791-1-git-send-email-stephen.bates@pmcs.com>
 <20160314212344.GC23727@linux.intel.com>
 <20160314215708.GA7282@obsidianresearch.com> <56E78B08.8050205@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E78B08.8050205-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "javier-rmLALz0KWFtWk0Htik3J/w@public.gmane.org" <javier-rmLALz0KWFtWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 14/03/16 03:57 PM, Jason Gunthorpe wrote:
> > Someone should probably explain in more detail what this is even good
> > for, DAX on PCI-E bar memory seems goofy in the general case. I was
> > under the impression the main use case involved the CPU never touching
> > these memories and just using them to route-through to another IO
> > device (eg network). So all these discussions about CPU coherency seem
> > a bit strange.
> 
> 
> Yes, the primary purpose is to enable P2P transactions that don't involve the
> CPU at all. To enable this, we do mmap the BAR region into user space which
> is then technically able to read/write to it using the CPU. However, you're
> right, it is silly to write to the mmap'd PCI BAR for anything but debug/testing
> purposes -- this type of access also has horrible performance. Really, the
> mmaping is just a convenient way to pass around the addresses with existing
> interfaces that expect system RAM (RDMA, O_DIRECT).
> 
> Putting DAX on the PCI-E bar is a actually more of a curiosity at the moment
> than anything. The current plan for NVMe with CMB would not involve DAX.
> CMB buffers would be allocated perhaps by mapping the nvmeX char device
> which could then be used with O_DIRECT access on a file on the NVME
> device and also be passed to RDMA devices. In this way data could flow from
> the NVMe device to an RDMA network without using system memory to
> buffer it.
> 
> Logan

The transfer of data between PCIe devices is the main use-case for this proposed patch.

Some other applications for this include direct transfer of data between PCIe SSDs (for background data movement and replication) and the movement of data between PCIe SSDs and GPGPU/FPGAs for accelerating applications that use those types of offload engines. In some of our performance tests we have seen significant reduction in residual DRAM bandwidth when all the data involved in these transfers has to pass through system memory buffers. This proposed patch avoids that problem.

Stephen
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
