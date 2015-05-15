From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] Documentation/infiniband: Add docs for rdma-helpers
Date: Fri, 15 May 2015 10:40:19 -0400
Message-ID: <1431700819.27722.15.camel@redhat.com>
References: <1431523472-10888-1-git-send-email-yun.wang@profitbricks.com>
	 <1431529914.2377.22.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDA105@ORSMSX109.amr.corp.intel.com>
	 <5555AEE5.9060503@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Ra/z5l4G0CsfTi/hSlhD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5555AEE5.9060503-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Ra/z5l4G0CsfTi/hSlhD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-15 at 10:31 +0200, Michael Wang wrote:
>=20
> On 05/13/2015 06:42 PM, Hefty, Sean wrote:
> >>> +  rdma_cap_ib_cm
> >>> +  ---------------
> >>> +    Communication Manager (CM) will handle the connections between
> >>        ^Connection Manager (CM) service, used to ease the process of
> >=20
> > In IB terms, this is communication manager.  It also handles transport =
level address resolution for UD QPs.
>=20
> I could find both 'connection' and 'communication' in different docs,
> while 'connection' is more related to verbs, 'communication' is more
> close to specification.
>=20
> IMHO 'connection' make more sense, after all, all the transport between
> adaptors could named as communication, while connection management is exa=
ctly
> what CM did in kernel.
>=20
> Doug, what's your opinion?

See my previous email.  I can understand using the official name, but I
can also definitely see calling out in the more verbose section of text
that what this does is more close related to connection management (and
I would argue that transport level address resolution for a disconnected
queue pair is a form of connection management too, it's just connection
management on a packet by packet basis).

> >=20
> >>> +  rdma_cap_eth_ah
> >>> +  ---------------
> >>> +    Infiniband address handler format is special in ethernet fabric,
> >> use
> >>> +    the helper to verify whether the port is using ethernet format o=
r
> >> not.
> >>
> >> This helper is true when the address of the specific connection is of
> >> the Ethernet (RoCE) variety.
> >=20
> > This is used for connectionless communication.
>=20
> Could you please give more details on this?

The test itself doesn't mean that.  It means we need a RoCE address
(it's true when transport is IB and link layer is Ethernet).  That we
*use* it during connectionless communication because we have to generate
our own address vector for the packet while during connected queue pair
use the address vector is created by the card using the queue pair
information is just the circumstance of its use.  And even though a
disconnected queue pair isn't solidly connected to a remote endpoint, it
is solidly bound to an adapter that requires either an IB or Ethernet
address family.  Maybe this to resolve your issue with the wording:

This helper is true when the address family of this queue pair is of the
Ethernet (RoCE) variety.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-Ra/z5l4G0CsfTi/hSlhD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVVgVTAAoJELgmozMOVy/dfEQP/10OBiJqWu6D3ayEvARkbHgD
0371pPVlshQELbjaCaAJmx73K0xcnyLADmeDwH3+X618d6FEKyykKi9lvW8dFj9D
e6D6R2mxFocxwuUIY7YKtpr3O2atAOft5sSAhXAv+p9TKNPx3cY7VfXseGTnF0sa
S+fBXmJT64AYcE4giCfmRLZD6JJJ1MBowo2BTKgLWunuINTEpbxqHx4ZYxQem0iV
RRfviqgBg4yj7oCTMeQ+hwQQztmSv3FYEQiKmpoxyGGZvZw5w2EoiYAWQFMUiBm9
GpDPYBG9m66skhRAowzr339MGCCzGkEOYl296HP74Xoun30WtSeYNiTPXpVfbe0y
Ymfpadtw7tTEE/3usxQIBFePPJeFCgVrIg7wiSXJhHjF1XgH6oaOX/svcRjQZKmH
K45k2TEQVYX+lnsYqDrwdNT1ZmMbpv9QPr0DXw0dJ//6nUE8tQ2UKWXhL9cKzeOA
i5oRvH6hEsgsHhb5kXrYt83QAI31r8inFAZNeOLa0OXDHyH4qwIVYfZKUysJYTHa
t+EfUd2w3xbY7sYsS/8CXKcDmaWYbw3h6xv4qFB8zEYQQlRPuR5ZinLYyz6FRSgP
eDlg6/CVmIrE1pe+GHGG6+4oGqUSr0KVEVinwsTZiCakmCP3Jq0rWurlAfbE6H6d
6jBSbph+IrjEqaDTgN9o
=rMvh
-----END PGP SIGNATURE-----

--=-Ra/z5l4G0CsfTi/hSlhD--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
