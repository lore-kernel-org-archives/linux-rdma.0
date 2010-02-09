From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ewg] rdma/cm: revert associating an RDMA device when binding to loopback
Date: Tue, 9 Feb 2010 14:20:43 -0800
Message-ID: <E47AAE69426A476B821993746CC1ED27@amr.corp.intel.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com><0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com><4B6C498F.3060708@opengridcomputing.com><38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com><4B6D9948.6040007@opengridcomputing.com><B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com><79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com><4B6FFB1B.40905@mellanox.co.il><4B701FE6.60302@opengridcomputing.com><adawrynwtz9.fsf@roland-alpha.cisco.com><421D3D6710E847C5B7CAC00EB73117C4@amr.corp.intel.com><4B717F5D.8020403@opengridcomputing.com> <4B718A2C.2030602@linux.vnet.ibm.com> <4FA7F42E-308A-4A4D-82D8-87794CB8C4DE@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FA7F42E-308A-4A4D-82D8-87794CB8C4DE-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jeff Squyres' <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>1. Is this now the recommended way to find all the IP interfaces that support
>RDMA:
>
>- loop over all local IP addresses
>- if 127.0.0.1/8, skip

Include ipv6 in the checks.

>- try to rdma_bind_addr()
>- if it succeeds and verbs ptr is != NULL, it's an RDMA device

The intent is that rdma_bind_addr should bind to an RDMA device as long as the
address isn't a wildcard, so that resource can be allocated.  If an address is
passed into rdma_bind_addr and the call returns success, then verbs ptr 'should'
be set.  (This is the bug that was fixed, then reverted.)

>(I believe Steve Wise proposed adding an API function to just return a list of
>IP addresses of RDMA devices a while back; it was rejected

Not sure why the idea it was rejected.  I can't think of a problem with
returning a list of devices/ports and the corresponding IP addresses.  Although,
I'd expect the implementation to match what you have above.  At the very least
it could reduce code duplication in librdmacm users.

>2. Before Sean backed out the localhost behavior, when you
>rdma_addr_bind(127.0.0.1), what did the id->verbs pointer correspond to?

id->verbs referenced the first device found with an active port, or the first
device if no ports were active.  This behavior was never updated when iwarp was
added to the stack.

Note that this patch reverted the behavior of rdma_bind_addr(127.0.0.1), but
other new functionality was left in.  The result is that rdma_connect(127.0.0.1)
will still work as long as the selected device can support loopback.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
