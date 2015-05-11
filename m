From: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 11 May 2015 22:19:29 +0000
Message-ID: <CCC397F5-31B6-4A35-94E0-7EAAE6C4803F@cisco.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
 <1431142328.2407.488.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431142328.2407.488.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <FBF51BFA0DF5FB4C8FE4D09CFB949316-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On May 8, 2015, at 8:32 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 2015-05-05 at 20:22 +0000, Dave Goodell (dgoodell) wrote:
>> 
>> In the case that usNIC is operating in UDP mode (which is the
>> overwhelming majority of the cases), there is absolutely no additional
>> protocol that ends up on the wire or headers in the user buffers
>> besides UDP/IP/Ethernet.  They are 100% plain UDP packets, they just
>> happen to be sent via OS-bypass queues instead of traveling through the
>> kernel networking stack.  
>> 
>> [^^^^^ there continues to be confusion about this for some reason, but
>> I don't know why]
> 
> I really need to just sit down and read your driver front to back.

Feel free to ping me off-list if you want any explanation about what's going on in the usnic_verbs module.  I'm happy to help.

> The
> confusion probably comes from people (such as myself) that first think
> about this and go "Well, if you have multiple queue pairs, and UDP, then
> you need a header to tell what QP a packet goes to" (which assumes a
> RoCE like usage of UDP where all packets go to the same UDP address)
> where your actual usage is probably more iWARP like in that the IP/UDP
> SRC/DST combo maps to a specific QP, right?

I don't know much about the details of iWARP, but yes, a UDP/IP src/dst port combo maps to a specific QP when using USNIC_UDP QPs.  We do _not_ use a single well-known port.

-Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
