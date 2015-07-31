From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 40/50] IB/hfi1: add sysfs routines and documentation
Date: Fri, 31 Jul 2015 17:27:48 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2577861E@fmsmsx120.amr.corp.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730192109.25256.56498.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1507301541170.6551@east.gentwo.org>
 <32E1700B9017364D9B60AED9960492BC25778486@fmsmsx120.amr.corp.intel.com>
 <alpine.DEB.2.11.1507310957320.12455@east.gentwo.org>
 <32E1700B9017364D9B60AED9960492BC257784F5@fmsmsx120.amr.corp.intel.com>
 <20150731165359.GB6027@obsidianresearch.com>
 <alpine.DEB.2.11.1507311205220.13612@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507311205220.13612-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Debbage, Mark" <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > If that wasn't done, the HW can't be changed, we are stuck with wonky
> > sysfs files.. Try and get it right next time <shrug>
> 
> And lspci as well as other tools will not be able to distinguish between
> different versions of the hardware.

Sorry if I misled.

We do fully support the PCI revision number, and that will be set that differently for different hardware versions.

We have additional versioning information that we convey using chip registers (not PCI config registers), and the driver brings these values out for interpretation by our own tools. The hardware design does not support VPD.

Mike


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
