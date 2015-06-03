From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Wed, 3 Jun 2015 14:46:33 -0600
Message-ID: <20150603204633.GE7902@obsidianresearch.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433098827.114391.179.camel@redhat.com>
 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
 <1433157904.114391.188.camel@redhat.com>
 <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com>
 <20150602180844.GD17776@obsidianresearch.com>
 <CAJ3xEMjZqwJC8=HrMBv_eSVKVtLW7qjVZNjtuD28octGPtYu6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjZqwJC8=HrMBv_eSVKVtLW7qjVZNjtuD28octGPtYu6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 03, 2015 at 10:48:28PM +0300, Or Gerlitz wrote:

> >  - Should the frequency and mask be general, or driver private? If the
> >    cycles->ns conversion is a function they should be driver private.
> >    Even if they are general at libibverbs, they don't *have* to be in
> >    the kernel's general query response.
> 
> If they are general in libibverbs, what's the point not to put them in
> the kernel's general query response?

If there is a timestamp_to_ns API then they would not be general in
libiverbs either.

> >  - Should frequency even be frequency? Most clocks are expressed
> >    accurately as a period in picoseconds. Frequency is more often
> >    imprecise. (eg ethernet is 3200 ps or 312.5MHz)
> >    However FDR/EDR is fractional for both (4693.33333333 ps vs
> >    213.0681818181818 MHz)
> >    Precision is very important for time conversions, so a
> >    multiply-divide scheme would be ideal.
> 
> From Christoph's response I got the impression that our proposal of
> exposing frequency and mask combined with raw time stamps excellently
> fits typical user needs, so I thought we're good. Doug made a comment
> that things look OK to him and the rest of the work would be when we
> come to review the user-space patches.

This response ignores my point about precision.

MHz is fine *for mlx hardware* but someone elses hardware that uses,
say 312.5 MHz (ie the ethernet symbol clock) is NOT OK because MHz
looses too much precision.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
