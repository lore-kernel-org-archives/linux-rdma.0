From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 40/50] IB/hfi1: add sysfs routines and documentation
Date: Thu, 30 Jul 2015 22:28:42 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC257780D1@fmsmsx120.amr.corp.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730192109.25256.56498.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1507301541170.6551@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507301541170.6551-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +HFI1
> > +
> > +  The hfi1 driver also creates these additional files:
> > +
> > +   hw_rev - hardware revision

I'm checking on this to see if it is indeed a duplicate.

> > +   board_id - manufacturing board id

There is no PCIe equivalent.

> > +   version - driver version

This IS a duplicate of in /sys/module/hfi1/version.

Will remove.

> > +   tempsense - thermal sense information

No PCIe equivalent.

> > +   serial - board serial number

No PCIe equivalent.

> > +   localbus_info - PCIe info

Already present in PCIe.    Will remove.

> > +   chip_reset - diagnostic (root only)

Used by our manufacturing process.

> > +   boardversion - board version
> 

These are sourced from chip registers.  There is no PCIe equivalent.

> Arent these already provide by the pci-e driver framework? Tools will not
> work if you do not put the information out there in a way that they can be
> scanned.
> 

Doug,  do you want a revision with the ones I know can be removed or is a follow-up ok.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
