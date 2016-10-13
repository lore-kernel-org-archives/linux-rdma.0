From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: switch iwpm to ccan list.h
Date: Thu, 13 Oct 2016 11:56:59 +0300
Message-ID: <20161013085659.GX9282@leon.nu>
References: <1476092514-18188-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KISHs/FnjYvFOG5B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476092514-18188-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KISHs/FnjYvFOG5B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 10, 2016 at 11:41:51AM +0200, Christoph Hellwig wrote:
> I've started running sparse on the rdma-core code, and one of the
> worst offenders is the iwpmd list code, so this (untested) patch
> set converts it over to the ccan list.h helpers.  Reviews and
> testing appreciated.

Thanks, applied.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--KISHs/FnjYvFOG5B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/0xbAAoJEORje4g2clinlsoP/Aj7nspKT7ahhjoZzeK3BWEQ
mcroagozK4O17HwZlrJ8jWQltAQpk7nofYx96s53f/m+Up21AujeIo5opEr40y8S
23jwmhdnF6WV6LgicXnCwMcHE+Uu4sSqhFK3wc0tZ9i9YbHo/m3YrjpkF8V3rhXs
dh9ySjJlFktmKFnH/fSdpPm6jDLyilQkJHzjRX4Ss9Da8Q0jH3X8i1MPw5XixZ2+
qbLsKDM1gMixptTcBAo3K45U6tAKjgqde2Sq6DW7EUdoml8I6mDaj1xIpDcxybrP
JW2czxqaS+R/ZPGTNgXjXysraCq1/fKinK7gupJV5V7mHZK6AlyQ591piuG4yWjs
tja1jS4PvhLtqkhs0noQh0SN2i8ljpSKNi1T4/JDfuYTIWY5TWqNlqbFxWqsFHFQ
BCR/UgWB+lHplsxzX3/DrzCv8vI9rewc6y9k5aAIci5reS2QYLdnfHtMO1DN5tXl
iLTePfVmemX3AaPo7jABcK2ZXeLh6bbrbnDkZ3lT6xN9DpOYc3AQdWvPfe+cswep
WzFdTk0cY/g6GfUg8RGQkzzKvdVRUeZsH3NM+yp2R0mDy3hlyn1IkZnaXU3BaZwI
FtlEwwpMbO8Rmh8eDyhfKsXYU1yTKWYRGq3H/jegBpav58j6PVrN/mp0lbesi/T7
/ts7esxUurECRsRb8hPr
=UvIe
-----END PGP SIGNATURE-----

--KISHs/FnjYvFOG5B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
