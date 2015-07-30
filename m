From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 01/50] IB: Add CNP opcode enumeration.
Date: Thu, 30 Jul 2015 18:09:23 -0400
Message-ID: <20150730220922.GA22204@phlsvsds.ph.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com> <20150730191732.25256.85207.stgit@phlsvslse11.ph.intel.com> <alpine.DEB.2.11.1507301530490.6551@east.gentwo.org> <32E1700B9017364D9B60AED9960492BC25777E49@fmsmsx120.amr.corp.intel.com> <alpine.DEB.2.11.1507301554450.6808@east.gentwo.org> <32E1700B9017364D9B60AED9960492BC2577803E@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2577803E-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 09:18:17PM +0000, Marciniszyn, Mike wrote:
> > The opcode is 0x80, which appears in the protocol part of the 8 bit opcode.
> > That is what is specified in A3.10.2 of the 1.3 spec.
> > 
> 
> Correction A10.3.2.

This value also appears in Table 38 of section 9.2 where the other OpCodes
which appear in this enum are defined.

So it does appear to be the correct place to put this value.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
