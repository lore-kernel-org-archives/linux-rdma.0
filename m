From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 01/50] IB: Add CNP opcode enumeration.
Date: Thu, 30 Jul 2015 21:13:14 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25778018@fmsmsx120.amr.corp.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191732.25256.85207.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1507301530490.6551@east.gentwo.org>
 <32E1700B9017364D9B60AED9960492BC25777E49@fmsmsx120.amr.corp.intel.com>
 <alpine.DEB.2.11.1507301554450.6808@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507301554450.6808-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > That is obvious and useless. Patches should have a meaningful
> > > description and justify the changes.
> > >
> >
> > The driver uses the CNP opcode for congestion control.
> 
> And that requires a new transport protocol???
> 

The opcode is 0x80, which appears in the protocol part of the 8 bit opcode.  That is what is specified in A3.10.2 of the 1.3 spec.

That also happens to land in the upper bits of the opcode. 

Would this fit better with a  IB_OPCODE_CNP_TRANS (0x80) with a single opcode of IB_OPCODE_CNP_OP 0x00, combined with the IB_OPCODE macro to produce IB_OPCODE_CNP?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
