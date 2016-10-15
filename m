From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5 for rdma-core] Five rxe_cfg patches
Date: Sat, 15 Oct 2016 12:38:43 +0300
Message-ID: <20161015093843.GK9282@leon.nu>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/cYA8VCGycg41AiS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/cYA8VCGycg41AiS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 07, 2016 at 11:37:43AM -0700, Bart Van Assche wrote:
> Hello Doug, Jason and Moni,
>
> These five patches is what I came up with after having had a look at the
> rxe_cfg source code. It would be appreciated if these patches would be
> considered for inclusion in the rdma-core repository. The filenames of these
> patches are:
>
> 0001-rxe_cfg-Use-Perl-functions-instead-of-parsing-the-ou.patch
> 0002-rxe_cfg-Initialize-rxe_mtu-even-if-ibv_definfo-fails.patch
> 0003-rxe_cfg-Do-not-suppress-stderr.patch
> 0004-rxe_cfg-Remove-dead-code-from-show_module_status.patch
> 0005-rxe_cfg-Use-printf-instead-of-using-a-loop.patch
>
> Thanks,

Thanks, applied
https://github.com/linux-rdma/rdma-core/pull/20

>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--/cYA8VCGycg41AiS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYAfkjAAoJEORje4g2clinx/MP/0ASyf+yuE7KYC63x/h0qRVC
50fKxJWytQBrZVlhILhInSuaxWzhsdehz17kmyHQLcCum55FyFbeqy/zwj9Njms+
d9a/9iruNb8g1Dye7jGKt2LVbe4FRiXNecMYcNfWttzS7y14fZUMH7hVGIdb4vSv
tiDWRxDaKOT6zREYAcYvbHCQku3PKlxASUQysG+0XemE1CVdnppKTtfb6rvANkZO
yRiieEOU7KQg9WxmdVVXl+/yM9W6gPtDVz+sYR+r+AGSHsDSiAR6t3IJVoAmik+Z
4kAUlDMPxDF8kPDM0hPqFRGA8dmd4DLnbl456RZ+aMP48LvysNHndp2vEXcTe0lK
c69Vziw2sfZdts2WxHkQ83WQ0oGb2R0yugu+WJStk6wuiYn8zhvr7LJwDH/wCUsg
wSIo/JZZr5+9uq8DmikyYJcpobSPZktWCAbWANp8taAbFur71JPczc2synLsBE8F
wKPYCd2MS4CTYrZ3PYuV34tWWfi0b+UH45LUjvaWAq5MTSJVfOtABUNcyPgdGOde
GhI4lp7awEstGJUFA5iNojqqkjfOzq5OlzRbM2W0QMHOXmehimmlXVIb3o3Du5f7
9iTZwMqjVtyioKM5l6kMPxmNQy2Avc9vAtbpJP/arANjMQdnbUjZGotUJty5YmDd
NnJg32FaZyxMWv0chkpf
=tik5
-----END PGP SIGNATURE-----

--/cYA8VCGycg41AiS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
