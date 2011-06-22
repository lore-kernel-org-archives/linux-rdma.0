From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Wed, 22 Jun 2011 19:57:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373029BDE@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201106222003.50214.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373029B3F@ORSMSX101.amr.corp.intel.com>
 <201106222221.05993.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106222221.05993.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > For MPI, I would expect an xrcd to be associated with a single job
> instance.
> So did I, but they said that this was not the case, and they were very
> pleased
> with the final (more complicated implementation-wise) interface.
> We need to get them involved in this discussion ASAP.

I agree.  But I've also heard MPI developers complain loud and long about how difficult it is for them to establish connections over IB.

Maybe we can come up with something that supports both usage models and let the user specify the lifetime of the tgt qp.

> > We can report the creation of a tgt qp on an xrcd as an async event.
> To whom?

to all users of the xrcd.  IMO, if we require undefined, out of band communication to use XRC, then we have an incomplete solution.  It's just too bad that we can't report additional data (like the tgt qpn) with an async event...
 
> > Should there be a way for a user to query all tgt qp's that exist on an
> xrcd?
> There has been no request for such a feature as yet.  However, with the
> current OFED implementation,
> when a job finished all its TGT qp's are destroyed because their reference
> counts go to zero.

Again, I don't think we should rely on undefined communication to make xrc work.  If we must rely on some sort of registration feature, then there should be some standard way for communicating the tgt qpn's.  If we can't define some standard way of doing that because it 'breaks' the apps, then we should rethink the registration approach.

Also, MPI ignores a lot of the IB standard for connections and SA communication.  I don't believe that what we push upstream should.  We need to handle XRC using the CM protocol, alternate paths, etc. and be able to route those events to the correct responding process.  Maybe we need some way to transfer ownership of a tgt qp from one process to another, rather than trying to share ownership.

Is there *any* way for a tgt qp to know if the remote ini qp is still active?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
