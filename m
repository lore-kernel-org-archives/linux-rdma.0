From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 9/9] IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX
Date: Wed, 18 Sep 2013 07:31:14 +0300
Message-ID: <CAJZOPZLoD0+wMsrAO1aCPq04sGQNXSWKEB5E927ebArP7xS2yQ@mail.gmail.com>
References: <CAJZOPZJ_F06xORoQyt-6_SK5P5Y7LXekQuNKHHYSt+oJ8sV1GA@mail.gmail.com>
	<CAG4TOxOtsy+vtmtYciREk0bOC=o9-ME1T=cqvt46CNssCU57zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxOtsy+vtmtYciREk0bOC=o9-ME1T=cqvt46CNssCU57zA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 18, 2013 at 2:10 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Sep 17, 2013 at 1:49 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> To begin with, we don't break the whole stack -- using the current
>> patch set, for ports whose link is IB, all biz as usual, and this is
>> the in the port resolution, that is if for a given device one port is
>> IB and one port Eth, existing librdmacm keep working on the IB por.
>
> Sure, and people using USB webcams and wifi are also unaffected by
> changes to the RoCE stack.   For anyone using RoCE the impact is pretty big.

I see your point and this is why I haven't stopped after the "to begin
with" paragraph... any comment on what I wrote following that?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
