From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Sun, 29 May 2016 11:16:46 +0300
Message-ID: <20160529081646.GA25500@leon.nu>
References: <20160524214951.GC7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05023F@ORSMSX109.amr.corp.intel.com>
 <20160524223052.GI7950@obsidianresearch.com>
 <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
 <20160526172244.GC27115@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BB5D@ORSMSX109.amr.corp.intel.com>
 <20160526233612.GA4396@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BC0C@ORSMSX109.amr.corp.intel.com>
 <20160527131956.GY25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05BD12@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="72pTQ1Q5L511SwPT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05BD12-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--72pTQ1Q5L511SwPT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 27, 2016 at 03:04:00PM +0000, Hefty, Sean wrote:
> > What do you mean by "the kernel client"?
> >=20
> > Maybe you are referring for something else, but I think about driver's
> > implementations of callbacks which will cause to code duplications.
>=20
> I am referring to the creation of an ioctl handling framework that is sui=
table for use by the rdma cm, ib cm (if kept), verb devices, and non-verbs =
drivers that do not plug into the kernel verbs framework.  The kernel clien=
ts are the items I mentioned.  Having a common ioctl handling framework wil=
l maximize code reuse.

It looks too generic for RDMA subsystem. What does it make this IOCTL frame=
work specific to RDMA?

>=20
> - Sean

--72pTQ1Q5L511SwPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXSqVuAAoJEORje4g2clinGfYQAL7cl5KGNckebJ5JIuqM+CJ2
GUtb+/my8PfB5sSop2pw9alt3seTDBnE8B6GrqI35AtW6/WZqQY5XV1NcbRxalNn
kQbS2rnnt9fE+j5EbntGknqzK0wY1de/+ml05bjisk2fPsmO3AI4eHSDFLo1xdqk
d6sLrUHnddCFAV2xHnorfxxwSQ+I7GcyGJnz69NSiWhz3mAkYUOvyn73aqobA8lC
cAZcoBxz8xk2hNTPeSLulm+vxfPqx4gzmNju72UOXsooCC0krwd52JsoV3HGPuUb
nWsVfsAPkH3iPNYpMdzV2nIhJSdl4h+RvW98G6l37wwUwxNXFj104YLUYOnBstP1
c6SUYcnZRTf31lAl7zgniVkGwUd4dPYjYlswdK/BBENcGERiVjSyHQ9jVDPPxAhX
WqdR7Nnx1ZDe/nphPVhNSuJk/J8Pd3Zk6tZfsyj9C7gcZ2oSChfDphdPDdd++krK
kTuS8CLZ+eBwCzSI5lYCrjBvZ1B2qfIgGt2WucJV799M55dXZV+UoKJ/XVmVsb0K
3YckzvjqkpdMAcEdpizwttX8oOkwhz9A/SSGlLU/nb0UBh2PA8V7cbChVAjBlPn3
PT1qXYT+Ox7msWZQ3pm+j+OtokbnrbOF4/GTEBAGXLcBfpmObEhB2bXlRTAjn7H+
E5coRQxUKPj5pQvmYBZY
=g/zK
-----END PGP SIGNATURE-----

--72pTQ1Q5L511SwPT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
