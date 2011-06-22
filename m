From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 22 Jun 2011 22:21:05 +0300
Message-ID: <201106222221.05993.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <201106222003.50214.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373029B3F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373029B3F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I read over the threads that you referenced.  I do understand what the 
> reg/unreg calls were trying to do. In short, I agree with your original approach
> of letting the tgt qp hang around while the xrcd exists, 
> and I'm not convinced what HP MPI was trying to do should drive a 
> more complicated implementation and usage model.
I believe that MPI is the major XRC user, and we wished to make XRC as easy
as possible for them to use in their environment.
 
> For MPI, I would expect an xrcd to be associated with a single job instance.
So did I, but they said that this was not the case, and they were very pleased
with the final (more complicated implementation-wise) interface.
We need to get them involved in this discussion ASAP. 

Tziporet, who should be the MPI contacts for this thread?

> Trying to share an xrcd across jobs just seems like a bad idea.
I agree, but this did not seem to be an issue for the MPI community.
I am aware of the dangers of Job A crossing over into Job B's SRQs,
because the XRC domains are not distinct. Evidently, though, they did not consider this
loophole dangerous.

> (You asked about this here  http://lists.openfabrics.org/pipermail/general/2007-December/044282.html)
> A tgt qp should be fairly minimal in its resource allocation.  Would it really be that bad to just let
> it hang around until the xrcd was destroyed?
This does constitute a resource leakage of sorts, since "dead" resources would accumulate in the xrc domain.

> It makes the usage model much simpler.  TGT QPs are handled using the existing API and kernel ABI.     
> 
> Here are some other random thoughts.  We can destroy an unassociated tgt qp on an error, but is it likely
> a tgt qp will get an async error?
I need to think about this.

> We can also destroy an unassociated tgt qp when an xrcd 
> has no more associated srq's.
This is a problem, because in the MPI usage model, there are almost always associated SRQs active.
One job is finishing, another job starts (creating more associated SRQs of its own) before the first finishes.
It is possible we would not have a window of inactivity here.

> We can report the creation of a tgt qp on an xrcd as an async event.
To whom?

> Should there be a way for a user to query all tgt qp's that exist on an xrcd?
There has been no request for such a feature as yet.  However, with the current OFED implementation,
when a job finished all its TGT qp's are destroyed because their reference counts go to zero.
(This mechanism actually works very well).

> Should only one process 'own' the tgt qp, or should any process that can open the xrcd be allowed to modify any tgt qp?
Currently, any process that has access to the xrcd object and the tgt QP number can modify and query that QP.
(the (xrc domain handle + qpn) pair functioned as a handle). 

-Jack 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
