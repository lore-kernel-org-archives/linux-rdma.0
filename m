From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] Add IBV_*_USNIC enums for the Cisco Ethernet
 Virtual NIC.
Date: Fri, 5 Apr 2013 18:19:59 +0000
Message-ID: <02A33CE5-6894-4F88-8493-2ACD9FF81B5E@cisco.com>
References: <1364994415-8330-1-git-send-email-jsquyres@cisco.com>
	<1828884A29C6694DAF28B7E6B8A823736F36A3A6@ORSMSX101.amr.corp.intel.com>
	<EF66BBEB19BADC41AC8CCF5F684F07FC43FE14D8@xmb-rcd-x01.cisco.com>,<CAJZOPZKQ_QFdTj-uYOBuBXcipxO1Drj7v4_U_euYzOe1Y6648Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKQ_QFdTj-uYOBuBXcipxO1Drj7v4_U_euYzOe1Y6648Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Forgive the top reply; I'm actually on vacation this week and currently only have email access on my phone...

I'm not sure what you're asking me to do. Are you asking us to submit our known-buggy-and-not-yet-complete driver just to get two enums approved?

Sent from my phone. No type good. 

On Apr 4, 2013, at 5:27 PM, "Or Gerlitz" <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jeff Squyres (jsquyres) <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Sure.  For a little background, the 2nd-generation Cisco VIC has been available
>> since last year (IIRC): http://www.cisco.com/en/US/products/ps10277
>> /prod_module_series_home.html.  It's a converged 10G Ethernet adapter available > in a variety of form factors (e.g., 2x10G on PCIe and Mezz).
> 
>> After some off-list discussion with Roland, we chose to create new IBV_*_USNIC
>> enums because none of the current enums were accurate for our device.  It's an
>> Ethernet NIC, but it's not an RNIC.  It's an Ethernet-based transport, but it's not
>> iWARP.
> 
>> 
>> The reason we're asking for these IBV_*_USNIC enums now -- before we've submitted the driver -- is because we're targeting getting our driver included in RHEL 6.5.  There's a bit of a chicken-and-egg issue here: they'll accept our patches for a new hardware driver while that driver is being worked upstream.  But they (rightfully) won't accept patches to IB core and libibverbs until they've been vetted by the community.  Hence, even though our driver is slowly working its way through QA and not available yet, we wanted to submit these new enums upstream for community approval so that they can be included in RHEL 6.5.
> 
>> Does that help?
> 
> yes it does, but I still think we need to see the driver code in order
> to conduct proper /better review and maybe even accept the proposed
> changes to the IB core. You can submit it as RFC which means "you can
> look on it, and give me comments, but don't pick it up yet"
> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
