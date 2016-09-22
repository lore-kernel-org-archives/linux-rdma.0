From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 17/23] umad: Replace .nl with .sp in man pages
Date: Thu, 22 Sep 2016 17:33:34 +0300
Message-ID: <20160922143334.GH4088@leon.nu>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474495729-17604-18-git-send-email-jgunthorpe@obsidianresearch.com>
 <0225b26e-0b88-0116-9c23-0b1e6bcd8e50@dev.mellanox.co.il>
 <20160922132544.GE4088@leon.nu>
 <eccf516a-b193-5f35-4b78-02c6c7b2161c@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Bg2esWel0ueIH/G/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <eccf516a-b193-5f35-4b78-02c6c7b2161c-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Bg2esWel0ueIH/G/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 22, 2016 at 09:50:55AM -0400, Hal Rosenstock wrote:
> On 9/22/2016 9:25 AM, Leon Romanovsky wrote:
> > On Thu, Sep 22, 2016 at 08:27:06AM -0400, Hal Rosenstock wrote:
> >> On 9/21/2016 6:08 PM, Jason Gunthorpe wrote:
> >>> Debian's Lintian remarks:
> >>>
> >>> W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_get_ca.3.gz 11: warning: macro `nl' not defined
> >>> W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_get_port.3.gz 11: warning: macro `nl' not defined
> >>> W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_init.3.gz 11: warning: macro `nl' not defined
> >>>
> >>> We use .sp in other the man pages to separate function signatures, follow
> >>> that practice consistently.
> >>>
> >>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >>
> >> Thanks. Applied.
> >
> > Hal,
> > We started to move everything to https://github.com/linux-rdma/rdma-core
> > and it will be applied there.
>
> I'm tracking changes in current repo until things have fully switched
> over. I thought that was what was said to do. Previous changes that
> Jason pushed were also integrated there. So yes, there's some
> duplication of effort until the old repos can safely be abandoned.

OK,
Now, I know that this move effort was not missed :)

>
> -- Hal

--Bg2esWel0ueIH/G/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4+u+AAoJEORje4g2clin/3EP/RhAx0jjVoTTCD8lR9+XTDPr
KxZmWFHW2Vs8jrH2+cJLeSmGiAMXQpO8VawZAa3a6ZRMANIE0/1GpeyvaUKLzIj9
FdDByVtpFqHESx45NOmFSANsFMZhKhjoUPYrNryp5dj1yr0VZt/Lvkrt4y6mHNqT
383tDzDc4XwBo2egHaJ4O9CeXYClaMViE8qSZ77QPg5Ku8+MfNLBHbZEuo8HygsC
VMiRpKTk/W7uTVX0onwnZrJIPYZEeC47hb86zTTjyA+tDLud/4ZNpHAOLvKdDKg5
QxMeldT8aKoaQDcwIkMtmMu1QQDrA9BQ1jWK1I7cy75IJAdj/EhWaKOo/gOjRMSe
oJIKD0s3MFA7GB8tXHL5qTowPBt/bx8LxkBG9DY5Z7d1mUBo8n3YP4/BuoxvLFzU
XfRSTlSYDRgFo71b2bWykG63Y3Gg2Je8mauFbyyyVAVuELIAX4Jb3DUmDln8x4yt
quxxhmjIJJtU33b8WZ+SzR/T+iGNzvXuMH4IpGkQiBjw7zrO6eJlPicZyFKkVC3H
wb8yQeDD32PLF351KLqoO3EgJgBTJIshCjAInsLyjnFQorB8EMyKdv02ZIqDMZUc
f2V8Cw4tZiKgrPyMl4rNtN5UwQN55kJzhvkdrYzGUrw+vCXR06FsEFRf0PuypgQU
TySqCqBRxBBoEbsCBpIx
=nHel
-----END PGP SIGNATURE-----

--Bg2esWel0ueIH/G/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
