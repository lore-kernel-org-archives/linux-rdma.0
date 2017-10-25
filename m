From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/uverbs: Allow CQ moderation with modify
 CQ
Date: Wed, 25 Oct 2017 21:50:34 +0300
Message-ID: <20171025185034.GV16127@mtr-leonro.local>
References: <20171019053524.11135-1-leon@kernel.org>
 <20171019053524.11135-2-leon@kernel.org>
 <1508956084.3325.50.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MOeiELSuYwpLEKvX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508956084.3325.50.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--MOeiELSuYwpLEKvX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 25, 2017 at 02:28:04PM -0400, Doug Ledford wrote:
> On Thu, 2017-10-19 at 08:35 +0300, Leon Romanovsky wrote:
> > From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Uverbs support in modify_cq for CQ moderation only.
> > Gives ability to change cq_max_count and cq_period.
> > CQ moderation enhance performance by moderating the number
> > of cookies
>      ^ Please use non-slang in your commit messages.  People not
> familiar with RDMA will not know what cookies means.

I'll do my best.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--MOeiELSuYwpLEKvX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnw3PoACgkQ5GN7iDZy
WKe52w//YbTAz9DE9os//el01mlX1dJ6OUQIINEjFetJMiD+1xSlVTv9d26pf003
Ywk84FR9YIOKAuJvyWjnFvwtgIjEsldV8cnc3zy2WcD+7E+p8W97Q522f8RbNAOJ
fgA/G7dRIJis61pd4azNnJYrusKbdbvP43YAwKt/D5UtPZxEO0cUNfEeFA1xsxUB
41ysJlIwTBuypMhSyLns7oNSUO8YDFeYcWqGnoco1PZB/707MAl7Bcp+r1IYVLMS
BauaZAYLk13LYZ+uaOKz9nieW1EiMnn/ZkRWwfncINW6Baa2cNQjhcE8gi0hWZJH
xpQaiofgublM/O71bXzGGMWOdDJYEtm+6c1o/iPR/i/GvxUIPWUtUKC6UuEucje5
Xa8hDaL/sVJi45Eo0xpmhSmITxhYafCKYcv2GGatISe+B+POdDqENBaIujWnXU8L
Vw7hZDgFRJL3ZChRvsDPBaDwbdEiPxHruy8y+yD34o2DH4XhB4yoxn4MzgEhduCX
EZYLSMQSx7SI9MrYvF/+yMj8wF+iV+xzItCt0erWvlWAiyOtUtjoIpSYK/U3BH+U
ksWHJSopaMYgjNNIhgYmpw+FjsTvUWkNnJOHlo6DbvdTbT0C2sqOxSI2ZKAX9hLv
bf5SMOId/cNLi9QaYPqtfpRhbnHdJ+juigSr+oDNi1bQKadKe84=
=+U0K
-----END PGP SIGNATURE-----

--MOeiELSuYwpLEKvX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
