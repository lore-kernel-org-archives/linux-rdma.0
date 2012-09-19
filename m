From: Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: how to preserve QP over HA events for librdmacm applications
Date: Wed, 19 Sep 2012 15:58:40 +0000
Message-ID: <A4E971F4031F1840BBA6E79B417E62E82CF29C3B@MTRDAG01.mtl.com>
References: <5059E82E.9020600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com>
 <5059EA48.1040407@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5059EA48.1040407-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since we use the RDMA_PS_IPOIB we need librdmacm to help get the correct pkey_index and qkey (in INIT->RTR transition) to match IPoIB's UD QP own values. If not, than our user space UD QP will not be able to send/recv from IPoIB on remote machines (which is what we want to gain by using the IPOIB port space).

Maybe we can save the values used from the rdma_create_qp and reuse them once modify the UD QP state by libverbs (ibv_modify_qp).
It would be nice if we had access to the rdma's modify qp wrapper to do this nicely from application level.

Alex 

-----Original Message-----
From: Or Gerlitz 
Sent: Wednesday, September 19, 2012 6:53 PM
To: Alex Rosenbaum
Cc: Hefty, Sean; linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
Subject: Re: how to preserve QP over HA events for librdmacm applications

On 19/09/2012 18:48, Hefty, Sean wrote:
>> Can this flushing be somehow done with the current 
>> librdmacm/libibverbs APIs or we need some enhancement?
> You can call verbs directly to transition the QP state.  That leaves the CM state unchanged, which doesn't really matter for UD QPs anyway.
>
>

Alex,

Any reason we can't deploy this hack? is that for the IPoIB port space it would require copying some low level code from librdmacm or even from the kernel? e.g the IPoIB qkey, etc.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
