From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
Date: Mon, 10 Oct 2016 10:24:07 +0300
Message-ID: <20161010072407.GJ9282@leon.nu>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-5-git-send-email-Ram.Amrani@cavium.com>
 <20161006133357.GP9282@leon.nu>
 <SN1PR07MB22070099EE40A67B81D14C75F8DB0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MRqhvNSJsMAynmoC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22070099EE40A67B81D14C75F8DB0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--MRqhvNSJsMAynmoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 10, 2016 at 06:34:43AM +0000, Amrani, Ram wrote:
> > > +/* * CQE requester status enumeration */ enum
> > > +rdma_cqe_requester_status_enum {
> > > +	RDMA_CQE_REQ_STS_OK,
> > > +	RDMA_CQE_REQ_STS_BAD_RESPONSE_ERR,
> > > +	RDMA_CQE_REQ_STS_LOCAL_LENGTH_ERR,
> > > +	RDMA_CQE_REQ_STS_LOCAL_QP_OPERATION_ERR,
> > > +	RDMA_CQE_REQ_STS_LOCAL_PROTECTION_ERR,
> > > +	RDMA_CQE_REQ_STS_MEMORY_MGT_OPERATION_ERR,
> > > +	RDMA_CQE_REQ_STS_REMOTE_INVALID_REQUEST_ERR,
> > > +	RDMA_CQE_REQ_STS_REMOTE_ACCESS_ERR,
> > > +	RDMA_CQE_REQ_STS_REMOTE_OPERATION_ERR,
> > > +	RDMA_CQE_REQ_STS_RNR_NAK_RETRY_CNT_ERR,
> > > +	RDMA_CQE_REQ_STS_TRANSPORT_RETRY_CNT_ERR,
> > > +	RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR,
> > > +	MAX_RDMA_CQE_REQUESTER_STATUS_ENUM
> >
> > Please add "," at the last line of enums, it will allow future changes to these
> > enums with minimal churn.
>
> This is a good idea and I've applied it to several enums in the patch.
> However, I think that this specific enum should left be as is since the last element should always remain last as it is a MAX_*

It makes sense,
Thanks

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--MRqhvNSJsMAynmoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+0IXAAoJEORje4g2clina/UP/1M5JnpwtSw5mBP3EYaYbMJz
y5aBMkVQbn3Xx+9w/bfhXo3KoYYMLyz+B72GeRt5tHli8dHoUuXTVst/e/2MNYE1
nqZ3Q4TL2S/ZQOWyef845Huv47OXq0Z3yMAhHzmUCTUImxL/zz+OTsnHsB2xPZj6
Y8k3X138HwtD2SkxcV9JnN0OaFOtictYfhb3VC/3X1xFuU04AFKPyfTqkdFrE3Gb
8aI1ue5unMkkUnoO1piIv+xO0fg9uGcxvCih6hBznixStALiWMhja9GBmNe0NbTJ
AIVFs55kBXpwt8gzBB0/HAPArQIezK1iriAGs1OTQs5RCYtg8WLjPxMlGsN9ieTR
/A5wpZcau2hMHT6wlNLqexyUDMVLCXlQiCPlFO8CHJyF6UL4E0MUDIteEvc2svCa
mdi2iPPkhhKCJOwmJ335cl0IWTKpMlqk95jg8jzC4h0TXQ09TH0rbivlSacAerxA
OqoAC77FOuenQxGg5SYHRVFzGdeab0uxv+SRaw5A3L85xUo08XQUe0MtbY35yHr7
G2qzkB7iJ8UlQh4cwdNrzCQM6l2Ya8jr+FpdK8wz+1fHwuALNOYZ3foWiMvY2ElP
dXc0yfRFapAjIMQ+zId+JUiX47g4R7aTpozyj6DnbLCTiLeWwAfugFkKdFFtd4qS
83lOhMokq5qlLRTnbQph
=05Al
-----END PGP SIGNATURE-----

--MRqhvNSJsMAynmoC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
