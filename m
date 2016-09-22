From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 17/23] umad: Replace .nl with .sp in man pages
Date: Thu, 22 Sep 2016 16:25:44 +0300
Message-ID: <20160922132544.GE4088@leon.nu>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474495729-17604-18-git-send-email-jgunthorpe@obsidianresearch.com>
 <0225b26e-0b88-0116-9c23-0b1e6bcd8e50@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0225b26e-0b88-0116-9c23-0b1e6bcd8e50-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bi5JUZtvcfApsciF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 22, 2016 at 08:27:06AM -0400, Hal Rosenstock wrote:
> On 9/21/2016 6:08 PM, Jason Gunthorpe wrote:
> > Debian's Lintian remarks:
> >
> > W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_get_ca.3.gz 11: warning: macro `nl' not defined
> > W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_get_port.3.gz 11: warning: macro `nl' not defined
> > W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_init.3.gz 11: warning: macro `nl' not defined
> >
> > We use .sp in other the man pages to separate function signatures, follow
> > that practice consistently.
> >
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>
> Thanks. Applied.

Hal,
We started to move everything to https://github.com/linux-rdma/rdma-core
and it will be applied there.

>
> -- Hal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX49vXAAoJEORje4g2clindHAQAK6w1gteCv7ySvTJHjM6blB/
nGMCAncKB+fGtV5v7RA07+2XwxMkA0xcCFj26Y5J9wW5SQa6D+n6zcz/NEzVtntf
ll/OQITP6expFKRjhHmS6ORMHMgzLzV8Jer9tw8r5voaNRdPZx7i3OCOpNxj4SSX
bgF+KL9NRbK3QsYkWug0f8JmHUW/kag5jiCaDoHv+SEost99sMmUYphNxcNeC2MY
kwvBJX+OpLzYh4Pb+kLqOIFVF2j2kRC9w+q5jxHNyzGyF0HbHvJnMn9tS0B1oqSv
JMpBUlbTK3NKoFRJ+HrzLpRMUrqH7I/3B72yhrjcI5AnUUPmWJpcuyolU6ou8KhX
a1As5dhnnSRZYTOmEF9jqjyKlMGywJyzSHHA6pjerl60pwXm1qcwEKjllaNyxxQx
pMFsBdVxfVB8oV5dRcmSEM8qePk6LN7auPH1PtGvag5CuX1IjrhAbAwuzeXEHZXu
iimNWTa8vV9AmOQq42nucq1cGHE7d08SvvgqIjbgiwaa3YSNq/LJaakPYsZYzfa+
AYmPevX3VEDQMz8ClNBOw5AiI9AENW7dgdqjDGF8tgKoCnd3+BAU67c12Hmd9d86
Le98raP44PdizcdwUeprBLadgHR30tyQnpOnLSa7BWCbXIkwGu4x+Q9p+yxtC9v5
ph3o/3C30xEa8kRWDSKG
=UWYI
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
