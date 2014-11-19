From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 for-next 2/2] IB/mlx4_ib: Disassociate support
Date: Wed, 19 Nov 2014 14:15:34 +0200
Message-ID: <546C89E6.1000204@dev.mellanox.co.il>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com>	<1416312682-7899-3-git-send-email-yishaih@mellanox.com>	<546B5AE3.9060606@mellanox.com>	<546B7E73.40008@dev.mellanox.co.il> <CAJ3xEMjzZdf_aML2e+ht=cbYx3T9U7Lr7DOR6+JenEKTcxQ+Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjzZdf_aML2e+ht=cbYx3T9U7Lr7DOR6+JenEKTcxQ+Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/18/2014 11:50 PM, Or Gerlitz wrote:
> On Tue, Nov 18, 2014 at 7:14 PM, Yishai Hadas
> <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On 11/18/2014 4:42 PM, Or Gerlitz wrote:
>
>>> Can we somehow make this patch generic (e.g land in the IB core) such
>>> that it can apply also for mlx5 (and other HW drivers...) basically, the
>>> HW driver should tell the IB core which pages to zap and we should be
>>> OK, isn't that?
>
>> We introduced a generic API that asked the low level driver to detach a
>> given ucontext from its HW resources. The specific driver implementation may
>> be different between HW devices and may not involve the zap usage, that's
>> why it wasn't put in IB core. In addition, the zap API should be in sync
>> with inflight VMA closing to prevent zapping an already unmapped address. To
>> achieve that the driver should implement some VMA ops and synchronize
>> between those flows.
>
> Again, drivers that don't want to go the zapping way, could just avoid
> this generic code.
>
> So we have already two more low-level drivers (cxgb3/4) that would be
> happily using the 95% of the mlx4_ib code you wrote after the
> re-factoring I suggested.
> I tend to think mlx5_ib should join too. Why not try it out, write the
> code in the way which
>
> 1. under the IB core
> 2. easiest to use under this twist for mlx4_ib
>
> and let cxgb3/4 and mlx5 maintainers to see if/how they can use it.

The HW driver upon mmap of its UARs needs to manage their VMAs, it 
includes saving the VMAs pointers on its internal context, set its 
private VMA open/close operations, etc. In addition, the HW Driver 
should synchronize between VMA closing to a parallel call of ucontext 
detaching.

To use the ZAP API the internal context of the HW driver should be used 
and its state should be considered, as such it makes sense that it will 
be used as part of the HW Driver. In addition, there may be some others 
vendors that may not use it as part of their ucontext detaching at all.

For that reason we believe that the correct place to use the zap call is 
in the HW driver and not in IB core, at least at first phase.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
