From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 01/50] IB: Add CNP opcode enumeration.
Date: Thu, 30 Jul 2015 20:43:09 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25777E49@fmsmsx120.amr.corp.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191732.25256.85207.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1507301530490.6551@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507301530490.6551-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> That is obvious and useless. Patches should have a meaningful description
> and justify the changes.
> 

The driver uses the CNP opcode for congestion control.

> Why do you add the CNP opcode and what in the world does it do? CNP is
> what? And why do the other enum values not work for you?

The driver supports congestion control in software vs. outboard firmware, so the opcode should be available in the appropriate kernel include file.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
