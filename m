From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Wed, 22 Jun 2011 16:14:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373029A95@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201105181754.33759.jackm@dev.mellanox.co.il>
 <201106221017.06212.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106221017.06212.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I noticed (from the code in your git, xrc branch) that the XRC target QPs
> stick around until the XRC domain is de-allocated.
> There was a long thread about this in December, 2007, where the MPI
> community
> found this approach unacceptable (leading to accumulation of "dead" XRC
> TGT qp's).
> They needed to leave the XRC domain active, and just allocate/delete TGT
> QPs as needed,
> without resource usage buildup.

This is partly true, and I haven't come up with a better way to handle this.  Note that the patches allow the original creator of the TGT QP to destroy it by simply calling ibv_destroy_qp().  This doesn't handle the process dying, but maybe that's not a real concern.

If the QP is tied into the CM protocol, it may also be possible to automatically destroy it when receiving a DREQ, provided that the creating process no longer owns it.  This would need to be a new patch.

Thanks for the pointers to the threads.  I'll re-read those.

> This discussion lead to the addition of the XRC reg/unreg verbs for
> processes to
> "register" with XRC TGT QPs, and reference counting for destroying
> these QPs.

After looking at the implementation more, what I didn't like about the reg/unreg calls is that it is independent of receiving data on an SRQ.  That is, a user can receive data on an SRQ through a TGT QP before they have registered and after unregistering.  From the perspective of a user space API, this is counter-intuitive.  The reg/unreg calls are basically for reference counting some kernel component.

I also liked the idea of having a single process own control of the TGT QP, for the purposes of modifying it or destroying it, separately from other processes that may be sharing the same xrcd.

> In addition, this approach also required propagating the XRC TGT QP events
> to all processes registered with that QP, so that they could unregister
> in the event of an error -- reducing the QP reference count and allowing
> it to be destroyed.

Ok - I was having a hard time figuring out what exactly all of the processes were supposed to do with the TGT QP events.  It seemed like only one of them could actually respond to any error.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
