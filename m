From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Thu, 23 Jun 2011 18:03:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373029F48@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201106222221.05993.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373029BDE@ORSMSX101.amr.corp.intel.com>
 <201106230935.07425.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106230935.07425.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If you are thinking of using this for tracking, there is no way that I can
> see except reference counting to know when all users of the TGT have
> finished with it.  Indicating usage by "tapping" the TGT QP whenever an
> SRQ receives a packet via the TGT is not a good idea (this is data
> path!), not to mention that quiescence is not a good indicator of whether
> an app is done using the target (the amount of time that things
> are quiet depends on the app).

I mentioned the event as a standard way for communicating the tgt qp to other processes using the xrcd.  Currently, we have something like this:

Process 1:
create tgt qp
for each relevant process
	send out of band message with tgt qpn

Process 2..n:
receive tgt qpn
kernel call to register with tgt qp
kernel searches for tgt qpn, bumps ref count
<later>
kernel call to unregister with tgt qp
kernel searches for tgt qpn, decrements ref count

The use of an event is simply an (incomplete) idea to standardize what is currently done by sending/receiving the out of band messages with the tgt qpn.  On this note, I can't imagine that this usage model is better performing that simply creating a new xrcd for each job...

I was thinking about this more last night, in more generic terms, what we want is a way for an application to allocate a QP in the kernel and share it with other apps.  I think it would be best to reuse the existing ibverbs API and kern-abi as much as possible.  (Eventually someone may find a use for this other than just TGT QPs.)  I just don't know how we handle sharing or transferring ownership of the CM data.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
