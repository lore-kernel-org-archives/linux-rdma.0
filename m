From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: how to preserve QP over HA events for librdmacm applications
Date: Wed, 19 Sep 2012 18:52:40 +0300
Message-ID: <5059EA48.1040407@mellanox.com>
References: <5059E82E.9020600@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8E418-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/09/2012 18:48, Hefty, Sean wrote:
>> Can this flushing be somehow done with the current librdmacm/libibverbs APIs
>> or we need some enhancement?
> You can call verbs directly to transition the QP state.  That leaves the CM state unchanged, which doesn't really matter for UD QPs anyway.
>
>

Alex,

Any reason we can't deploy this hack? is that for the IPoIB port space 
it would
require copying some low level code from librdmacm or even from the 
kernel? e.g
the IPoIB qkey, etc.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
