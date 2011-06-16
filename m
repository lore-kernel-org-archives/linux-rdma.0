From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Thu, 16 Jun 2011 15:39:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730217E1@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
 <4DFA1DDD.5020508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFA1DDD.5020508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm trying to understand the way the user/kernel way of adding verbs
> is implemented... I wasn't sure, if/which specific kernel patch out
> of this series is matching this one?

There are no matching kernel patches to this patch.  This does not try to provide any direct support for out of tree kernel patches.

The closest this comes is reserving the upper 8-bits of any enum or other value, which can be used to indicate vendor specific support.  For example, an out of tree kernel patch could define a new QP type and ABI command with one of the higher bits set (rather than the next in series).  An upstream patch would remove these bits.  This should make it possible for a vendor to continue to support their out of tree changes even after that feature was added to the mainline.  Hopefully this makes sense.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
