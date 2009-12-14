From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
Date: Mon, 14 Dec 2009 12:09:18 -0800
Message-ID: <1260821358.19688.296.camel@chromite.mv.qlogic.com>
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaocm1csgb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2009-12-14 at 10:37 -0800, Roland Dreier wrote:

>  - New QLogic qib driver.  Needs at least one more iteration of
>    cleanups; and I have not had time to look at the latest code in
>    detail to see exactly what cleanups are needed.  I am concerned
>    that QLogic chose to abandon the ipath driver as unmaintainable,
>    and now wants to replace it with an even bigger driver (measured
>    by lines of code) that does not support the HT device that ipath
>    supported.  How can we make sure qib has a longer future?

I understand your frustration in having to deal with a large amount
of code. If you included all the Mellanox firmware in the mlx4
driver, it would be huge too. I'm limited in what I can do given
the complexity of the IBTA spec.

QLogic is not "abandoning the ipath driver as unmaintainable".
The thought was that trying to incrementally patch in all the changes
needed to support dual ports, QDR, chip register addresses, etc.
would result in larger patches than renaming the driver. It was a
chicken-and-egg problem because until the new code was fully
written and debugged, we couldn't post it and we couldn't patch
ipath until we knew all the places that needed to be changed.

We had a pretty strong business requirement to get support for 
our QDR product into OFED 1.5 and the IB interrop tests required
we get something into OFED. The chip schedule just didn't leave time
to debug everything, get it reviewed and then merge with OFED.
Also, I was out for 5 weeks and that delayed the submission to
linux-rdma.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
