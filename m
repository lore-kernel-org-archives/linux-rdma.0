From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback
 query_transport()
Date: Fri, 24 Apr 2015 12:00:02 -0400
Message-ID: <1429891202.3356.1.camel@redhat.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
	 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>
	 <553A5362.3040808@talpey.com> <553A54BB.4080902@profitbricks.com>
	 <553A574B.80208@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ry/HXsUrXHW1yAA0GfvH"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <553A574B.80208@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Talpey <tom@talpey.com>
Cc: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-ry/HXsUrXHW1yAA0GfvH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-04-24 at 10:46 -0400, Tom Talpey wrote:
> On 4/24/2015 10:35 AM, Michael Wang wrote:
> >
> >
> > On 04/24/2015 04:29 PM, Tom Talpey wrote:
> >> On 4/24/2015 8:23 AM, Michael Wang wrote:
> > [snip]
> >>> +static enum rdma_transport_type
> >>> +mlx5_ib_query_transport(struct ib_device *device, u8 port_num)
> >>> +{
> >>> +    return RDMA_TRANSPORT_IB;
> >>> +}
> >>> +
> >>
> >>
> >> Just noticed that mlx5 is not being coded as RoCE-capable like mlx4.
> >> The mlx5 driver is for the new ConnectX-4, which implements all three
> >> of IB, RoCE and RoCEv2, right? Are those last two not supported?
> >
> > I'm not sure about the details of mlx5, but according to the current
> > implementation, it's transport is IB without a link-layer callback,
> > which means it doesn't support IBoE...
> >
> > And there is no method to change the port link-layer type as mlx4 did.
>=20
> Hal, is that correct?

The mlx5 Ethernet driver has not yet been submitted to the linux kernel.
Until it lands, the drive is IB only.  When it does land, it will need
to update this area of code.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-ry/HXsUrXHW1yAA0GfvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVOmiCAAoJELgmozMOVy/dI7cQAJvX1Unc7H2fORDvKuUj+Ks9
A1BPKMXtY7WJF+OEyzKMpoXQnI2pouDXqkJM5JaFZeM7bOUw5m0p8wfCKALzpeWK
Z/T4UNgYxuMUZnWwx+Y3NTNkOqP1tOgxhpdfEjJ/hPcIz6kky4M0vU53MYIGKZhg
5q/5YvV6SIbFNuvCyRqwH4orbuR5c/ntR1/84J6QDXJxwRpoZifYvbubcqpBoTFK
j2iZ0aY7ykXCZu6zFRcMBA7LDlPbtTT+YouIE7zOinmZIn+j8hZLeTc3H+3iOH1t
ilfFvR2NPupiEpuTHW6cfmK2bGolGVFBiE93rvp+ThdFBr0yfDXFEbfH5As/tpT/
I4csTVAx5S2GCMy3kkrcLOZ8xrXz770PJahALZswG6gnZrRpawvjAdkfBCtfZg9M
B7By6eqA/bg691V564lhPz4GOw7Nyw0SwAV+yLB50zPhnhysTGGuHVgAQrIVKFva
iEj0jyb6/jmQPlR/1V3YnINfbWqAQeXBgoljBFXfs1Gr6/t9LYapX8vj4q3e9v0H
Zto8aBYXpTsO3KRL4P2h9eACmNlRpZqVh9VXJRvR9gmhPHur7AWp4EMHSgI3Fkb2
b3QbOLdWuxPXhlj/d/58YGFnNFJKhTlgAxreSjuRr/tspbNDDznkAarIuRqN0VmW
muOhjJtugTWEMqypUzmE
=GHLi
-----END PGP SIGNATURE-----

--=-ry/HXsUrXHW1yAA0GfvH--
