From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 40/50] IB/hfi1: add sysfs routines and documentation
Date: Thu, 30 Jul 2015 22:47:00 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2577810F@fmsmsx120.amr.corp.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730192109.25256.56498.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1507301541170.6551@east.gentwo.org>
 <32E1700B9017364D9B60AED9960492BC257780D1@fmsmsx120.amr.corp.intel.com>
 <20150730223516.GA4946@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730223516.GA4946-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > There is no PCIe equivalent.
> >
> > > > +   serial - board serial number
> >
> > No PCIe equivalent.
> >
> > > > +   boardversion - board version
> 
> These all have PCI-E versions. Most should live in the config space VPD.
> 

I'm not seeing VPD in our current cards.

I'm checking to make sure.

Was this an lspci -vvv output for the example you showed?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
