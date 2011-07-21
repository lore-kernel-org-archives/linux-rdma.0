From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Thu, 21 Jul 2011 17:53:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373136F6691@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201106230935.07425.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F63B9@ORSMSX101.amr.corp.intel.com>
 <201107211038.23000.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201107211038.23000.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shamis, Pavel (shamisp-1Heg1YXhbW8@public.gmane.org)" <shamisp-1Heg1YXhbW8@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I've tried to come up with a clean way to determine the lifetime of an xrc
> tgt qp,\
> > and I think the best approach is still:
> >
> > 1. Allow the creating process to destroy it at any time, and
> >
> > 2a. If not explicitly destroyed, the tgt qp is bound to the lifetime of the
> xrc domain
> > or
> > 2b. The creating process specifies during the creation of the tgt qp
> > whether the qp should be destroyed on exit.
> >
> > The MPIs associate an xrc domain with a job, so this should work.
> > Everything else significantly complicates the usage model and
> implementation,
> > both for verbs and the CM.  An application can maintain a reference count
> > out of band with a persistent server and use explicit destruction
> > if they want to share the xrcd across jobs.
> I assume that you intend the persistent server to replace the reg_xrc_rcv_qp/
> unreg_xrc_rcv_qp verbs.  Correct?

I'm suggesting that anyone who wants to share an xrcd across jobs can use out of band communication to maintain their own reference count, rather than pushing that feature into the mainline.  This requires a code change for apps that have coded to OFED and use this feature.

> I have no opinion either way (with regard to tgt qp registration and reference
> counting).
> The OFED xrc implementation was driven by the requirements of the MPI
> community.

>From the emails threads I followed, it was a request from HP MPI.  The other MPIs have used the same interface since it was what was defined, but do not appear to be sharing the xrcd across jobs.  HP has since canceled their MPI product.

> Regarding option 2b: do you mean that in this case the tgt qp is NOT bound to
> the
> XRC domain lifetime? who destroys the tgt qp in this case when the creator
> indicates
> that the tgt qp should not be destroyed on exit?

With option 2b, the tgt qp lifetime is either tied to the life of the creating process or the xrcd.  The creating process specifies which on creation.  Basically, the choice allows the creating process to destroy the tgt qp when it exits, rather than waiting until the xrcd is closed.  Note that ibverbs only considers the life of the tgt qp, but we also need to the consider the life of a corresponding connection maintained by the IB CM.
 
> I am concerned with backwards compatibility, here.  It seems that XRC users
> will need to
> change their source-code, not just recompile.  I am assuming that OFED will
> take the
> mainstream kernel implementation at some point.  Since this is **userspace**
> code, there could be a problem
> if OFED users upgrade their OFED installation to one which supports the new
> interface.
> This could be especially difficult if, for example, the customer is using 3rd-
> party packages
> which utilize the current OFED xrc interface.  We could start seeing customers
> not take
> new OFED releases solely because of the XRC incompatibility (or worse,
> customers upgrading
> and then finding out that their 3rd-party XRC apps no longer work).

Eventually, the xrc users should change their source code to move away from the ofed compatability APIs.  An app needs to recompile regardless.  Existing apps will run into issues if they share the xrcd across jobs.  In that case, they will leak tgt qps.  There are also issues if an app calls the OFED ibv_modify_xrc_rcv_qp() or ibv_query_xrc_rcv_qp() APIs from a process other than the one which created the qp.  These are the main risks that I see.

> Having a new OFED support BOTH interfaces is a nightmare I don't even want to
> think about!

We're already in a situation where there are multiple libibverbs interfaces.  The OFED compatibility patch to libibverbs was added specifically so that OFED could support both sets of APIs, while being binary compatible with the upstream ibverbs.  The proposed kernel patches do not support the functionality required for the OFED APIs, but it's not clear whether apps are really dependent on that functionality.  (I don't want to make MPI have to change their code right away either.)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
