From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Is ib_mtu iboe_get_mtu() slightly off?
Date: Tue, 10 Oct 2017 18:33:12 +0300
Message-ID: <20171010153312.GD2106@mtr-leonro.local>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
 <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1507556073.46071.27.camel@redhat.com>
 <20171009134131.GB1252@mtr-leonro.local>
 <1507565652.46071.33.camel@redhat.com>
 <VI1PR0502MB3008900E038DEF6EEAB719DFD1740@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <c27ee8b9-a011-9b0b-b20a-433d9f74d4b1@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c27ee8b9-a011-9b0b-b20a-433d9f74d4b1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2017 at 10:48:01AM -0400, Doug Ledford wrote:
> On 10/9/2017 4:47 PM, Parav Pandit wrote:
>
> > Sorry for not ACKing that I was doing it last week.
> > If possible, please pick the one that Leon is sending because
> > instead of doing calculation in half comment based and half defined based code,
> > my patch defines all necessary header sizes in calculation, little clean way.
>
> In this instance we are lucky that 0day testing was being slow yesterday
> or else this would already be pushed to k.o.  Since it's not, I can drop
> my patch and take yours.

Did you post your patch for review and gave enough time to participants
to provide the feedback, before pushing it to your k.o.?

Thanks

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnc6DgACgkQ5GN7iDZy
WKdT/BAAlaVEp7bWnPqDOWi3s5RRNnJ9Trn38niFB5it1zw6tY+SJqCmBQ3wK3vr
5Jg4Pa5RWYOek1uQ372VqkLA59I3tIFjXniV4U3cuzdWHqMGt1DVy2NWBw6HNDh2
LR/kCzC8U1i+n1Ys9TooMFO2e8E2X8uUdZzHr934OKxWTe9NEJiHZat+TwJAzzBf
z3eBo37Zx0DndzoScoWgwAOLa0s9u+Xto/hGlYSOsWXsmKSocD45nuUVRt7olJAR
/NdAtkPXD9pYg4tMSIhbJ9LxYxSQsDKL1qd6ZQcR9MU8pPSdaFsGw1ZmPjhQMW8p
cyItV+fy1qtAwamWTpgbDuK5imphe40CNXBNKyBxHkn6LNSo9s9q16KgBpd2Z3OO
o1my/OXXI2sG3U5oMGmpLpJcyUkn8tLbVGesnArvUzyxYzctrqoaujT+eHx2KgaV
Zy0q+3NAePJpWBEuyyzvk+fiX/Z+t6j3wS4NbmnUCzoOVDop4sZS8IrrNWr7UsSY
MjtBYqKDkatpVE76IYm6o3dtwn8wZZswB9Aej0oVUUWW+2RG/oN1MzPojXWcFQhL
KQgqibahfrZDpZdKsRukVrTOCA6W4ofTPTApFG6tNlXKPdTUuJZ34JIEfexHngWb
4OCR3otLuUfTH4uGR/pzriEUBHnd9+B+7OcfZmNqwkin05HK3EI=
=2PqN
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
