From: Doug Ledford <dledford@redhat.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 06 Feb 2019 15:28:35 -0500
Message-ID: <a8dc27e81182060b3480127332c77ac624abcb22.camel@redhat.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
         <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
         <20190206175233.GN21860@bombadil.infradead.org>
         <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
         <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
         <20190206194055.GP21860@bombadil.infradead.org>
         <a9df9be75966f34f55f843a3cd7e1ee7d497c7fa.camel@redhat.com>
         <20190206202021.GQ21860@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-T+TkLa3nZqw/GpqDXqzy"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206202021.GQ21860@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-T+TkLa3nZqw/GpqDXqzy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-02-06 at 12:20 -0800, Matthew Wilcox wrote:
> On Wed, Feb 06, 2019 at 03:16:02PM -0500, Doug Ledford wrote:
> > On Wed, 2019-02-06 at 11:40 -0800, Matthew Wilcox wrote:
> > > On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote:
> > > > though? If we only allow this use case then we may not have to worr=
y about
> > > > long term GUP because DAX mapped files will stay in the physical lo=
cation
> > > > regardless.
> > >=20
> > > ... except for truncate.  And now that I think about it, there was a
> > > desire to support hot-unplug which also needed revoke.
> >=20
> > We already support hot unplug of RDMA devices.  But it is extreme.  How
> > does hot unplug deal with a program running from the device (something
> > that would have returned ETXTBSY)?
>=20
> Not hot-unplugging the RDMA device but hot-unplugging an NV-DIMM.
>=20
> It's straightforward to migrate text pages from one DIMM to another;
> you remove the PTEs from the CPU's page tables, copy the data over and
> pagefaults put the new PTEs in place.  We don't have a way to do similar
> things to an RDMA device, do we?

We don't have a means of migration except in the narrowly scoped sense
of queue pair migration as defined by the IBTA and implemented on some
dual port IB cards.  This narrowly scoped migration even still involves
notification of the app.

Since there's no guarantee that any other port can connect to the same
machine as any port that's going away, it would always be a
disconnect/reconnect sequence in the app to support this, not an under
the covers migration.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-T+TkLa3nZqw/GpqDXqzy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlxbQ3MACgkQuCajMw5X
L91JAw/9F0R0dhIpoufg7KCt9PVbxs+Zf+ATyyHACVuBgEp7bmf0eIeWtvf/ZVKh
t7dUajXxI6xmrdnRtqvZxkU/z4ics4jUlTnXDt1NmcsO1AtnaE0iRzShBaldkKf9
LPjnfZbkdzY+RZwdIU/C9ZOvOSg2fKrCsc2xeNuEloRi6doo4MHZvakmmI3xW27k
lAl3L34KpR9Lz3Isu2MeUN+KHemKbSXYRxwKy7JlhexXLCN7jnclGC9kfL1dTJRc
WuA2FCOaj4obvMglF/LRHPCWT0k5kAOcuPLhR7r/3sR9tDcMiPJZZtqFe/SLzG8Y
Xdiy1I11Mj1+wnp5n5rZLpfVgBo29F4uo5J2zJUdGpgH113IiJMCxn3Jz986Aix5
7Ad3rzNOthv2uHEusH0XtUBd2mROVSYhk/jNNJUzZBn4N5C/1Jm/H/7dP8aGI0SS
5ZKs3o23JqOQXv5q0j0woHPIusX0RfIBftLDr9ofnHBvDvbME5PQSuhdgDu7vv5c
gMQBUHVM8vAc0fnD9j/EH8hrnAcrXrxAaIrVuR6X4dHE6hVRj1c2fFkNlu34I0+c
9bTiVIwwMc0jwHoEtwF0MgW4Wci3qBmVVOjfeSyml8FIZaPt4XNFTRSj95TGi/9v
f9gGewTehWp/nHJq5svV8R+6SF9/H/gTVEYwNIK9Li6pFoNShoU=
=Q1pC
-----END PGP SIGNATURE-----

--=-T+TkLa3nZqw/GpqDXqzy--
