From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Tue, 17 May 2016 08:48:34 +0300
Message-ID: <20160517054834.GD4662@leon.nu>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516185434.GC4662@leon.nu>
 <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2016 at 04:27:05PM -0400, Doug Ledford wrote:
> On 05/16/2016 02:54 PM, Leon Romanovsky wrote:
> > On Mon, May 16, 2016 at 01:42:34PM -0400, Doug Ledford wrote:
> >> On 05/16/2016 12:30 PM, Leon Romanovsky wrote:
> >>> On Mon, May 16, 2016 at 11:09:44AM -0400, Doug Ledford wrote:
> >>>> On 05/15/2016 06:51 AM, Mark Bloch wrote:
> >>>>
> >>>>>> But, just as importantly, after reading addr.c to see how it uses =
the ibnl
> >>>>>> infrastructure, I don't even see what the original problem can be.
> >>>>> As it stands today:
> >>>>> - ibnl is part of ib_core.
> >>>>> - ib_core needs ib_addr.
> >>>>>
> >>>>> So if we add ibnl usage to ib_addr it means ib_addr will need ib_co=
re,
> >>>>> which causes a dependency cycle.
> >>>>
> >>>> Right, but in that case, this patch needs to be part of the series t=
hat
> >>>> adds the ibnl support into the ib_addr functionality.  Because you s=
plit
> >>>> them into separate series, this was a patch looking for a problem to
> >>>> solve and it wasn't clear what it was.  If I had taken the other ser=
ies
> >>>> and not this series, it would have broken things.  So please keep
> >>>> patches like this together with the other patches that depend on it.
> >>>>
> >>>> That said, I also don't want to redo modules if we don't have to.  A=
s my
> >>>> previous email points out, changing modules breaks init scripts and
> >>>> systemd unit files.  It is to be avoided when possible.
> >>>
> >>> Sorry,
> >>> I was in the mood of fixing things when I wrote and sent this patch.
> >>> The question is which version will you more likely to accept: this one
> >>> (remove ib_addr module) or previous one (add ib_netlink module)?
> >>
> >> Can you build netlink in and then init the ib_addr module after the
> >> netlink init is complete?  Wouldn't that resolve the dependency orderi=
ng
> >> issue without changing the module names?
> >=20
> > It seems reasonable and we will test it, before reposting.
>=20
> Thanks.
>=20
> > However generally speaking, I agree with Jason and Ira that this module
> > (ib_addr.ko) is useless as module and can be part of ib_core.ko.
> >=20
> > It doesn't seem as a big deal to fix all that init scripts (remove two
> > lines).
>=20
> It's not removing two lines.  If someone wants to be able to boot both
> kernels prior to this change and kernel post this change, they have to
> now write their script to handle both conditions sanely.  And they have
> to know to do so, where as very often they simply get caught off guard
> and things are broken for some period of time.  If the change to ib_addr
> actually solved a problem that couldn't be solved otherwise, that would
> be one thing.  But it doesn't.  It's a complete no-op.

I think that your position is too tight for not allowing modules
restructure. It looks like that this complexity doesn't exist outside
testing scripts.

For my testings, I'm using Debian Sid with inbox scripts/packages and it ha=
ndles
correctly IB stack with different kernels and different set of modules.

>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXOrCyAAoJEORje4g2clinfFUQAMTBgyDCbRCoLgE8uaXr+ld0
QoqYZ152/zsYVVe54XHW+nvp+UK8B21zd/pv7cM8uXutsF4VtD8KBonnYR9xihHW
ENLHltQj37Wr0LJABifoeE+t8Wz4f06w7xOo6I4q8n//5Q9U3vUXQ87FNNE57LiN
vZZMdSzinGA6D40u4glo8KEbJCBWa/a79vbX1VcXhSXYzZFfpTHZUCSjCQhW0ue9
bWHHmkjBvrR3UHuRH1QNwGOd+riVwtPs78Apuk6l91+1oVCRxM+XGlWdiulZ4yDJ
wYKMayL0alASKnwUzDRz6glGKqZbxdHJ/F1Q+oIv/gn+GC9kTIE/aweGh5pXD6Jl
/sZqOj+iz1vUaxwU3v6jqFtDggKamUu0Eni9RTlPSZQ4cBXqE0vQNgL68hZlf6U/
KLAavbBv/bhgaxf92zIm3Z4XJiK3Y34AFX5rZoCCiN2S52grqLbaT8m6TZVePFHD
J5FGkbnp9kx9scYrf9gmfUUOv+V+TZ9BFLvIpEyAYg8x8zohNxy7rJxgBXGMkYrj
g23GZTzrw2+RaHHgCQKsoYAcuqPCJuVgQipaj/LLpbDu6aRpDZVkIu7++VPAYUHZ
PX2f0ac86d3yI7qNKeX4DDlOQ8bKycGXiPsSSau6+XreYf80yeCQ3w2T/w/aV2cL
qeKlZWnfZ0/XgPSYqYu7
=qebq
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
