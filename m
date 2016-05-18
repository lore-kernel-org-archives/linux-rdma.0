From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Wed, 18 May 2016 07:41:19 +0300
Message-ID: <20160518044119.GH4662@leon.nu>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516182743.GF7248@obsidianresearch.com>
 <5045d314-e2f5-bda6-5583-2212335593fd@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ik0NlRzMGhMnxrMX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5045d314-e2f5-bda6-5583-2212335593fd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ik0NlRzMGhMnxrMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2016 at 02:39:10PM -0400, Doug Ledford wrote:
> On 05/16/2016 02:27 PM, Jason Gunthorpe wrote:
> > On Mon, May 16, 2016 at 01:42:34PM -0400, Doug Ledford wrote:
> >> Can you build netlink in and then init the ib_addr module after the
> >> netlink init is complete?  Wouldn't that resolve the dependency orderi=
ng
> >> issue without changing the module names?
> >=20
> > Why are you so worried about ib_addr's module name? Is that actually
> > hand loaded instead of relying in the implicit dependencies???
>=20
> It's hand unloaded.  Depending on the release of software you are
> talking about, the init script has the ability to unload/reload the IB
> stack.  In that case, it has to know about ib_addr so that it can unload
> after ib_core.  I should know, when the order changed from ib_core first
> and ib_addr second to the opposite it broke the Red Hat init script for
> a release, including all the bug reports about the rdma stack failing to
> shut down properly because it was unloading modules in the wrong order.
> This falls in the same category of a lot of other things: you don't
> break user space if you don't have to.

I think the reason that this thread fails to die is our trouble to
understand if code refactoring is enough justification to get rid of all
these modules.

All guides/scripts which I saw, instructs to load all these ib_...
modules together and it looks redundant to have such large number of
them [1].

[1]
http://www.rdmamojo.com/2014/11/08/working-rdma-ubuntu/#Starting_the_RDMA_s=
ervices

>=20
> > Is failure to load a module going to break any existing scripts?
> >=20
> > Worse comes to worse, just make dummy empty ib_addr.ko, but
> > I've never seen that in-kernel before.
> >=20
> > Jason
> >=20
>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--ik0NlRzMGhMnxrMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXO/JvAAoJEORje4g2clin/ZwQALSEdbG8dUPj1m64mXkanJFS
+6/LDKoAYct+4HXsbQwULqWqOzg6H+/WDomxl/G5+h12osr3oDXjcqa94KcpjBOM
Ic3qQTBhyT1gpBWtxTDCw5qEgHzJIfjhbyy17LvrNqjRATswGZWxCs7/BAjItd/p
/SnLHRTzSlrgHYLYpY4GdqrGrsf6xUQ1y72y2k/NXjz59HCO17CgrGmw44+L2yc2
ZzWjBAt+WBUR6hCOApCMQ1JANMLVMWGvlhGBz4BeP2QAf1dfxEW/MW5Fxmiedspf
9dx0z/uIze9GMKJe+YheyQTVQnIH+oNU8HLyqLJrKpZk14XaKTnWpfMGMU8UV4Uj
tOWPEtEyQMJRlrdUBs1W4oxBZ4Wmm3CUNdpG/Q9e7Sidr5VLHZI3EF9E/8QPOwKF
sftycE0GOePJLH00vEh7B6oUnQD43/MuYKaFhCp0gUoN/h8ZGLqSnn+sPympwcKu
bvtWNkBUs3ebeO/p2P6QyxAuMhaasdFBlVn8ixR6soTF4dKeXeyaPtE7AwgaAH1o
/TCQ2VnoiTOUZejp9yoiGBHIe4ACr6wGp8Bns1fiCUzOPpyrPQ7TcC/RucBrHSNU
UrmNL5D56jRZR4dUWVidlnBsQxxhawz40I1ozV3LL4p8QJmTvehMZe4CR87bwyFr
XHmTKl5uG20fuSPF8x63
=3i4o
-----END PGP SIGNATURE-----

--ik0NlRzMGhMnxrMX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
