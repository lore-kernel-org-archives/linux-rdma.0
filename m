From: Christopher Mitchell <kermmartian-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Sharing MR Between Multiple Connections
Date: Wed, 14 Nov 2012 19:06:27 -0500
Message-ID: <CAPb9-SHVPipqd7-zAa5Cf5+_sO=k_xk2vsbUF4YiRPWdF0aFhg@mail.gmail.com>
References: <CAPb9-SHQ=r1MYu=771z2cTi9bAq=ueWMjw2vFDoSHbNByK5awA@mail.gmail.com>
	<CAPb9-SHVmNFm-rCviMLfu7GQhK065fWGTGzJssxLrLMZHDMFpQ@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346AD8B5A@ORSMSX101.amr.corp.intel.com>
	<CAPb9-SEHXKKmVGhsxTrku19H1q3hBE=iejjYMOfMSk+K1W09Zg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346AD8BC5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346AD8BC5-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 14, 2012 at 1:19 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > The rdma_cm will automatically allocate one PD per RDMA device.  You can
>> share this PD among multiple connections.  To use this PD, pass in NULL into
>> rdma_create_qp().  The rdma_cm_id will reference the shared PD.
>>
>> That's great to know; thanks Sean (and everyone else who confirmed
>> that a shared PD and possibly CQ is the way to go). Is there a way to
>> reference this shared PD in ibv_reg_mr() as well? It seems that using
>> NULL there too is not the solution, and I'm having difficulty tracing
>> back from struct rdma_cm_id to find out where that shared PD is
>> stored. I'd prefer to use this solution for simplicity's sake, so any
>> additional details would be greatly appreciated. For what it's worth,
>> I tried passing NULL to rdma_create_qp() as you suggested, and found
>> it to work admirably.
>
> struct rdma_cm_id *id;
>
> ibv_reg_mr(id->pd, ...);

It actually turned out to be id->qp->pd for me for some reason; the
rdma_cm_id struct on my machine has no pd member. But other than that,
all is working great. Thanks again.

Christopher
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
