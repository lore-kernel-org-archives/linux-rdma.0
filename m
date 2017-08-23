From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 09/16] IB/hfi1: Clean up pin_vector_pages()
 function
Date: Wed, 23 Aug 2017 07:49:00 +0300
Message-ID: <20170823044900.GK1724@mtr-leonro.local>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
 <20170822012702.32701.90032.stgit@scvm10.sc.intel.com>
 <20170822154659.GE1724@mtr-leonro.local>
 <599C7A74.9010301@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d5ZB48mKYG2jsBgL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <599C7A74.9010301-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--d5ZB48mKYG2jsBgL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2017 at 11:39:48AM -0700, Harish Chegondi wrote:
>
>
> On 08/22/2017 08:46 AM, Leon Romanovsky wrote:
> > On Mon, Aug 21, 2017 at 06:27:03PM -0700, Dennis Dalessandro wrote:
> >> From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>
> >> Clean up pin_vector_pages() function by moving page pinning related code
> >> to a separate function since it really stands on its own.
> >>
> >> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> ---
> >>  drivers/infiniband/hw/hfi1/user_sdma.c |   79 ++++++++++++++++++--------------
> >>  1 files changed, 45 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
> >> index d5a2572..6f26253 100644
> >> --- a/drivers/infiniband/hw/hfi1/user_sdma.c
> >> +++ b/drivers/infiniband/hw/hfi1/user_sdma.c
> >> @@ -1124,11 +1124,53 @@ static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
> >>  	return evict_data.cleared;
> >>  }
> >>
> >> +static int pin_sdma_pages(struct user_sdma_request *req,
> >> +			  struct user_sdma_iovec *iovec,
> >> +			  struct sdma_mmu_node *node,
> >> +			  int npages)
> >> +{
> >> +	int pinned, cleared;
> >> +	struct page **pages;
> >> +	struct hfi1_user_sdma_pkt_q *pq = req->pq;
> >> +
> >> +	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
> >> +	if (!pages) {
> >> +		SDMA_DBG(req, "Failed page array alloc");
> >
> > Please don't add prints after k[c|m|z]alloc failures, despite the fact
> > that it was before.
> >
> > Thanks
>
> SDMA_DBG MACRO is a trace for development debugging. It's not a print.
>

No problem, I'll rephrase it for you.

Please don't add prints, tracepoints, debug output and SDMA_DBG after k[c|m|z]alloc failures,
despite the fact that it was before.

Tracepoints output will be less worry for you if your kcalloc starts to fail.

Is it clear enough now?
>
Thanks,

--d5ZB48mKYG2jsBgL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdCTwACgkQ5GN7iDZy
WKefehAAvMd7zy3q0ig3274FclHQjm65CZdgAk/htDo3Zkf4150Uek2jLKHL+e+G
xvnd8fmRvqGWfI/gf6iSkDFhNiRwtv3poThd2jBiVn2BBKK9KSZPWUaj0vsmTIKv
kPN12MPY6ps9j9ZF0+TzNDU57FTe0sbiKSBn+5n67s5O5uk9jP9sYqzwMkshMzOD
NG/TttzMgvS0caZsHRVvvGUUj/R56k6U6cCGWhwA2QeIiqQr7K9/6aQfATYfgbT7
DuzJ6hMKXZXb9aXOyXup0s7RpFg5h2yBLmwgDwpju0eUjqAD1Hrl5dnudDkb0Rpv
psFDYkcU6zikwmZrVYI2EMD25CJjGUznseVddGuO2kDKt9QJdQe7DqB4fmKgjhS5
ic/QErYJBGI6kHp4aw72e0U//qnEqQHsDGn7UfMhQ7jV3c4DHFNvAgkio6H2tcF4
PjNrj0RyzT32yYXl5553OM0IqEUjPskWGsGuZ61fW4fqAk12FR5Jo8IjEflx7ELl
oGJ2OmxQG+qPj1qYkOIchLP/14BC7hNWLbwsCvIrJiDSsx3rCaUn6GptFpMgIJJl
Ldvm0WjQ1wU2FYTQOzlCHVvC99FxpDnSQoc3IykeUHWSE49VBFfIKi2zIueF+0ps
FPG3n7+NMXMx+yPZjB+asxZeikwx3WY3VCfuPysRWsyt/iwyT5A=
=7t6x
-----END PGP SIGNATURE-----

--d5ZB48mKYG2jsBgL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
