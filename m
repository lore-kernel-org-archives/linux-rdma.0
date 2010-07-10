From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Sat, 10 Jul 2010 11:55:18 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com>
References: <AANLkTikXzoaRl61ivsc7fm8EdO9Ucz4iGGfclFOQl3kK@mail.gmail.com>
	<adabpb1s58c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFE88@MTLMAIL.mtl.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF259E7DE3D0@orsmsx501.amr.corp.intel.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFF16@MTLMAIL.mtl.com>
	<20100624203701.GA4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78B0042@MTLMAIL.mtl.com>
	<20100625155755.GC4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
	<adak4pcnw3c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com>
	<4C32D0BD.3030902@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com>
	<4C3417FA.7000600@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3417FA.7000600-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This discussion has derived into whether we need to expose Eth L2 params across the Verbs interface.
This point has been discussed extensively in the IBTA during the development of the RoCE spec. And the direction chosen by the spec is clear:

"...A verbs consumer using a RoCE network relies strictly on so-called Layer
3 addressing (GIDs); layer 2 addresses (e.g. subnet local identifiers) are not passed across the verbs interface..."

The motivation behind this direction had to do with preserving API transparency for applications.
The goal was to allow existing and future applications to run above RoCE and native IB without changes. 

As opposed to what it may seem at first sight, adding Eth L2 parameters to the address vector, *does not* make RoCE closer to IB.
It actually goes the other way around.
Here is a quick list of what would have to be changed if we were to include Eth L2 address parameters to the Address Vector and other structures/functions that expose L2 params:

Structure changes:
- ibv_wc
- ibv_ah_attr
-- ibv_qp_attr
-- rdma_ud_param
--- rdma_cm_event
- ibv_port_attr

Verb API changes:
- ibv_poll_cq()
- ibv_init_ah_from_wc()
- ibv_create_ah()

- ibv_query_qp()
- ibv_modify_qp()

- ibv_query_port()

- ibv_attach_mcast()
- ibv_detach_mcast()

rdmacm API changes:
- rdma_post_ud_send()
- rdma_get_cm_event()
- rdma_ack_cm_event()
 
As a result of this:
- Existing IB binaries would cease working over RoCE.
- Due to added fields in structures, even just recompiling existing applications from source would be problematic.
- To make future applications work on both ib and RoCE transparently, you would need additional wrappers such as init_ah(), copy_ah(), and ah_is_equal(), and never inspect address handle fields directly.

So why introduce differences between RoCE and IB (for the Application writers!!) when they *aren't* needed? Using rdmacm won't solve this either (UD traffic).
By following the direction set forth by the RoCE spec none of this is required. Existing (rdmacm) application binaries do run over RoCE or IB unchanged.

Granted, the RoCE spec approach introduces 2 *implementation* issues that we need to tackle:
1. Address resolution, which is a generic function, should not be a device-specific call.
In this matter, we already proposed a solution where resolution is done, as required, in generic functions in the kernel.
Specifically, we provide L2 information to user-space drivers via create_ah(), avoiding the need to add a new ABI call altogether, while the resolution would take place in a generic CMA routine.

2. The Kernel currently assumes that create_ah() can execute in atomic context.
One option is to distinguish between the create_ah() calls (in the kernel) that are done for iboe, which are very few, and the rest of the calls that are ib-only.
There are other approaches to solve this as well.

It seems clear that our goal should be to solve these issues inside the kernel, in the cleanest manner as possible, while preserving transparency to the applications.

Comments are welcome.

Liran 

> -----Original Message-----
> From: Or Gerlitz [mailto:ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org] 
> Sent: Wednesday, July 07, 2010 9:00 AM
> To: Liran Liss
> Cc: Roland Dreier; Jason Gunthorpe; Hefty, Sean; Aleksey 
> Senin; linux-rdma; monis-smomgflXvOZWk0Htik3J/w@public.gmane.org; alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org; 
> yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org; Tziporet Koren; alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
> Subject: Re: When IBoE will be merged to upstream?
> 
> Liran Liss wrote:
> > but keeping ib_create_ah() callable from any context is not 
> a goal by itself.
> 
> going with your approach, if your proposed design is 
> accepted, I believe that you probably need to patch all the 
> code-chains that makes calls under the current assumption
> 
> > I am looking for constructive ideas for supporting iboe without 
> > breaking Verbs/CQE/CM syntax.
> 
> I don't agree that exposing the Ethernet L2 related 
> information to the caller is breaking something, the 
> converse, it is a required enhancement. 
> 
> I think we need to let resolve through the rdma-cm && get to 
> know at the consumer level, what are the source / destination 
> macs, vlan id and vlan priority used by an IBoE QP, in the 
> exact manner all the IB equivalents (src/dst lid, pkey, sl) 
> are resolved by the rdma-cm and exposed to the consmer app for IB QP.
> 
> Or.
> 
> --
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
