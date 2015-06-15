From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/41] Add OPA gen1 driver
Date: Mon, 15 Jun 2015 14:48:17 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506151439250.3542@east.gentwo.org>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611230710.16479.62955.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ummm.. Could we get some more descriptions as to what this code is for?

Do we have a new OmniPath protocol here as well or is it IB? Which
standards are followed?

I think the APIs that the driver uses need to be documented somewhere in
particular if new sysfs entries etc are created.

Are there any user space tools to control/exercise the driver and the
protocol stack?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
