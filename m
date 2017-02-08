From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Wed, 8 Feb 2017 10:09:53 +0200
Message-ID: <20170208080953.GB6005@mtr-leonro.local>
References: <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
 <20170207172752.GA12315@obsidianresearch.com>
 <20170207180642.GQ6005@mtr-leonro.local>
 <20170207181814.GA13368@obsidianresearch.com>
 <20170207183538.GT6005@mtr-leonro.local>
 <20170207184206.GA14102@obsidianresearch.com>
 <20170207194759.GU6005@mtr-leonro.local>
 <20170207201428.GV6005@mtr-leonro.local>
 <20170207205930.GA28922@obsidianresearch.com>
 <20170208063758.GZ6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Jh+yMQSFjqxAHR/M"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208063758.GZ6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Jh+yMQSFjqxAHR/M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 08:37:58AM +0200, Leon Romanovsky wrote:
> On Tue, Feb 07, 2017 at 01:59:30PM -0700, Jason Gunthorpe wrote:
> > Ah realpath needs the paths to exist.. Sigha
> >
> > Another alternative is this:
> >
> > python -c "import os; print(os.path.relpath('/usr/lib64/libmlx4.so','/usr/lib64/libibverbs'));"
>
> It prints to the screen, but doesn't update OUTPUT_VARAIBLE :(
> 115  execute_process(COMMAND python -c "import os; print(os.path.relpath('/usr/lib64/libmlx5.so','/usr/lib64/libibverbs'));"
> 116                 OUTPUT_VARIBALE LINK_PATH)
> 117   message(STATUS "link_path = ${LINK_PATH}")
>
> ..
> -- Performing Test HAVE_C_WREDUNDANT_DECLS - Failed
> ../libmlx5.so
> -- link_path =
> -- Missing Optional Items:

Awesome,
It was misspelled "OUTPUT_VARIBALE" instead of "OUTPUT_VARIABLE"
together with beautiful world of cmake.
https://cmake.org/Wiki/CMake_FAQ#How_can_I_get_quoting_and_escapes_to_work_properly.3F

At the end, I put it into standalone python script to overcome it.

Thanks

--Jh+yMQSFjqxAHR/M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlia0lAACgkQ5GN7iDZy
WKeBRQ/5ASt6/PDKj9FcnyyzhfvWyf6coX0yI7jW3ciSsKZsTB6a8DYeOZovukhh
zR2r0ZVLmziqaCkxHt25xSjeEPCQCP9RT+0Jqkkm6w2tCeAWZgU3DlQoDMUma9n2
eQFEAYeBd1bqhiDnw0vIll/TSTpqHyffYn4C2WP8YI/8PMMiX2PH7757NaK0Soks
21yZv4ARG6Mh/bu1OJQdLIGHuRopigkqGCZb9UjsaxK0V7reU/jAhEvb3r7w3/99
t7WUp8vI9y5c8wONAOlpLjY90GwGj27PvjVD6UvgWLFX+u09lHPIPgZGUrpyCiXO
hFRGh0b6pbfPu5qMgZJs/Hhqd9ooAbge6//UQlS/w3QgdsMsaGnmo3KZ/3WaCeay
DiH7U2lIR9MBoTPhnVlsR5TvMeGLft97On2szxY42M+aeeEW/hHKEOxQUBrf4Dz4
XsEsFrGULR2V3nMZfQHYWDjsVuniddo9Bj+9qpLkkQUoLzvzWfDtOUa01wOq6rfB
cAvAdLC7/vstzaBFTqmsotgRHTt1Lw4zl6dVOdr5r7g9w3TyLOcDPNtUfMYmHEGb
YcreBbwGVAhVwipAzA3qtqdYyCh6VCRjUUXe+xywUynUrZAHRhyRTuK6VYjp1kJq
bxARwEdGwW7YqAoLunzi9K0YQ47PdYcpqlBSazkQsdgnmqDc6MY=
=3wsY
-----END PGP SIGNATURE-----

--Jh+yMQSFjqxAHR/M--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
