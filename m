From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] libibverbs: Add support for XRC QPs
Date: Thu, 16 Jun 2011 19:07:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730218D7@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237302124E@ORSMSX101.amr.corp.intel.com>
	<4DFA1BB8.9000305@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373021813@ORSMSX101.amr.corp.intel.com>
 <BANLkTi=r5kG4rUH1+dsgOg1LcdrzZRA_Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=r5kG4rUH1+dsgOg1LcdrzZRA_Ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I can't speak on behalf of XRC consumers, but as for the ethernet
> packet qp, we don't
> want to have two qp types, upstream one and ofa one. If it doesn't
> work for upstream to reserve the value of 8 for the packet qp
> (hopefully to be reviewed and merged soon...) we'll require everyone
> to recompile.

In a general sense, there's no guarantee that what gets accepted upstream will match what OFA provides.  The behavior, API, structure definitions, etc. could all be different.  Until a feature has been accepted upstream, IMO, OFA should make it clear that an out of tree feature is being used.  I.e. the app must include an OFA specific header file, obtain new interfaces, etc.

Imagine an app that's coded to use qp type 13 - whatever that is.  OFA provides some implementation for qpt 13, but the behavior ends up different when qpt 13 finally gets merged.  Now an app has no way to determine what exactly qpt 13 will do, or may see errors when running against upstream, but not OFA, because of some difference.

This results in an OFA support problem.  OFA either needs to wait until a feature is upstream before shipping it, or make it clear to a user that this is an OFA-only feature.  After a feature is merged upstream, OFA can decide if and how to support the old behavior of a feature, if it differs.  (Maybe it's as simple as the user space library converting an OFA qpt to an ibverbs qpt.)

Regardless, I'll set the XRC INI and TGT qpt to 9 and 10.  :)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
