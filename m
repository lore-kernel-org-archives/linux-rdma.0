From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 0/3] Add cross-channel support
Date: Thu, 24 Dec 2015 11:55:20 -0500
Message-ID: <567C2378.7060700@redhat.com>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
 <567BA695.8050403@mellanox.com> <20151224100001.GA21387@infradead.org>
 <567BCBD1.708@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ib1VvlivvLHhmarHOLK5GDousM3l6xvJg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567BCBD1.708-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ib1VvlivvLHhmarHOLK5GDousM3l6xvJg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/24/2015 05:41 AM, Or Gerlitz wrote:
> On 12/24/2015 12:00 PM, Christoph Hellwig wrote:
>> On Thu, Dec 24, 2015 at 10:02:29AM +0200, Or Gerlitz wrote:
>>> We had consensus among the reviewers that the 1st patch ("IB/core: Al=
ign
>>> coding style of ib_device_cap_flags structure") is wrong cleanup whic=
h
>>> basically is (1) unneeded (2) creates more damage (git blame and such=
,
>>> non-applicable to uapi, more) than benefit, etc -- finally Leon was
>>> convinced too [1].
>> It's not really an issue vs uapi.  Using the the wierd BIT() macro
>> would have been, but without it I think this cleanup is ok, even if I
>> personally wouldn't have done it.  git-blame isn't really a major
>> issue either, as you can blame past revisions.
>=20
> I would personally wouldn't done cleanup either and I managed to
> convinced Leon to drop it, so we had concensus among the developers, th=
e
> maintainer didn't have other opinion and he took the wrong step -- so
> we're asking to fix, that's all.

That's not true.  I didn't bother to speak up in the thread, and I read
all of the comments.  I didn't move to BIT macros for the reason that
Christoph thinks they are crap and I didn't bother to prove him wrong
and took his word for it.  However, just aligning the macros in the area
that the patch touched is reasonable (versus aligning the entire file
just for the fun of it), and git blame will continue working fine.  My
taking of this patch was intentional (in fact, the patch didn't apply, I
had to redo it entirely by hand because the comment changes caused by
Christoph's MR cleanup patches kept this patch from applying at all).
In any case, it wasn't a mistake, and there is nothing to fix up.

>>
>>> Leon will re-spin in the coming 1-2 hours V2, could please pick it
>>> instead
>>> of V1, when people agree on direction X and you are not against it,
>>> lets do
>>> X and not Y.
>> It would be great if we could stop rebasing whats already in the tree
>> for the benefit of everyone building on top of this.  For example just=

>> finished rebasing my series to move many constants includin this one
>> to the uapi headers, and I'd hate to rebase it once again now that
>> the dust has settled.
>=20
> The root issue here is that nothing was picked before 4.4-rc6, so we're=

> in a situation where rebases are needed in the own-maintainer tree
> (github) to make things right. No way to avoid that.
>=20
> We should aim that for 4.6 and onward, code for -next will start gettin=
g
> in around rc1-2 and then things will be more robust, etc
>=20
> Or.
>=20
> Or.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Ib1VvlivvLHhmarHOLK5GDousM3l6xvJg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWfCN4AAoJELgmozMOVy/d+d4P/03bz/ENtqh0l26Z0mGZtwN4
3xzI6/Y+881PcjPg4/Hp20oJqTjUs5AN1Qn9RTKKlEn+99fo4RrqtDNIST1C7l6b
5yZKG/4WLN1cJnit5jt7tJZ7cuc6tzO65/TXqQJvw1HvsUux/HkMzTXs7SKUhi+G
sGXUaQA06ctmxeHMX+fH+uq8mO+JU7ivGggBzVXmqyXPlGs81qM/AIX3AmrfJeN9
T1RKkLgOABCi0BETJZhQ1C5HPZmbte7NHhe/L14Fm2d3ptf9LaVX/v6zR+Zx7GRp
0C00/DZbyq7kA/GmB0sucOTkWmWMNyu1mX9GOP6Fma90Jeq7+I16rA7K808Sz/A/
LDT0anGoRmuL0ZlmerEyIp9h5pKO1xs0gKC1HsEO8KKlGxXHfJ6uWAZsevmmIZlY
tzimXrmMy3D3BdAfado5XTPyf/Qspgf46G1WqZmiZSkFDaJiKi0WTDYqW92IeYKU
SL9swrwfEFOZK9d2S9xwZt65JcarrCon876a17CeEP7SPFcTqL7jJSWcgjS5O/ja
4g4v74SL5F2kR47G3LQTwwXtGsp0jp+hPVPmLM+nrzXeY9LRWa2mei77l5Cz3LMg
dFU3XAeMDTchSYoJQU19LiOcF38H3FiIqj1Impq3N8H+DpRcOfy+oTaub+LVSxcJ
3xYewD92FimJy8DStKce
=vYIt
-----END PGP SIGNATURE-----

--Ib1VvlivvLHhmarHOLK5GDousM3l6xvJg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
