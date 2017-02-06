From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Mon, 6 Feb 2017 13:46:09 +0200
Message-ID: <20170206114609.GK6005@mtr-leonro.local>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <SN1PR07MB22070381E7566FA819E5F8F8F8400@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zkS4nBu7xsy2hAaK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22070381E7566FA819E5F8F8F8400-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--zkS4nBu7xsy2hAaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 06, 2017 at 10:56:56AM +0000, Amrani, Ram wrote:
> > This patchset from Leon adds direct access to mlx5 devices.
> >
> > The libibverbs API is an abstract API. It is agnostic to any underlying
> > provider specific implementation. While this abstraction has the advantage of
> > user applications portability it has a performance penalty. For some
> > applications optimizing performance is more important than portability.
> >
> > The mlx5 direct verbs API introduced in this patchset is intended for such
> > applications. It exposes mlx5 specific low level data path
> > (send/receive/completion) operations, allowing the application to bypass the
> > libibverbs data path API.
> >
> > The proposed interface consists from small number of hardware specific headers
> > with relevant inline functions and conversion logic from ibverbs structures to
> > mlx5 related structures.
> >
>
> Hi Yishay,
> While I'm always for better performance, I'm not sure driver specific APIs is the way.
> This will hurt portability for users.

Hi Ram,

As it was expressed in cover letter, this feature is intended for users
who want performance and understand the disadvantages of such direct
approach.

Thanks

>
> Thanks,
> Ram
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--zkS4nBu7xsy2hAaK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliYYgAACgkQ5GN7iDZy
WKc1sBAAjxksfc17GHE32FjtZQ5OXK7DMnKwpTtOB97g8GtfQwHQALdafcEFX1qr
sOUEU+G43QwNvktDwL0yhHuu8s/d4aERCRtXD1Nit9caq8GGzwfjKsHFc166OSXY
/ic9TEBIasoNLbNByumNUPjR4Syb1L2Qkdsq95avRrNVOIF58z4i1yJc5nJlDwLK
QC4fhB3pWQET9Vgcg/s7xUgIHuSDi529asHLa4sCoGB8MeqBedmcmHlj/2h/bZDK
FG5+LxKiRjP7piNTme240RDAGuoLBFz2gotGFj6qAePEa6kk6YakOmg6pOkRw+j1
eNm4DQKOOUTMJTVZx6CNRVjsEhvahPpiL+M0KED32ktF3Er9oqWgPdD72RLQ0CDj
UYgwnl3dnfDs4OJiAw1n/oXLDwQkTwKOBqHsztvHiG1CTxe5nzlNXuAmHOLWQULM
Y6Mfv/Q4UBARTtpCmbhRh1QEsfKem2BjI8qwDH554+C1oxGEZG53/3x2qih50z4j
jaqtFspoLHGs1GCuGE6HJig1PuICNqS+MEb1xyrDMCWgPAZhUXbYE4OEXLRHFo36
qLAIv8I/5UEkwOxkj2LAdpN+7cOiExekDF07Lg7pQjW4xLrtt/K6k5KELYeYyIUh
/C21vDPloDCRmA68yvrr0rohP51hHWxyE9JFI5vQZyuSbbjpggs=
=NcIO
-----END PGP SIGNATURE-----

--zkS4nBu7xsy2hAaK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
