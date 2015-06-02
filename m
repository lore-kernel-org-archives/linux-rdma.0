From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Tue, 02 Jun 2015 15:56:02 -0400
Message-ID: <1433274962.40123.17.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <20150601164322.GA14391@obsidianresearch.com>
	 <1433255724.114391.225.camel@redhat.com>
	 <20150602180844.GD17776@obsidianresearch.com>
	 <1433271083.40123.1.camel@redhat.com>
	 <20150602190410.GA23362@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-K7NuuJk+Sl4sEdKdF4zn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150602190410.GA23362-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-K7NuuJk+Sl4sEdKdF4zn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-02 at 13:04 -0600, Jason Gunthorpe wrote:
> On Tue, Jun 02, 2015 at 02:51:23PM -0400, Doug Ledford wrote:
> > On Tue, 2015-06-02 at 12:08 -0600, Jason Gunthorpe wrote:
> > > On Tue, Jun 02, 2015 at 10:35:24AM -0400, Doug Ledford wrote:
> > >=20
> > > > So, just so everyone is clear on this point: the current user space
> > > > implementation of this feature creates an unversioned, newly named
> > > > ibv_wc_ex struct that is ibv_wc with a 64bit timestamp tacked on at=
 the
> > > > end (not 64bit aligned either).  If we ever wanted to have a differ=
ent
> > > > extension to our ibv_wc struct, there is no good way to do that.
> > >=20
> > > No, if they followed (I didn't check yes) the extension scheme then t=
he
> > > poll call is
> > >=20
> > >  struct ibv_wc_ex wcs[num_wcs]
> > >  ibv_poll_wc_ex(&wcs,num_wcs,sizeof(wcs[0]));
> > >=20
> > > And the drivers decide what to do based on the 3rd argument, which is
> > > essentially the ABI version.
> >=20
> > Ick.  OK.  I would *much* prefer something done akin to the routines in
> > packer.c of the kernel, but that's not my call to make, the decision on
> > the ABI/API extension mechanism was made long ago.  It does, however,
> > mean that extensions are serial and not modular, and that's a shame.
>=20
> All verbs extensions are essentially serial, each extension requires a
> fixed allocation of structure bytes, made by upstream.
>=20
> This is also why no vendor may ship an extension that is not upstream
> and continue to use the same soname as upstream. Similarly for the
> kernel.
>=20
> This is fairly performance neutral, while a packer.c scheme would be
> unacceptably expensive, IMHO. poll_wc is one of the most performance
> sensitive routines in the library.

I disagree.  Obviously I haven't run them in a tight loop to confirm,
but I looked at mthca, mlx4, and cxgb4 user libraries, and all of them
have complex *_poll_one routines that convert their internal cqe's to
wc's.  The packer routines aren't any more complex or any slower (at
least not necessarily, it all depends on the particular transformation
needed).  The packer routines are just hard to read.

And, as Christoph pointed out, we can keep our wc in a single cache line
right now.  However, we only need a few extensions to blow that out of
the water.  If some extension comes along that gets allocated past the
64byte cacheline size, and that extension is used far more frequently
than say this timestamp, then we will have forced a cache line break on
a frequently used item for a less frequently used item.  So, there would
be benefits to a modular approach in terms of allowing the user to
select what items they want and to keep their important items in that
single cache line.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-K7NuuJk+Sl4sEdKdF4zn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVbgpSAAoJELgmozMOVy/d2c8P/0ODRAikl7Bm35l48sG0A99z
rJuH1WSNZiAeeCQLa/1sjbvJlX6Kt+huqvdHfEgN6CTofcIw3bIzihpXPeiEI310
QFyLfVEMfhHBuW3HwscnEhluSjdlqPZtfYDwZ0PeFQqFyvwV+/Sd4SoJxLYtWRq1
lHGaxE8eMU88vcz0MNlD87UdW/5wwIimasJ/PEo1V5u8QzozX6tfwfPUAOJ+GZOD
GuwhIvVaxWgPCVa35xNszUzb+juf7MnbpmxIA6cLM/wBPi+F5REN4/rNEklwvpCX
B2POsnouvlY1OcQ+xIV7PgNkz6REkU9xH7W8FmVQt7AEkhELa+R0YQL9CMUx7Nrt
lqDeSN4OYdKX6s3zvmubbRIY5w2+vSqddbrd648Y04K84JQnxz4BRNoD7mFGeoM4
1t/SHYKAKu9XFfMzno+zoL3xErpIpFhxGxHUkbBCaZ8scVtBf2LrqcwKSxrl7Xyn
A7E9zKz1mmadQHaIjb8HC9YahgF5MOE1G/ReQkvYn9Otcud1olP75x3dX8mGDlhX
8YzRMZ8hbDd24GDgvJCfvDTPa9SrdiHIYpQ4UgZvlpiAWDGeqGd3SIjSl8dBcSdD
ws38bnonqdmp/t8pZ9cEEkiNoXdpKwvhsJUM9nfVtNWnvB3OZVtlhMILUaAv7fal
kYmzc8CfHIAdlDAegZux
=LlkI
-----END PGP SIGNATURE-----

--=-K7NuuJk+Sl4sEdKdF4zn--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
