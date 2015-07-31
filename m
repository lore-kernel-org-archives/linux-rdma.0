From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 40/50] IB/hfi1: add sysfs routines and documentation
Date: Fri, 31 Jul 2015 11:07:08 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507311106030.13024@east.gentwo.org>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com> <20150730192109.25256.56498.stgit@phlsvslse11.ph.intel.com> <alpine.DEB.2.11.1507301541170.6551@east.gentwo.org> <32E1700B9017364D9B60AED9960492BC25778486@fmsmsx120.amr.corp.intel.com>
 <alpine.DEB.2.11.1507310957320.12455@east.gentwo.org> <32E1700B9017364D9B60AED9960492BC257784F5@fmsmsx120.amr.corp.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC257784F5-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Debbage, Mark" <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 31 Jul 2015, Marciniszyn, Mike wrote:
> > Please get someone knowledgeable at Intel to look at this. There is a (re=
> v 04)
> > when using lspci on my nic here. This seems to be the hardware revision.
> >=20
>
> I'm not sure what else to say other that the source for the sysfs file disp=
> lay is not from the PCI_REVISION_ID.

No its from the PCI config block. So its not needed in the sysfs display
since lspci can get to it that way.

> >   if (c =3D get_conf_byte(d, PCI_REVISION_ID))
> >     printf(" (rev %02x)", c);
>
> Note, that a zero value suppresses the print, which is the case right now.

Well yeah that is the initial release. You would increment it when the
next rev comes out.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
