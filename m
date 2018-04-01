From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4 iproute2-next 0/7] cm_id, cq, mr, and pd resource
 tracking
Date: Sun, 1 Apr 2018 21:29:45 +0300
Message-ID: <20180401182945.GI22232@mtr-leonro.local>
References: <cover.1522359537.git.swise@opengridcomputing.com>
 <8cdcb764-da42-e540-90e6-309eda0eb599@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8cdcb764-da42-e540-90e6-309eda0eb599@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Steve Wise <swise@opengridcomputing.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 01, 2018 at 09:22:14AM -0600, David Ahern wrote:
> On 3/29/18 3:38 PM, Steve Wise wrote:
> > This series enhances the iproute2 rdma tool to include dumping of
> > connection manager id (cm_id), completion queue (cq), memory region (mr),
> > and protection domain (pd) rdma resources.  It is the user-space part of
> > the kernel resource tracking series merged into rdma-next for 4.17 [1]
> > and [2].
> >
> > Changes since v3:
> > - replaced rdma_cma.h inclusion with UAPI rdma_user_cm.h
> > - display only device names instead of device/port for cq, mr, and pd
> > since they are not associated with a specific port.
> >
> > Changes since v2:
> > - pull in rdma-core:include/rdma/rdma_cma.h
> > - 80 column reformat
> > - add reviewed-by tags
> >
> > Changes since v1/RFC:
> > - removed RFC tag
> > - initialize rd properly to avoid passing a garbage port number
> > - revert accidental change to qp_valid_filters
> > - removed cm_id dev/network/transport types
> > - cm_id ip addrs now passed up as __kernel_sockaddr_storage
> > - cm_id ip address ports printed as "address:port" strings
> > - only parse/display memory keys and iova if available
> > - filter on "users" for cqs and pds
> > - fixed memory leaks
> > - removed PD_FLAGS attribute
> > - filter on "mrlen" for mrs
> > - filter on "poll-ctx" for cqs
> > - don't require addrs or qp_type for parsing cm_ids
> > - only filter optional attrs if they are present
> > - remove PGSIZE MR attr to match kernel
> >
> > [1] https://www.spinics.net/lists/linux-rdma/msg61720.html
> > [2] https://www.spinics.net/lists/linux-rdma/msg62979.html
> >     https://www.spinics.net/lists/linux-rdma/msg62980.html
> >
> > ---
> >
>
> applied to iproute2-next. Thanks,

Thanks David

>

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrBJRkACgkQ5GN7iDZy
WKc4Hg/+KlGX291hS/IZf6hM56/+9zSAlh/5VZxnLD+9bdAmY6GS6l5Az2J6tsCS
qCrNANlDpi4x1LGUp4rOJ9rhNKckeb9V7ywVs97uM8tyUO3dBjawNQ5Bz72jbRpz
jCrgjbiCT5hjbqsndfD9630IURjNnq5A90k6XsEUWNRqvRflwnGfxrEligAVijJ6
Rx8CzbAzmT5AvVbQO1Pi03snN6gb6ZL88LxIUZuq1X/lf1H1tuqbXYY+Kl4rmcLE
TW3mziwPbw21fT25YZGtzCWNgYTvDKsCW4nxpV6TrAcgAnLgWddZpZVJxrZlwO+r
awi+F6xPWO51HvDOlJ6GIU2J0Yc378f6TfoNvpQcb2l4TpWl0dubEngoyKsBsuJG
9XAkeV8Otg6vY7DAfqckO+UGNR7xsziezaoRBILzXZw/TNnqDxv0NPz75LJpMPSI
E8KOSIUc0nmw9B6smXAr2nyOVJj765lVrIPrGwfVWF3epL2I5JJPLOtSJ6p2bkti
dEeyU5X29QPSSU2ohhshpQEbekkCIjlV4917SeEBh38kMJMcl3q34F0ACEpBompH
+zORW8U9SNkgt358kfoi0V6bwwvPUAY3rPvnOD7Zn/rRrmrd0XRC31CxBhdt/luH
b3Kh9+5vl3Z7wUlvVcFL+5GBd5VP1+6ZvdWGXmox2OxP+RpgaVM=
=fewB
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--
