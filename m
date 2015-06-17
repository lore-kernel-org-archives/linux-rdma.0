From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 00/41] Add OPA gen1 driver
Date: Wed, 17 Jun 2015 15:57:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF6720@ORSMSX109.amr.corp.intel.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1506151439250.3542@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506151439250.3542-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Ummm.. Could we get some more descriptions as to what this code is for?
> 
> Do we have a new OmniPath protocol here as well or is it IB? Which
> standards are followed?
> 
> I think the APIs that the driver uses need to be documented somewhere in
> particular if new sysfs entries etc are created.
> 
> Are there any user space tools to control/exercise the driver and the
> protocol stack?

Christoph's questions are fair.  There should at least be a short write-up that describes how this driver fits into the RDMA stack.  (Maybe there are links with additional details that could be provided?)  For example, we know from Ira's patches and comments that OPA uses IB like management and supports the same verbs as the qib driver.  It's hard to piece this together from separate email threads or by looking at 56,000 lines of code.  I'm less concerned about the PSM support myself, as that's self-contained to this driver and doesn't impact the rest of the stack.  But at least clarify how it relates to other kernel modules (ib_cm, rdma_cm, ipoib, etc.), if at all.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
