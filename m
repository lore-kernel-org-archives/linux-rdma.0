From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 22 Jun 2011 20:03:50 +0300
Message-ID: <201106222003.50214.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <201106221017.06212.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373029A95@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373029A95-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wednesday 22 June 2011 19:14, Hefty, Sean wrote:
> This is partly true, and I haven't come up with a better way to handle this.  
> Note that the patches allow the original creator of the TGT QP to destroy it by simply calling ibv_destroy_qp().
> This doesn't handle the process dying, but maybe that's not a real concern.  
Correct, that was not the MPI community's main concern.
 
> 
> After looking at the implementation more, what I didn't like about the reg/unreg
> calls is that it is independent of receiving data on an SRQ.  That is, a user can
> receive data on an SRQ through a TGT QP before they have registered and after unregistering.
That is correct, but the registering/unregistering is for expressing "interest" in the TGT QP, only (i.e., for
reference counting only, as you indicated), and not at all for enabling the SRQ to receive traffic.
When the reference count on the TGT QP goes to zero, it is automatically destroyed.
(The TGT QP creator itself takes a reference, which is decremented when either the
process exits, or it calls the deref procedure.)

In my thread post
    http://lists.openfabrics.org/pipermail/general/2008-January/045302.html  ,
I describe the intended workflow for this interface.

-Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
