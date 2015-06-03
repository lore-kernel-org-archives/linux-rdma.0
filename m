From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Wed, 3 Jun 2015 22:48:28 +0300
Message-ID: <CAJ3xEMjZqwJC8=HrMBv_eSVKVtLW7qjVZNjtuD28octGPtYu6w@mail.gmail.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	<1433098827.114391.179.camel@redhat.com>
	<CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	<1433157904.114391.188.camel@redhat.com>
	<20150601164322.GA14391@obsidianresearch.com>
	<1433255724.114391.225.camel@redhat.com>
	<20150602180844.GD17776@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150602180844.GD17776-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 2, 2015 at 9:08 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> Or, the question in my mind based on looking at the UAPI patches is
> what things should be driver private and what should be general.
>
> Broadly my thoughts:
>  - Should the frequency and mask be general, or driver private? If the
>    cycles->ns conversion is a function they should be driver private.
>    Even if they are general at libibverbs, they don't *have* to be in
>    the kernel's general query response.

If they are general in libibverbs, what's the point not to put them in
the kernel's general query response?

>  - Should frequency even be frequency? Most clocks are expressed
>    accurately as a period in picoseconds. Frequency is more often
>    imprecise. (eg ethernet is 3200 ps or 312.5MHz)
>    However FDR/EDR is fractional for both (4693.33333333 ps vs
>    213.0681818181818 MHz)
>    Precision is very important for time conversions, so a
>    multiply-divide scheme would be ideal.

>From Christoph's response I got the impression that our proposal of
exposing frequency and mask combined with raw time stamps excellently
fits typical user needs, so I thought we're good. Doug made a comment
that things look OK to him and the rest of the work would be when we
come to review the user-space patches.

>    This is suggesting to me these details really are not general.
>  - There should be much better definition on what all this stuff is,
>    units for frequency? When is the timestamp applied?

The timestamp is applied when the WC is generated, as Doug asked, we
changed the flag name to reflect that. I guess that the units for
frequency are MHz but I will check that and we can document it in the
kernel IB core patch and later in man pages.

>  - Should an app even be exposed to mask? This is very difficult
>    to use correctly in the general case. Only cases where an app is
>    restarted more often than a wrap period are trivial to use properly.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
