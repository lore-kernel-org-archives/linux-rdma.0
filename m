From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Versions of packages included in rdma-core
Date: Thu, 1 Dec 2016 10:18:26 +0200
Message-ID: <20161201081826.GD4497@leon.nu>
References: <20161201080430.jrcketnrljckdbix@paradies.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161201080430.jrcketnrljckdbix-TXhXIaCUHZEYitT5tn2FcQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 01, 2016 at 09:04:30AM +0100, Philipp Thomas wrote:
> In order to assess the impact of moving to rdma-core I'm trying to find out
> which individual versions were used when merging the seperate parts of
> rdma-core but up until now I haven't found any info. So I would be gratefull
> for any help.

Hi Philipp,

We imported everything published in their respective git repositories.
Did you try to use git log --follow relevant_file?

Thanks

>
> cu
> Philipp
>
> PS: PLease keep me in CC as I'm not yet subscribed to the list.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYP9zSAAoJEORje4g2clinvLkP/1UME2L3f9wusxKO5uGFHrx8
t6qBt3xWPy5KeGoKv2AgviJMYTTjGIOlMN46tJ+5BCRQks+xUCDcUsxOvrJsTmVT
rx+ag7dAiCuVlt9l9yNHM0IgFLbwWSLWMO1ynZBY04pRCsd3m9T78kxNhCzSel/b
rFIIEYf4M2EV1YRsJ4o61E3AnkEHHWcl2uJrhkKJF0wwwtPYz7CVbHSPMv/721J6
+LJsf6TGqrtYoamjxDRxlLsHA2fdz/JsH+bXWFzkejvXHwxGBCEFmGTw6S3oNofk
HHV3LBhe49yA0sUPqgvk7CkOcrltzq7DxtuXdMSeVnATfv53mNQfBtf2842kpC88
oHFblM4s3I4ztoW84RHhyS42A096xstUiSPv4wKWuRULi/2BnMBOY+2on7WDw2Hm
3vnD8wjaBRa5ohQJcun2KCnd2yLYqrRAudjXWnSrUrPnD5ilhFkn0rXREaGTw3Qr
LWDp2xd6BXR7bIprYCWIC1mxIx52m7BKvJPo6V+YmNyAAn9v7tzTTQS3/pSjGFwH
Zt+mlZdB1bFMq4l92kK+q4M9miohhRtXJ33XVqUGHChhT6o+RdMPxdX/0MgUwHUc
9k38LP6Px+pfz9OEuA0cMswpWCo73Gqy4WIIRaTGQosvbEZqz7T1xTrrCYa9b+r4
UfJWXjubcgg3tQonfvol
=wZz8
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
