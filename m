From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Wed, 22 Jun 2011 18:19:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373029B3F@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201106221017.06212.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373029A95@ORSMSX101.amr.corp.intel.com>
 <201106222003.50214.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106222003.50214.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > After looking at the implementation more, what I didn't like about the
> reg/unreg
> > calls is that it is independent of receiving data on an SRQ.  That is, a
> user can
> > receive data on an SRQ through a TGT QP before they have registered and
> after unregistering.
> That is correct, but the registering/unregistering is for expressing
> "interest" in the TGT QP, only (i.e., for
> reference counting only, as you indicated), and not at all for enabling
> the SRQ to receive traffic.
> When the reference count on the TGT QP goes to zero, it is automatically
> destroyed.
> (The TGT QP creator itself takes a reference, which is decremented when
> either the
> process exits, or it calls the deref procedure.)
> 
> In my thread post
>     http://lists.openfabrics.org/pipermail/general/2008-
> January/045302.html  ,
> I describe the intended workflow for this interface.

I read over the threads that you referenced.  I do understand what the reg/unreg calls were trying to do.  In short, I agree with your original approach of letting the tgt qp hang around while the xrcd exists, and I'm not convinced what HP MPI was trying to do should drive a more complicated implementation and usage model.

For MPI, I would expect an xrcd to be associated with a single job instance.  Trying to share an xrcd across jobs just seems like a bad idea.  (You asked about this here  http://lists.openfabrics.org/pipermail/general/2007-December/044282.html)  A tgt qp should be fairly minimal in its resource allocation.  Would it really be that bad to just let it hang around until the xrcd was destroyed?  It makes the usage model much simpler.  TGT QPs are handled using the existing API and kernel ABI.

Here are some other random thoughts.  We can destroy an unassociated tgt qp on an error, but is it likely a tgt qp will get an async error?  We can also destroy an unassociated tgt qp when an xrcd has no more associated srq's.  We can report the creation of a tgt qp on an xrcd as an async event.  Should there be a way for a user to query all tgt qp's that exist on an xrcd?  Should only one process 'own' the tgt qp, or should any process that can open the xrcd be allowed to modify any tgt qp?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
