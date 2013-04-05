From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] Add IBV_*_USNIC enums for the Cisco Ethernet
 Virtual NIC.
Date: Fri, 5 Apr 2013 18:21:34 +0000
Message-ID: <9BFE3950-6954-4E9F-9300-284EC675F3F3@cisco.com>
References: <1364994415-8330-1-git-send-email-jsquyres@cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36A3A6@ORSMSX101.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FE14D8@xmb-rcd-x01.cisco.com>,<1828884A29C6694DAF28B7E6B8A823736F36B84D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F36B84D-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Per my previous email, forgive my top reply...

RDMA_NODE_VENDOR would be great, actually. Should I work up a patch for that?

Sent from my phone. No type good. 

On Apr 4, 2013, at 10:32 AM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> The reason we're asking for these IBV_*_USNIC enums now -- before we've
>> submitted the driver -- is because we're targeting getting our driver included
>> in RHEL 6.5.  There's a bit of a chicken-and-egg issue here: they'll accept our
>> patches for a new hardware driver while that driver is being worked upstream.
>> But they (rightfully) won't accept patches to IB core and libibverbs until
>> they've been vetted by the community.  Hence, even though our driver is slowly
>> working its way through QA and not available yet, we wanted to submit these new
>> enums upstream for community approval so that they can be included in RHEL 6.5.
> 
> I understand the issue.
> 
> In the end, these are kernel changes with no actual users of those changes...  But then they are also just small changes to a framework...
> 
> Just thinking aloud here, but what if we added 'RDMA_NODE_VENDOR' instead?  Then other fields, such as transport, become vendor specific.
> 
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
