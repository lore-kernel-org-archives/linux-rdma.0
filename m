From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 07:01:26 +0300
Message-ID: <20160415040126.GB10689@leon.nu>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160414174830.GA11641@rhel.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 14, 2016 at 01:48:31PM -0400, Ira Weiny wrote:
> On Thu, Apr 14, 2016 at 10:45:50AM -0600, Jason Gunthorpe wrote:
> > On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
> > > This patch series removes the write() interface for user access in fa=
vor of an
> > > ioctl() based approach. This is in response to the complaint that we =
had
> > > different handlers for write() and writev() doing different things an=
d expecting
> > > different types of data. See:
> >=20
> > I think we should wait on applying these patches until we globally sort=
 out
> > what to do with the rdma uapi.
> >=20
> > It just doesn't make alot of sense for drivers to have their own person=
al
> > char devices. :(
>=20
> I'm afraid I have to disagree at this time.  Someday we may have "1 char =
device
> to rule them all" but right now we don't have any line of sight to that
> solution.  It may be _years_ before we can agree to the semantics which w=
ill
> work for all high speed, kernel bypass, rdma, low latency, network device=
s.

You didn't ever try to come and work on the solution. We talked about
finite time frame (_months_) which is doable based on knowledge that user
space parts are developed by the same companies and all our future changes
will be in one subsystem.

You were supposed to prepare "wish list" from this new API as an initial
phase. If you do it, you will find that it is very short and in the
initial meeting you will see that it similar to other participants in
linux-rdma community.

>=20
> We need to fix the write/writev problem now.[1]

No, this driver in staging and the proper way to move it out will be to
converge on common API and one clear path instead of duplicating the
interfaces and "inventing the wheel".

>=20
> Ira
>=20
> [1] https://www.spinics.net/lists/linux-rdma/msg34451.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXEGeWAAoJEORje4g2clinc44QAMnH5AKiZKI8oCeiU0UBsBWT
maq1BtHWF4C4KxWAS/bcZcJqu7sldBVDKslxXTFV8DXEuXhNl3mevxQf2BYaRZ+R
mF2jCdWmxcie3anSXrC48h+U/5raZ8jD1pxgQMKSDOOabGcgKkUfjS50elJ+mXkM
JpxyfZhFrGajBxxgjxcPQ/49nuW0acH+3YcJ/Ed6+wTpQuxhv1/n46+lVda+RKH9
uTfnG3tkYpgmSXdX792NNxgNhkV+Yt0F0Jz3wIjgvDT+mCqp5Wzhos3wtwoxxQLL
dhsMmO/snklfgVMO0WF25pbJL5DqAZPZsKLY3d5Wn8pMwtnkMFdsTStPx+197fGq
/CRd6DpQK+5OdSbkZ9DeVyliPIqQdYn1LnzDgtE4e7Q8Cw+g7uEtA78sSEv98blU
/3PBNFHa6CidTkGbYkfYyItt7+STl3GRf1L/agf3sdPnryWYFhkOl3D3iPjKtagc
hiF9hyb2F/jRLFt486ZcJCI5a0jbY3bqh7nCnR02bdAPzNE9pRRJTd9VOmciMpkz
nx0yGsOt+MEU5umGeI7pFt8E7nR05yFXztdWs+rfMqJJiejdQFjNiyp0jTbQXKco
QllBGUVY675+eYbrniTrBl7aRnNs6KhPquP7WShuyA7fyy9vJ4j6o6SgtjMG0HRV
HZnwd1nYZPz57MgVB5TE
=g9LV
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
