From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 4/6] RDMA/core: Move HFI1 IOCTL declarations
 to common file
Date: Mon, 5 Sep 2016 08:31:14 +0300
Message-ID: <20160905053113.GV21847@leon.nu>
References: <1472988635-31463-1-git-send-email-leon@kernel.org>
 <1472988635-31463-5-git-send-email-leon@kernel.org>
 <20160905024158.GE21542@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p11K2BJEgMZL61bg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160905024158.GE21542-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--p11K2BJEgMZL61bg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 04, 2016 at 08:41:58PM -0600, Jason Gunthorpe wrote:
> On Sun, Sep 04, 2016 at 02:30:33PM +0300, Leon Romanovsky wrote:
>
> > +/* User commands. */
> > +#define HFI1_CMD_ASSIGN_CTXT     1	/* allocate HFI and context */
>
> > +#define HFI1_IOCTL_ASSIGN_CTXT \
> > +	_IOWR(IB_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
>
> I still vote for dropping the HFI1_CMD_ASSIGN_CTXT defines. Inlining
> the number is far more readable than that ugly __NUM macro.
>
> If it was done consistently you might have an arugment, but just doing
> it in one place with no purpose is silly.

It is done in patch 6. It is here to preserve one-change->one-patch
flow.

>
> Jason

--p11K2BJEgMZL61bg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXzQMhAAoJEORje4g2clinutQP/2wr5j9Cn4d4/GYHjCdq+H0N
wlfPLQQLU/E7+B2zGm4GOvE9DDz4VtjC2Z1C78nsIGoaEcj715b9L2E7VwliepiJ
rDvkeQENsh8u22xUj4Dua95XaQCJa0fzIIdMiRxQlfzXEVXFfEQ7nt1VceVh+rdN
9wvkUgu0WoajGGXxrYgaaSbnVGhicABoalNnNL3GKU9SOztJECvYq3jqs8oUbn53
pdJOlAsyC27OsGu80TPHPVZEtjmL9aw5sLhbT0ekkU6BvtdAZsiC7dv5Romuy8lv
IofFUM8KfL/VAl7nJDpdsZb9s/Z8gUpQc3Rb8crKe5wu60iC6QHyXoCw18oyTu3l
gw0VOsvIePFgTRn8VXYT7mhX15bsTFbxfphuiLWxjZpbaLrgxaFkib2NFhXzBhLM
ipJZi601TqclKbgxM/NmoTXjmC0C76uem2WydDy+8dUqX5Mnzo1GtpQjFuMSzvDf
UmecsfIZDs8RiJUvbbe+uzHvuNG/t2yWCpeaj5AZb3e10sdQYT98WizEh4KbdMYm
XhDcyrOLjauh7bPV6Ki2Egeo/fYaAoJOTGJqLPH8v4AG46hUqXaa/nySVXC+awFK
4/nIODY8MXoQnutPmkkZG8w0LFDIw8XGhhCfOizW91fZdGZOJf3zRbOFGGLmZ5am
+21kXdy1GVILi3UYc29x
=9iG/
-----END PGP SIGNATURE-----

--p11K2BJEgMZL61bg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
