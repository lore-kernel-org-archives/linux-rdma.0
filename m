From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] nfsrdma fails to write big file,
Date: Sat, 27 Feb 2010 22:22:32 -0600
Message-ID: <4B89EF88.1030903@opengridcomputing.com>
References: <9FA59C95FFCBB34EA5E42C1A8573784F02662E58@mtiexch01.mti.com>	<4B82D1B4.2030902@opengridcomputing.com>	<9FA59C95FFCBB34EA5E42C1A8573784F02662EA8@mtiexch01.mti.com>	<9FA59C95FFCBB34EA5E42C1A8573784F02663166@mtiexch01.mti.com> <ada3a0q1mje.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada3a0q1mje.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mahesh Siddheshwar <siddheshwar.mahesh-xsfywfwIY+M@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > +               /* 
>  > +                * Add room for frmr register and invalidate WRs
>  > +                * Requests sometimes have two chunks, each chunk
>  > +                * requires to have different frmr. The safest
>  > +                * WRs required are max_send_wr * 6; however, we
>  > +                * get send completions and poll fast enough, it
>  > +                * is pretty safe to have max_send_wr * 4. 
>  > +                */
>  > +               ep->rep_attr.cap.max_send_wr *= 4;
>
> Seems like a bad design if there is a possibility of work queue
> overflow; if you're counting on events occurring in a particular order
> or completions being handled "fast enough", then your design is going to
> fail in some high load situations, which I don't think you want.
>
>   

Vu,

Would you please try the following:

- Set the multiplier to 5
- Set the number of buffer credits small as follows "echo 4 > 
/proc/sys/sunrpc/rdma_slot_table_entries"
- Rerun your test and see if you can reproduce the problem?

I did the above and was unable to reproduce, but I would like to see if 
you can to convince ourselves that 5 is the right number.

Thanks,
Tom

>  - R.
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
