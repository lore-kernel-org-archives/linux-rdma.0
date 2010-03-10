From: Fredrik Unger <funger-e+cCxrzAqRFWk0Htik3J/w@public.gmane.org>
Subject: Re: kitten - mlx4: Unhandled interrupt - owner bit
Date: Wed, 10 Mar 2010 20:39:51 +0100
Message-ID: <4B97F587.3000209@hpce.nec.com>
References: <4B97B4BE.1050809@hpce.nec.com> <20100310163521.GB18440@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100310163521.GB18440-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> On Wed, Mar 10, 2010 at 04:03:26PM +0100, Fredrik Unger wrote:
>> When investigating the error it seems to stem from next_eqe_sw in drivers/net/mlx4/eq.c
>> called by the interrupt handler.
>> What happens is that (eqe->owner & 0x80) is true causing the routine to return
>> NULL resulting in an unhandled interrupt (eg the interrupt routine returns 0)
> 
> Please note that the condition is a bit more complicated. I quote the
> whole function:
> 
> static struct mlx4_eqe *next_eqe_sw(struct mlx4_eq *eq)
> {
>         struct mlx4_eqe *eqe = get_eqe(eq, eq->cons_index);
>         return !!(eqe->owner & 0x80) ^ !!(eq->cons_index & eq->nent) ? NULL : eqe;
> }

Yes you are correct,
To clarify I checked each of the statements separatly and from what I
could gather
(eqe->owner & 0x80) was true and
(eq->cons_index & eq->nent) false.
But true! As I am not sure what each statement hides,
I do not know if both should be false or true for the eqe to be
returned. Will try to check the cons_index closer.

Where could I find out more about owner and cons_index / nent ?

Thank you,

Fredrik Unger


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
