From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Thu, 21 Jul 2011 10:38:22 +0300
Message-ID: <201107211038.23000.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <201106230935.07425.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373136F63B9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373136F63B9-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shamis, Pavel (shamisp-1Heg1YXhbW8@public.gmane.org)" <shamisp-1Heg1YXhbW8@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wednesday 20 July 2011 21:51, Hefty, Sean wrote:
> I've tried to come up with a clean way to determine the lifetime of an xrc tgt qp,\
> and I think the best approach is still: 
> 
> 1. Allow the creating process to destroy it at any time, and
> 
> 2a. If not explicitly destroyed, the tgt qp is bound to the lifetime of the xrc domain
> or
> 2b. The creating process specifies during the creation of the tgt qp
> whether the qp should be destroyed on exit. 
> 
> The MPIs associate an xrc domain with a job, so this should work.
> Everything else significantly complicates the usage model and implementation,
> both for verbs and the CM.  An application can maintain a reference count
> out of band with a persistent server and use explicit destruction
> if they want to share the xrcd across jobs.
I assume that you intend the persistent server to replace the reg_xrc_rcv_qp/
unreg_xrc_rcv_qp verbs.  Correct?
> 
> Option 2a is the current implementation, but 2b should be a minor change.
> I'd like to reach a consensus on the right approach here, since there doesn't
> appear to be issues elsewhere.  
> 
> - Sean

I have no opinion either way (with regard to tgt qp registration and reference counting).
The OFED xrc implementation was driven by the requirements of the MPI community.

If MPI can use a different XRC domain per job (and deallocate the domain
at the job's end), this would solve the tgt qp lifetime problem (-- by
destroying all the tgt qp's when the xrc domain is deallocated).

Regarding option 2b: do you mean that in this case the tgt qp is NOT bound to the
XRC domain lifetime? who destroys the tgt qp in this case when the creator indicates
that the tgt qp should not be destroyed on exit?

I am concerned with backwards compatibility, here.  It seems that XRC users will need to
change their source-code, not just recompile.  I am assuming that OFED will take the
mainstream kernel implementation at some point.  Since this is **userspace** code, there could be a problem
if OFED users upgrade their OFED installation to one which supports the new interface.
This could be especially difficult if, for example, the customer is using 3rd-party packages
which utilize the current OFED xrc interface.  We could start seeing customers not take
new OFED releases solely because of the XRC incompatibility (or worse, customers upgrading
and then finding out that their 3rd-party XRC apps no longer work).

Having a new OFED support BOTH interfaces is a nightmare I don't even want to think about!

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
