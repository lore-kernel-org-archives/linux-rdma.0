From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 6/6] RDMA/core: Unify style of IOCTL commands
Date: Wed, 7 Sep 2016 10:01:09 +0300
Message-ID: <20160907070109.GC3639@leon.nu>
References: <1472988635-31463-1-git-send-email-leon@kernel.org>
 <1472988635-31463-7-git-send-email-leon@kernel.org>
 <1473166808.2465.9.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473166808.2465.9.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 06, 2016 at 01:00:12PM +0000, Dalessandro, Dennis wrote:
> On Sun, 2016-09-04 at 14:30 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > MAD and HFI1 have different naming convention, this patch
> > simplifies and unifies their defines and names.
> >
> > As part of cleanup, the HFI1 _NUM() macro and command indexes
> > were removed. It has a potential to break applications which use
> > these defines directly, while shouldn't.
>
> Please be explicit. It's not that it has potential. It *will* break
> applications which use these defines directly.

Yes, you are right.

Doug,
What do you expect from me? Respin?

Thanks

>
> -Denny
>
> N?????r??y????b?X??=C7=A7v?^?)=DE=BA{.n?+????{??=D9=9A?{ay?=1D=CA=87=DA=
=99?,j=07??f???h???z?=1E?w???=0C???j:+v???w?j?m????=07????zZ+?????=DD=A2j"?=
?!

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXz7s1AAoJEORje4g2clin+fwP/jUVPL8NiOQaW3Bf03MhFTwS
noeFGM19+RX0+5aWC2ePNwvNmpEhACwrCt6HctVcr7OK83YKElCj3iqkOhSYE6ND
hu7wDH59qlM93SNq8w1roJOPpcbgbesf1Ap7+yTDTB8tJNVzYwqARSbfJituoNFN
DRF++wgQ6nmHQWDfmU9PtOY6NVqu77ElvpjLp7UCZR/AdMdByyPvvL/nSRKFy1Ms
T45QD3k0hhMGdDOae+YydIuvgBgEgzDnv9J1Itkt86IhIwqpa9tSmq3bwE6BHTL6
UjBurLd0/fTP1/Z/eSRCaOZsId+l7X1cp4pR5O2PwJw3fjnCPVHSCZ7dvUJcQO4H
7s+iuTQJKBmldwaPx+Q4v609DQotig02ePKUmAKGGVnMmNdlFQg+cWuuKTwRaf+s
ykPVj/K3T67rvmxypEfjxRWjY+RKw/t31plxGeQsNqV6F4nwnF9Qu2R6fyV6u5t9
Y+NaY29geQLPN5u7l2kPxvGHMQjUmuSj3GLYsdvXPSdYBhyEsn3TFqH8XkXRhdQK
q13D8AaZfy0meHy63puO2QvfNLsCazEGDKEUti5bWyvMjmL+dNv09m3R66x9bOZe
Ytza0SdJolbm9FxEWT05qFxg1gOzyikqKLC05JOM7eWfMbbny0uvlVkjZwaBPz9X
T5wRV8Sf+gyYvqVjIjI2
=YVOK
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
