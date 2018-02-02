From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Fri, 02 Feb 2018 11:40:37 -0500
Message-ID: <1517589637.3936.16.camel@redhat.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
         <1517587623.2675.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QKxFaysXvZjFb5/wYDq0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517587623.2675.8.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-QKxFaysXvZjFb5/wYDq0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-02-02 at 16:07 +0000, Bart Van Assche wrote:
> On Fri, 2018-02-02 at 15:08 +0100, Roman Pen wrote:
> > Since the first version the following was changed:
> >=20
> >    - Load-balancing and IO fail-over using multipath features were adde=
d.
> >    - Major parts of the code were rewritten, simplified and overall cod=
e
> >      size was reduced by a quarter.
>=20
> That is interesting to know, but what happened to the feedback that Sagi =
and
> I provided on v1? Has that feedback been addressed? See also
> https://www.spinics.net/lists/linux-rdma/msg47819.html and
> https://www.spinics.net/lists/linux-rdma/msg47879.html.
>=20
> Regarding multipath support: there are already two multipath implementati=
ons
> upstream (dm-mpath and the multipath implementation in the NVMe initiator=
).
> I'm not sure we want a third multipath implementation in the Linux kernel=
.

There's more than that.  There was also md-multipath, and smc-r includes
another version of multipath, plus I assume we support mptcp as well.

But, to be fair, the different multipaths in this list serve different
purposes and I'm not sure they could all be generalized out and served
by a single multipath code.  Although, fortunately, md-multipath is
deprecated, so no need to worry about it, and it is only dm-multipath
and nvme multipath that deal directly with block devices and assume
block semantics.  If I read the cover letter right (and I haven't dug
into the code to confirm this), the ibtrs multipath has much more in
common with smc-r multipath, where it doesn't really assume a block
layer device sits on top of it, it's more of a pure network multipath,
which the implementation of smc-r is and mptcp would be too.  I would
like to see a core RDMA multipath implementation soon that would
abstract out some of these multipath tasks, at least across RDMA links,
and that didn't have the current limitations (smc-r only supports RoCE
links, and it sounds like ibtrs only supports IB like links, but maybe
I'm wrong there, I haven't looked at the patches yet).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-QKxFaysXvZjFb5/wYDq0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp0lIUACgkQuCajMw5X
L92YyBAAnNs5QzXCTI5BxBiDEd7zn0NXy0AtcElZfHO/Vvrp4H7Z3UH8ZI6EDpIa
tcwebhj1aUxUlKJ53imzs7Oy9pkp8Vr0I2Te2xhpHEtL+YAGl/Z6GU5nEuFKfG6E
cLPOCbjRBK4Bx+0M4UC0GPFYVUASHF2is8OZhYa8heci2973T+rTghYoGjuf/hy/
xDI76cBMZ5KQvh0IJilBbKHixoMMUhmGLHiRVRMuUofsk7udIxK5FJCUvRAcvfl6
RpucYQ/HHGDkAKlc3IMwne058Wth7n4hbWWShQSSIUyqJzZi9zydcT6yaJAQxBUV
yjh8Tf76Lw1fCeCGwZOJ5gd4vGDhflMfT3f7ywsXVPwn6HpYXaS+7MjTJ64K+0Hg
8Q6s/dNfWndb+jvqt8XHykz4/y2SDPH6RiM3CdybrGRM7tysWhKZSsJyS7jV8c2m
dTNUwdm42Qba0r3ePy4c2QcabI43bXds7zA9Nk7Mjrcgjr/D18v2t8YBrddDv9Br
QtSGSojcf9fzKZkrMeuA1P91x7OQVDwgo//NflDCM4AAMuuR1YPTO2htKK/20+qH
/iBRWjUPWAPUZeSdiNsZ5mIRqRRggrRrNJNAyY0+2zTDyyLguw/Zge5T3a97vxwz
gORUcHGF7tqivOY87G9104EkBnLuIDxunWS0nEmIppv67wd5Gyo=
=O3vO
-----END PGP SIGNATURE-----

--=-QKxFaysXvZjFb5/wYDq0--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
