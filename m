From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/5] IB/core: Introduce Fast Indirect Memory Registration
 verbs API
Date: Wed, 1 Jul 2015 00:23:24 -0700
Message-ID: <20150701072324.GC31381@infradead.org>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <1433769339-949-2-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5C7C@ORSMSX109.amr.corp.intel.com>
 <559281B4.6010807@dev.mellanox.co.il>
 <20150630121002.GA24169@infradead.org>
 <559292CE.9010303@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <559292CE.9010303-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2015 at 03:59:58PM +0300, Sagi Grimberg wrote:
> Putting the generic API discussion aside for a moment. Indirect
> registration just a generalizes FRWR for SG-lists. The API I
> proposed is a completely symmetrical API for FRWR. So applications that
> implements FRWR can very easily use indirect registration. So I don't
> think it is "a giant nightmare".
> 
> A generic memory registration API would set as an abstraction layer
> that just make the registration operation easier for ULPs. It will be
> implemented above the core verbs layer (It wouldn't make sense to do
> this abstraction below the verbs) so it will need this API in the core
> verbs layer just as well.
> 
> Do you have another suggestion on how to expose this feature in the core
> layer?

Convert the FRWR API with one that takes SGLs, and expose a feature to tell
the client if it can take discontig SGLs.  Next trey to expand the FRWR
API to also cover other memory registration schemes.

> 
> Sagi.
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
