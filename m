From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/saquery: Report SA MAD Class specific
 status.
Date: Mon, 2 Nov 2009 14:20:26 +0200
Message-ID: <20091102122026.GC21577@me>
References: <4AED4241.4000808@gmail.com>
 <20091101165223.GJ29434@me>
 <4AEEA4D6.8070109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AEEA4D6.8070109-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:22 Mon 02 Nov     , Eli Dorfman (Voltaire) wrote:
> >> +
> >> +static inline void report_err(int status)
> >> +{
> >> +	int st = status & 0xff;
> >> +
> >> +	if (st)
> >> +		fprintf(stderr, "ERROR: Query result returned: %s (0x%x)\n",
> >> +			ib_get_err_str(st), status);
> >> +	st = status >> 8;
> >> +	if (st)
> >> +		fprintf(stderr, "ERROR: Query result returned: %s (0x%x)\n",
> >> +			ib_sa_err_str(st), status);
> > 
> > Such two identical messages with different error strings seems
> > confusing to me. Wouldn't it be better to merge it in a single line,
> > like:
> > 
> > 	ERROR: Query result returned 0xNNNN: SM blah1 , SA blah2
> > 
> > (or similar), with making each part optional.
> 
> I agree.
> Is it possible according to the spec to have both SM and SA (i don't think so)

I don't know really, don't remember that it stated somewhere in the spec
explicitly. But even if so - it is slightly dangerous to assume in the
code that this will never happen.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
