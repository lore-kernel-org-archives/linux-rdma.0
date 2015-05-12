From: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Tue, 12 May 2015 17:56:05 +0000
Message-ID: <22E0D05A-2261-4C28-965B-6350C36B613E@cisco.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
 <20150511064232.GA3042@phlsvsds.ph.intel.com>
 <D72B89F6-B333-4DC2-9BA7-CB45EBC31843@cisco.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1107C20E@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1107C20E-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <BB9CC562D3145546B761FE2DA9787276-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On May 11, 2015, at 7:13 PM, Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> Does my earlier email clarify the situation any?  http://marc.info/?l=linux-
>> rdma&m=142972178630720&w=2
> 
> Somewhat, is there any reason applications need to distinguish between the " The legacy RDMA_TRANSPORT_USNIC type" and " The current RDMA_TRANSPORT_USNIC_UDP type"?

Addressing is different between the two (Ethernet_MAC+QP# vs. IP+UDP_port, respectively).

Also, the received UD header format and size are different between them (40-byte synthetic GRH vs. 42-byte UDP/IP/Ethernet header).

> Or does the former no longer exist?

The former is no longer being deployed and should be rare to find in the wild at this point, though I do not know precisely how many customers may be using it still.  It is definitely legacy at this point.

>> Arguably RDMA_TRANSPORT_USNIC_UDP could/should have simply been
>> named RDMA_TRANSPORT_UDP.
> 
> I guess I'm wondering if there needs to be an RDMA_TRANSPORT_USNIC to represent the " The legacy RDMA_TRANSPORT_USNIC type" you mention in the link above.

It probably needs to exist for a little while still.

-Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
