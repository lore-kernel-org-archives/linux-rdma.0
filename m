From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] Add IBV_*_USNIC enums for the Cisco Ethernet
 Virtual NIC.
Date: Thu, 4 Apr 2013 12:09:10 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC43FE14D8@xmb-rcd-x01.cisco.com>
References: <1364994415-8330-1-git-send-email-jsquyres@cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36A3A6@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F36A3A6-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <147DC15B31EE9343849332206458AEF8-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 3, 2013, at 10:49 AM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Can we get a better patch description?
> 
> Maybe mention something about the NIC?  Does it support all verbs?  Is it for kernel users or just user space?  Does this simply export a raw ethernet interface?

Sure.  For a little background, the 2nd-generation Cisco VIC has been available since last year (IIRC): http://www.cisco.com/en/US/products/ps10277/prod_module_series_home.html.  It's a converged 10G Ethernet adapter available in a variety of form factors (e.g., 2x10G on PCIe and Mezz).

We'll be providing a UD verbs kernel driver and libibverbs plugin for OS bypass.  It is currently going through QA and debugging; it'll probably take a bit more time before we can submit good patches.  The main intended use for this driver is userspace/libibverbs applications, but I suppose it could be used by kernel applications, too.  The wire protocol transport that is uses underneath will initially be a very simple L2-Ethernet based frame (DMAC, SMAC, ET, QP num, etc.).  

We are not exposing a RAW interface at this time; the libibverbs plugin will provide UD QP functionality.

After some off-list discussion with Roland, we chose to create new IBV_*_USNIC enums because none of the current enums were accurate for our device.  It's an Ethernet NIC, but it's not an RNIC.  It's an Ethernet-based transport, but it's not iWARP.

The reason we're asking for these IBV_*_USNIC enums now -- before we've submitted the driver -- is because we're targeting getting our driver included in RHEL 6.5.  There's a bit of a chicken-and-egg issue here: they'll accept our patches for a new hardware driver while that driver is being worked upstream.  But they (rightfully) won't accept patches to IB core and libibverbs until they've been vetted by the community.  Hence, even though our driver is slowly working its way through QA and not available yet, we wanted to submit these new enums upstream for community approval so that they can be included in RHEL 6.5.

Does that help?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
