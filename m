From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Re: [ewg] [PATCH v4] IB Core: RAW ETH support
Date: Wed, 16 Jun 2010 17:53:11 +0300
Message-ID: <4C18E557.5050804@Voltaire.COM>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com>	<1276513450.30132.51.camel@alst60.voltaire.com> <aday6eguhfn.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday6eguhfn.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

> What the hell is the thinking behind introducing IB_QPT_RAW_ETH?  You're
> inserting an enum value before IB_QPT_RAW_ETY, so any old userspace
> passing in IB_QPT_RAW_ETY will silently get different behavior depending
> on the kernel version.  And you're creating two constands that differ in
> a single letter (IB_QPT_RAW_ETY vs. IB_QPT_RAW_ETH).  How are you going
> to explain that to users?  How is anyone ever going to get it right?
> For that matter, what exactly does IB_QPT_RAW_ETH mean?
> 
There is no qp type IBV_QPT_RAW_ETY in user space (at least not in the definitions
coming with libibverbs). In fact, libibverbs that comes with OFED defines (in verbs.h)
a qp type called IBV_QPT_RAW_ETT which equals to 7.
The patch that is under discussion here adds a new qp type IB_QPT_RAW_ETH and equals it to 7
to match the definition in user space. This indeed changes the value of IB_QPT_RAW_ETY to 8
but I don't see who can be affected since
1. No user space program that uses IB_QPT_RAW_ETY exists
2. kernel is compiled as one piece of code.

> This all seems to be a symptom of how broken our development process
> is.  Yes, unfortunately I can't spend as much time reviewing and
> applying patches as I might like, and I apologize for that.  But if we
> have all the RDMA developers piling up shit in their little area and
> then sending it on to be merged as soon as it kind of works, without
> thinking about design or maintainability and without ever doing any
> review, then I'm always going to have an expanding review backlog.
> 
I want very much to push the RAW_ETH patches to upstream and we didn't intend to skip
this stage. However,
1. It seems that upstream kernel still can't use ConnectX ETH ports. Is it right?
2. From practical (commercial) reasons it was important to us that the RAW_ETH patches 
will be in OFED. AFAIK, OFED recommends that patches will be reviewed and added first in 
upstream kernel but exceptions are allowed. Anyway, we didn't think that a review is not
necessary, we just used the OFED group for that matter.
> And then we have OFED compounding problems -- "Oh that's a nice pile of
> shit you've built there.  We better ship it to users while it's still
> steaming."  How about if OFED developers take a little time to think
> things through?
> 
> </rant>
> 
> In other words, can someone explain the plan for this raw QP stuff to me?
I hope I understand what needs to be explained but in short, we want a QP type
that takes the data in post_send() and puts it on the wire as is without adding
headers or footers. This allows the user of this kind of QP to build an entire Ethernet
packet and send it to an Ethernet switch port.

UD/RC QP with RoCEE is no good because we want to be compliant with simple ETH devices (e.g. remote
server with standard 10G NIC)
Infiniband RAW packets is no good (if I understand the spec correctly) because it adds LRH and is not
suitable for fabrics with Ethernet switch

This is why RAW_ETH was invented.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
