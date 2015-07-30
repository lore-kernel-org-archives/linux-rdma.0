From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 40/50] IB/hfi1: add sysfs routines and documentation
Date: Thu, 30 Jul 2015 16:35:16 -0600
Message-ID: <20150730223516.GA4946@obsidianresearch.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730192109.25256.56498.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1507301541170.6551@east.gentwo.org>
 <32E1700B9017364D9B60AED9960492BC257780D1@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC257780D1-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 10:28:42PM +0000, Marciniszyn, Mike wrote:
> > > +   board_id - manufacturing board id
> 
> There is no PCIe equivalent.
> 
> > > +   serial - board serial number
> 
> No PCIe equivalent.
> 
> > > +   boardversion - board version

These all have PCI-E versions. Most should live in the config space
VPD.

01:00.0 Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
	Capabilities: [48] Vital Product Data
		Product Name: CX354A - ConnectX-3 QSFP
		Read-only fields:
			[PN] Part number: MCX354A-QCBT         
			[EC] Engineering changes: A1
			[SN] Serial number: MT1151X00841            
			[V0] Vendor specific: PCIe Gen3 x8    
			[RV] Reserved: checksum good, 0 byte(s) reserved

There is room for various vendor-specific things in the VPD if you
need.

I'm not sure, but I kinda remember there is even a PCI-E standard for
the temp sensor these days..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
