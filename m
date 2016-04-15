From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Software IB switch/router
Date: Fri, 15 Apr 2016 12:36:02 -0600
Message-ID: <CAANLjFpRitUVH=-dUdY4hav7jTXS2ih-bvQ7pK+7mYz78i3Y2A@mail.gmail.com>
References: <CAANLjFqg7mCp+-4efWjZyUNULfiR0+gJ12-V9UZiLCKD+kLPZw@mail.gmail.com>
	<20160414051038.GA10689@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414051038.GA10689-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org
Cc: "users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Thanks for the link. It looks like the routing is done by a Mellanox
device and not by a white-box device. I'm guessing the code would be
the enhancements to OpenSM to support IB routing.
-----BEGIN PGP SIGNATURE-----
Version: Mailvelope v1.3.6
Comment: https://www.mailvelope.com

wsFcBAEBCAAQBQJXETSMCRDmVDuy+mK58QAAZ7MQAMuLy6q4cYZLUKYQWHK1
UvTFUQJHsFCRZh+UN0lh05Z25OZihVAFj1dPOXS2kqyITjDntA5EvndSmGwT
Ey0xHVpnFan8s4qMEvLPtJ7fEsvamW0gh8wMAvgk42kW7c06M7bsMCESt57p
lf9t+hDD/WudOR1A+HUFmQXlqdC2GnPXCl9fKJAUmUBxZ1AzUvJNioe+QRWf
nnEyVY8Axqu9u8yJ42oxxy9bpMlFDCjRmgb9ZDiDo/aJmlcIcC+hAhA41x69
YqZQPxHsj0U8JKJ/U+KDoB/KWPSDXsouOcXe0aock3lgR4iyfUHGspgzby3F
n498AV2KTMUe2K2k8Clh+Bh6w3AsEgIqW/o3VXVaOLYxOOsNkHZXZXoEQLKX
1neJD54fVX3a62PSTjcU4UJlGtQSuW1QFt89qM/4Ko1yiaYCnRPL7qik/0Oa
sSigArOTusNe7XA8wd6cEaaUFxR0V7swIcwQC7LlcPaGhKWhUKWbR3oZsFV2
YEAOvGKFfTmFWjssj0R3dPmh/3zAOdGEq5SgFqLwul+DLoXnTKI9gvOWQADZ
1knUYPXPhBx/NMYQ5f9R4x61lrynLCbnBDie1lmASWnWpTNfVsNLCh1IoyTy
mo87poDyw4xLLfqkhM2XYskaPBRMG3a6pGpsbiltPjbv26VMchpAu0zK4Eco
Jue6
=WBYj
-----END PGP SIGNATURE-----
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Apr 13, 2016 at 11:10 PM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Wed, Apr 13, 2016 at 05:09:36PM -0600, Robert LeBlanc wrote:
>> If I wanted to do something stupid and create a white-box Infiniband
>> switch/router, is there some software that does that? Is it even
>> possible?
>
> As Kevin pointed below, Mellanox presented IB router [1] at the OFA16.
> The product is totally open-source and the code will be posted on
> linux-rdma list in the near future.
>
> [1]
> https://www.openfabrics.org/images/eventpresos/2016presentations/314IBRouterPrem.pdf
>
> Thanks.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
