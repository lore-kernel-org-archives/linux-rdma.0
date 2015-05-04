From: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 4 May 2015 20:21:57 +0000
Message-ID: <AA01A81A-B2F9-4C96-AD23-2E755E05D9F8@cisco.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <2A15610F33400040B62EDACF674509BC-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On May 4, 2015, at 1:26 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> I thought USNIC_UDP had an embedded USNIC protocol header inside the UDP
>> header.  That would make it a UDP_ENCAP protocol.
> 
> Someone from Cisco can correct me, but USNIC supports 2 protocols.  Just plain UDP, and a proprietary protocol that runs over Ethernet, but uses the same EtherType as RoCE.  I thought these could both be active on the same port at the same time.

Sean's statements above are correct.  "USNIC_UDP" in today's code really is plain-old-UDP (over IP over Ethernet).

>>>  And the core layer
>>> should not assume that a device is limited to supporting only one
>>> protocol, especially at the network and transport levels.
>> 
>> Given that this is a per port thing, there is no assumption about a
>> device only supporting a single protocol.
> 
> Device, no, but we are assuming this per port.  I don't think this is true for USNIC.  

Correct, usNIC devices and ports can speak either format concurrently, IIRC even for different QPs in the same context/PD/etc.

Incidentally, usNIC devices only ever have a single port right now, but there's no reason that has to remain true.

> For that matter, it's entirely possible for a RoCEv2 device to expose UDP directly to user space, same as USNIC.  (I'd actually be surprised if no devices have this capability, if for debugging capabilities, even if for nothing else.)  What are we going to do if there's a device that supports both iWarp and RoCEv2?  That's easily doable today through software.


+1

-Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
