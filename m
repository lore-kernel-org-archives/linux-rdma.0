From: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Tue, 12 May 2015 17:41:14 +0000
Message-ID: <DC760F33-F704-4763-AEA3-6DE9016D0687@cisco.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
 <1431142328.2407.488.camel@redhat.com>
 <CCC397F5-31B6-4A35-94E0-7EAAE6C4803F@cisco.com>
 <20150511223930.GA15628@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511223930.GA15628-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <7ECE93D7FB97BA48B25ECE094CCCA52E-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On May 11, 2015, at 3:39 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> So, I look at this:
> 
> int usnic_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>                                struct ib_send_wr **bad_wr)
> {
>        usnic_dbg("\n");
>        return -EINVAL;
> }
> 
> And conclude that usnic doesn't actually provide any RDMA services to
> in-kernel users, correct?

Correct.

> I'd then guess the entire point of this is to hack some non-RDMA
> device to export it's interface via uverbs?

If by "non-RDMA", you mean "does not currently support hardware offload of direct data placement", then yes.  There are a couple of things to keep in mind:

1) usNIC is UD-only at this time.  Are there any kernel clients that make use of UD without also requiring RC? (this is a genuine question) 

2) When using UDP, usNIC deposits 42-byte UDP/IP/Ethernet headers into the start of the recv buffer, not a 40-byte GRH.  Unfortunately, the current verbs stack has no way to indicate the device's/port's/QP's header size, let alone format, to any client.  So clients must be aware they are using a usNIC device under the hood.

> Presumably because someone
> nack'd using your own char device or whatever?

I wasn't participating on the kernel side of the usNIC project at the time that some of the early decisions were made, but to my knowledge the uverbs stack was selected as the most appropriate way to expose this technology to users after evaluation of several approaches.  I don't think that any other approach was previously submitted and NACK-ed.

-Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
