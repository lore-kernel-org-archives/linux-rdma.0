From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Mon, 16 May 2016 21:54:35 +0300
Message-ID: <20160516185434.GC4662@leon.nu>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <298657b0-6e57-745b-5eb3-001984bffbc3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2016 at 01:42:34PM -0400, Doug Ledford wrote:
> On 05/16/2016 12:30 PM, Leon Romanovsky wrote:
> > On Mon, May 16, 2016 at 11:09:44AM -0400, Doug Ledford wrote:
> >> On 05/15/2016 06:51 AM, Mark Bloch wrote:
> >>
> >>>> But, just as importantly, after reading addr.c to see how it uses th=
e ibnl
> >>>> infrastructure, I don't even see what the original problem can be.
> >>> As it stands today:
> >>> - ibnl is part of ib_core.
> >>> - ib_core needs ib_addr.
> >>>
> >>> So if we add ibnl usage to ib_addr it means ib_addr will need ib_core,
> >>> which causes a dependency cycle.
> >>
> >> Right, but in that case, this patch needs to be part of the series that
> >> adds the ibnl support into the ib_addr functionality.  Because you spl=
it
> >> them into separate series, this was a patch looking for a problem to
> >> solve and it wasn't clear what it was.  If I had taken the other series
> >> and not this series, it would have broken things.  So please keep
> >> patches like this together with the other patches that depend on it.
> >>
> >> That said, I also don't want to redo modules if we don't have to.  As =
my
> >> previous email points out, changing modules breaks init scripts and
> >> systemd unit files.  It is to be avoided when possible.
> >=20
> > Sorry,
> > I was in the mood of fixing things when I wrote and sent this patch.
> > The question is which version will you more likely to accept: this one
> > (remove ib_addr module) or previous one (add ib_netlink module)?
>=20
> Can you build netlink in and then init the ib_addr module after the
> netlink init is complete?  Wouldn't that resolve the dependency ordering
> issue without changing the module names?

It seems reasonable and we will test it, before reposting.

However generally speaking, I agree with Jason and Ira that this module
(ib_addr.ko) is useless as module and can be part of ib_core.ko.

It doesn't seem as a big deal to fix all that init scripts (remove two
lines).

>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXOhdqAAoJEORje4g2clinuzMQAIcCxp3WLTL4jbvtlZZwceYO
zU144cK/TQMZ+LMjYSu3GEcsdj8dSNRObCWNYJZAwLMAYA1IsJFwswl7nEqHzq41
8SGd3+I13ALoV1XYOdvW1f54x6g6X51TwhRZulV0VAP0ntPg4w9+CnfCsq7v61xE
l3O/Z71vepqWxebw4b2RtqgdIBTIMrik1kioIGZo9lnyr6x+RjQ5Kt8U1vzGjzS/
mc2hoMKwcBydBDcQnqW7/jmgyJAqG6NoSDKs8hUB6QeRJs8HNrbs9DFfWzsCiHjd
InfSmv2+D6S4HcpLkw8lI9imLVqm45zmxvaMJOjVTawesfDnEArBBAhnPVloDNAb
fMJ1vgG9rnn+Un9P0NeLh61TlvUVhkD0Rf+qZPqBYmP5RvuYXxThIc+yAy1VkHsw
cNtBQud/eC6xCt1QHFk12/Pzp3uA14X7YC9x69RrmOo2zA5XKmDJzRXDKI6BWsCY
/BM5odX5uCmWUFJFv1s2ODq5MA22XE7HqhlBX7eBUVnPl/T1DD0R6RHKdfHQ0hHj
2/7tfBTVA4k//IZbcqacKv18tICylFT+UNXSFy1109ynqcNiFQ8gnwPvDUmAMGaB
aebZGjsK7/9582J8JBkzw/D+m+OHAn9MwFfxtXISBxDTDnn0qBMfXBfUdDdtUl2K
o8DBoJMN1nPWqL8L9phy
=dUSw
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
