From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 00/26] New fast registration API
Date: Thu, 29 Oct 2015 10:16:33 -0400
Message-ID: <56322A41.9050004@redhat.com>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>
 <56262676.7000403@dev.mellanox.co.il> <563185AC.10804@redhat.com>
 <CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="em2AUrjTjDAQbLUjHqbAT378hRgD9UDiP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--em2AUrjTjDAQbLUjHqbAT378hRgD9UDiP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/29/2015 01:42 AM, Or Gerlitz wrote:
> On Thu, Oct 29, 2015 at 4:34 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> Yes, I've pulled this in for 4.4.  Thanks!
>=20
> Doug, we want to run regression over the 4.4 bits, when do you expect
> for them to show up @ your kernel.org tree?

Sorry, when the fast registration API caused compile failure yesterday I
stopped at it and forgot to push the result out.  So, I've removed the
last patch of that series so it resolves the build breakage for now.  We
can add the last patch back in after the staging drivers are fixed up.
The result has been pushed to both github and k.o.

> some of them are there but
> @ least 3-4 series which you said "applied" aren't, AFAIR last time it
> was only about whole ten days after the merge window opened. Also,
> without the patches being there the code isn't subject to linux-next
> merge test (also after being there neither, since the branch name
> changes for each release and I didn't see you setting a flying tag, or
> you did so?)

Yes, I set a flying tag as you call it.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--em2AUrjTjDAQbLUjHqbAT378hRgD9UDiP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMipBAAoJELgmozMOVy/d92UQAKsm/r3m3SsJMOuTf0hxyuc6
trqR/gxguIS0kn5JOJXzRSmGVHe4U5ENtAT9FS1kpZ4fAZBGEgd2txBuR8tvugee
5dkTek+HlnBfsw6zHVwIVobwO0oE0UyiVg1lIWyM7PVt2rrOnge0/R6dVSdVlnox
OHPF6yK6x2hH/w8GurPbHLHaYis15r7tRnSrvl12lZsprQna5UC+bmMSMlYImSgU
z+b2qKNB4fgxfrWC3eaycJsA+r5iTxyWhF9J60QhYTJepygwx04qrhJKQ88KmcDP
iq+boT3xsNJPYu84zH3nkeNktYNR3lKUKWaT3HU1jBp4WaFMUyh7gY+M3NbxI1Rb
IaeLQrjzINfZ9vVE+dOwr+VJ2hbNE7qzEPdiXhdXTzmhFpSjbsCXXvwKgTG5sQKZ
S0TWYCYTmeH928FprcHx8K+0essussAPF2rFCU25+3zaRDMqsYnYzrQXZDG+gLT/
z1kPSPxHAXkz2nvbpVJkJJo4zyqaMykL3imKyJ15JWUDy7lQ/gCYIZXoEz69VcbO
y12+EskiAGvQ6mV8RAbNYpCw1xnm/3OGn+hGNi34ApjMdYarweIRcDSMmN0DCe4x
1DsyQ36KOfkPcK+hG/67lD4L9AV3eOspTmzE+y69DPdQHA4Zjv47gfoo3MynU+iG
QOBcqQHignSkhuQE5TCM
=tL5d
-----END PGP SIGNATURE-----

--em2AUrjTjDAQbLUjHqbAT378hRgD9UDiP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
