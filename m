From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [patch] RDMA/nes: silence compiler warning
Date: Tue, 18 Oct 2011 11:32:21 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904F02360A8@azsmsx506.amr.corp.intel.com>
References: <20111017072857.GB7812@elgon.mountain>
 <CAL1RGDVe7OKL35G9hdzYNWGZkC+g_HXXXrkRgw2ueTk__vMNPg@mail.gmail.com>
 <2EFBCAEF10980645BBCFB605689E08E904EC56F5E0@azsmsx506.amr.corp.intel.com>
 <CAL1RGDX5EGxqatX-RFLKqZcJ+pYDHhie3G04rD=BedA9uBvA6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDX5EGxqatX-RFLKqZcJ+pYDHhie3G04rD=BedA9uBvA6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Behalf
> Of Roland Dreier
> Sent: Tuesday, October 18, 2011 12:11 PM
> To: Latif, Faisal
> Cc: Dan Carpenter; Hefty, Sean; Hal Rosenstock; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [patch] RDMA/nes: silence compiler warning
> 
> On Mon, Oct 17, 2011 at 11:28 AM, Latif, Faisal
> <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > Yes, We should have used %pI4 for this also.
> 
> Any chance of you guys going through and converting IP printing to
> %pI4 in the whole driver?
> 
>  - R.

I will get patch out to you to convert the IP printing. Thanks for pointing it out.


Faisal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
