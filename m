From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: how to preserve QP over HA events for librdmacm applications
Date: Wed, 19 Sep 2012 12:52:41 -0400
Message-ID: <46C75A5F-AD9F-45CF-A441-B7D5F60709D8@ornl.gov>
References: <5059E82E.9020600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com>
 <5059EA48.1040407@mellanox.com>
 <A4E971F4031F1840BBA6E79B417E62E82CF29C3B@MTRDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A4E971F4031F1840BBA6E79B417E62E82CF29C3B-SlGPd/IId7auSA5JZHE7gA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sep 19, 2012, at 11:58 AM, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Since we use the RDMA_PS_IPOIB we need librdmacm to help get the correct pkey_index and qkey (in INIT->RTR transition) to match IPoIB's UD QP own values. If not, than our user space UD QP will not be able to send/recv from IPoIB on remote machines (which is what we want to gain by using the IPOIB port space).
> 
> Maybe we can save the values used from the rdma_create_qp and reuse them once modify the UD QP state by libverbs (ibv_modify_qp).
> It would be nice if we had access to the rdma's modify qp wrapper to do this nicely from application level.

I too would be interested in bringing a QP from error back to a usable state. I have been debating whether to reconnect using the current RDMA calls versus trying to transition the existing RC QP.

I assumed to transition the existing QP that I would need to open a socket to coordinate the two sides. Is that correct?

If I were instead to use rdma_connect(), does it require a new CM id or just a new QP within the same id?

Thanks,

Scott


> -----Original Message-----
> From: Or Gerlitz 
> Sent: Wednesday, September 19, 2012 6:53 PM
> To: Alex Rosenbaum
> Cc: Hefty, Sean; linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> Subject: Re: how to preserve QP over HA events for librdmacm applications
> 
> On 19/09/2012 18:48, Hefty, Sean wrote:
>>> Can this flushing be somehow done with the current 
>>> librdmacm/libibverbs APIs or we need some enhancement?
>> You can call verbs directly to transition the QP state.  That leaves the CM state unchanged, which doesn't really matter for UD QPs anyway.
>> 
>> 
> 
> Alex,
> 
> Any reason we can't deploy this hack? is that for the IPoIB port space it would require copying some low level code from librdmacm or even from the kernel? e.g the IPoIB qkey, etc.
> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
