From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 00/41] Add OPA gen1 driver
Date: Wed, 8 Jul 2015 22:41:44 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2575DBA4@fmsmsx120.amr.corp.intel.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1506151439250.3542@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506151439250.3542-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Ummm.. Could we get some more descriptions as to what this code is for?
> 

The next set with contain a great deal more background info in the cover letter.

> Do we have a new OmniPath protocol here as well or is it IB? Which
> standards are followed?
> 

This will be covered in the additional information in the cover letter.

> I think the APIs that the driver uses need to be documented somewhere in
> particular if new sysfs entries etc are created.
> 

Agreed.  I will add them as well as the missing qib ones.

> Are there any user space tools to control/exercise the driver and the
> protocol stack?

There are diagnostic tools that are Intel specific that have device driver hooks.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
