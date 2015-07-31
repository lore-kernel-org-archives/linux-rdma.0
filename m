From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 40/50] IB/hfi1: add sysfs routines and documentation
Date: Fri, 31 Jul 2015 10:53:59 -0600
Message-ID: <20150731165359.GB6027@obsidianresearch.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730192109.25256.56498.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1507301541170.6551@east.gentwo.org>
 <32E1700B9017364D9B60AED9960492BC25778486@fmsmsx120.amr.corp.intel.com>
 <alpine.DEB.2.11.1507310957320.12455@east.gentwo.org>
 <32E1700B9017364D9B60AED9960492BC257784F5@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC257784F5-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Debbage, Mark" <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 31, 2015 at 03:32:07PM +0000, Marciniszyn, Mike wrote:
> > > > > > +HFI1
> > > > > > +
> > > > > > +  The hfi1 driver also creates these additional files:
> > > > > > +
> > > > > > +   hw_rev - hardware revision
> > > >=20
> > > > I'm checking on this to see if it is indeed a duplicate.
> > > >=20
> > >
> > > Our hardware architect has indicated there is not PCIe equivalent for
> > > this = case.
> > 
> > Please get someone knowledgeable at Intel to look at this. There is a (rev 04)
> > when using lspci on my nic here. This seems to be the hardware revision.
> 
> I'm not sure what else to say other that the source for the sysfs
> file display is not from the PCI_REVISION_ID.

I think the lesson here is if you follow the PCI standards, and put
this kind of information in the config block (VPD, rev header, etc),
where it belongs, then you don't need to create questionable sysfs
files in your driver to get at the 2nd source..

If that wasn't done, the HW can't be changed, we are stuck with
wonky sysfs files.. Try and get it right next time <shrug>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
