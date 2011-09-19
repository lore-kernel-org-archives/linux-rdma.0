From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 1/4] ib/core: handle EDR/FDR extended speeds
Date: Mon, 19 Sep 2011 21:32:51 +0300
Message-ID: <CAJZOPZ+XkR7Fy0OstrQRb4VU_dr_uKyyiw033Zdwabe9y3XO-g@mail.gmail.com>
References: <201109191906.05360.marcela@dev.mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A8237316E64FDC@ORSMSX101.amr.corp.intel.com>
	<CAKzyTszd0LSOaY4RFCw2WpNBBQcgfkUYFSOy6q+rC1SjSb4q3A@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E6508C@ORSMSX101.amr.corp.intel.com>
	<CAKzyTsxxuB=k+N+rxPmfx8zZZApDdr-_FfajDstDVa7M1nV8xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKzyTsxxuB=k+N+rxPmfx8zZZApDdr-_FfajDstDVa7M1nV8xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> That's was an issue with the wire protocol format, correct?

> Right.

>> Why carry that same concept into a software interface? =A0It seems c=
omplex.

> So as not to break existing verbs apps by inventing new values to
> existing fields which wouldn't be understood.

Hal, Marcel, I tend to agree with the direction Sean is suggesting,
sure, we need to see that existing utilities aren't broken with the
new values we would be adding to new fields, but that should be
doable, the fact that the wire structure didn't had room to extend
(...) on this or that field doesn'r mandate the same limitations for
IB stack non-wire structures.
BTW the complexity typically introduced by changing structures that
cross user/kernel boundaries is typically higher, so it would be
preferring to avoid that, and following the Sean's direction we can
avoid that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
