From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Fri, 29 Apr 2016 08:17:55 +0300
Message-ID: <20160429051755.GC774@leon.nu>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me>
 <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5722C24B.6020108-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 28, 2016 at 10:09:15PM -0400, Doug Ledford wrote:
> On 04/28/2016 10:01 AM, Or Gerlitz wrote:
> > On Thu, Apr 28, 2016 at 2:56 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> >> On Thu, Apr 28, 2016 at 02:17:29PM +0300, Sagi Grimberg wrote:
> >=20
> >>> FWIW, I'd love to see ib_rxe upstream asap. In fact, I even have
> >>> some patches to contribute for it.
> >>
> >> We are planning on submitting it in very near future.
> >=20
> > So.. lets get this going, Linus made a comment [1] that we might not
> > go up even till rc7, which means there very little time left, Moni?
> >=20
> > On a related note, is there ANY patch merged for 4.7? Doug, are we
> > again going to have have it in
> > all-patches-merged-on-the-same-night-10-days-after-the-merge-window-ope=
ned
> > manner?
>=20
> I have topic branches started.  The generic RDMA READ/WRITE API is
> almost ready to go once Christoph answers the last few things.  That's
> really the only one in queue right now that's big in terms of core
> changes, most of the rest of the stuff is all driver or ULP specific.
> The RSS patches haven't got much review yet.

Doug,
These patches are long time here in mailing list and they were reviewed as
all other patches in this mailing list.

> The SELinux patches are in RFC stage, and IMO should be shelved until
> verbs 2.0 API is settled so we only have one API to apply it too,

SELinux code adds hooks which are deep in IB/core code and doesn't
play with ABI at all. This is unrelated to ABI change initiative which
anyhow will be required to support existing IBTA specification.

> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIu6DAAoJEORje4g2clinFDsP/A2srg+HTtWfNfCfIplWfzGE
SB8NCLgVVdHqyWgey+e2Lws6m/OxmAS3T3be+fGlYt8eTYBoXg5OKltf7TwEm/CB
ZV/f0NF93/sDEYkCK2vsPGHDsUOfXEu8SRFLdBnwF91FJzDC4jnkjG60I+I9VpCs
HoFBG7p4przpZYs2apVfH9zzmm1zk8BSvskd0UqoJ7olK8Nhm1DZfQ8C+uW/g84B
KsCVhc3Yb0wDov6ksVza1vQMFJAFIn1nLlwBIZ8+6EayEmJYssiDckG+Cuh3gcY2
mONKa/gJTZs3tkedsDvZakEo2BJKYXvqu22XOhVwnMQ8YuSJz3sMgwPhYuPg+rUi
S+3tPfM4bcE3i6gcjyr/VTeA5hxNxcRIz+jqRkiszx65vdVh+2BZ5bCF3repdCAb
dQxXzXNOVXZRCLGCjtubqQxz91o9tUy7ZUo2LzQMJzvoNEMcrZcOjMNxNQ8kAFYA
4NckSgoT9/RDIIikcvJkgoO/yznSVQlDDLo8UOdzxZEg/1OlaOcyHykqTzWa/BOy
QfoWmSHjvrqzPwviLo/QYxLES4WlYu2dk+8r0saIwKreouAMTRARKeh2sIaRLsxw
4iH6IoyPwIONUYatYiFCXMK8Tg/xM5RkfPWxpN/sxt7XaJ/2Qi1t1u3wwucH2Awm
d1/SzEnqN6XVEPnZs4Ok
=bTzb
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
