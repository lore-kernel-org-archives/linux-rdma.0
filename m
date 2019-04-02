From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/8] User space steering
Date: Tue, 2 Apr 2019 11:14:59 +0300
Message-ID: <20190402081459.GM3201@mtr-leonro.mtl.com>
References: <20190331164450.23618-1-leon@kernel.org>
 <20190331140633.33df25a7@cakuba.hsd1.ca.comcast.net>
 <20190401062816.GC8348@mtr-leonro.mtl.com>
 <20190401113221.6fbba319@cakuba.hsd1.ca.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1X+6QtwRodzgDPAC"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190401113221.6fbba319@cakuba.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--1X+6QtwRodzgDPAC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 01, 2019 at 11:32:21AM -0700, Jakub Kicinski wrote:
> On Mon, 1 Apr 2019 09:28:16 +0300, Leon Romanovsky wrote:
> > On Sun, Mar 31, 2019 at 02:06:33PM -0700, Jakub Kicinski wrote:
> > > On Sun, 31 Mar 2019 19:44:42 +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > >
> > > > From Ariel,
> > > >
> > > > This series of patches adds user space managed steering infrastructure
> > > > to the mlx5_ib driver.
> > > >
> > > > User space managed steering requires the means to access a dedicated
> > > > memory space that is used by the device to store the packet steering
> > > > and header modification tables and rules in order to manage them directly
> > > > without the device's firmware involvement. This dedicated memory is part
> > > > of the ICM memory space.
> > > >
> > > > The changes are introducing the mlx5_ib API to allocate, deallocate and
> > > > register this dedicated SW ICM memory via the existing device memory API
> > > > using a private attribute which specifies the memory type.
> > > >
> > > > The allocated memory itself is not IO mapped and user can only access it
> > > > using remote RDMA operations.
> > > >
> > > > In addition, the series exposed the ICM address of the receive transport
> > > > interface (TIR) of Raw Packet and RSS QPs to user since they are required
> > > > to properly create and insert steering rules that direct flows to these QPs.
> > >
> > > Hi Leon!  Out of curiosity what protocols are you guys steering here?
> > > Is this some form of RoCE or IB?  Is there a good resource to read up on
> > > the DEVX stuff? (I presume this series is related?)
> >
> > mlx5 devices steering operates on packets without relation to specific
> > protocol. The decision to steer is based on HW capabilities and user
> > configuration for matching specific fields. Such configuration is done
> > through kernel and through DEVX.
> >
> > General description of DEVX can be found in manuals of libmlx5.
> > https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx5/man/mlx5dv_devx_obj_create.3.md
> > https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx5/man/
>
> Thanks for those, looks quite powerful.  What's your primary use case
> here?  Is there some flow steering and encapsulation going on in RDMA
> world?

Usual use case for that is in RoCE fabric, but as I said it is not
limited to that. For example, flow steering is used in libpcap [1]
and encapsulation is used for efficient VM to VM communication over
different hosts (I assume exactly as in netdev world).

In regarding to this patch set, the combination of this steering
functionality with DEVX allows us to speedup greatly buildup of rules
by doing it in powerful host CPU instead of internal to NIC CPU.

[1]
https://github.com/the-tcpdump-group/libpcap/commit/f5f1484a931851d2d3b67d6033aedea8da5acb42

Thanks

--1X+6QtwRodzgDPAC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcoxoCAAoJEORje4g2clinF2gP/1qoSfJW5I3EOEGfo3iwNdWD
JY99ZHJW3KRc38CjSDx3LgK6jZQ5ZduilVyMWO9Y/W+FLrXmhsTDkY6VzXc2c+JD
GF9HCSjUO6Hr5iliQHTxBWOiaFCdGUkOKhnhGoVntNAsYbHVw98qqtFOwUDPRdwL
2muLRLGXzSdTLOLKCNNITElij98h4laPj9PdwjnoMMYDwptQTqXLLD5b2nwM442n
wa487gd7NjG8VKHHKHTyTKPeJrmMj6bL/ziciPha5L2UoaVrT8RalP2Ix2Ggiin8
jXkG0IyHXGSHmI2AG55LxXgTGq/BB4i/rJNCERTlC1Lb1Gec9dibfHyQ4nJD8Iix
xFUp2kMOv9acGS4VETYSxX+A3g/Zx+r7/95hxKM6/tB2mnZ59AfILnFyAhjvpH3p
7u/0ZATjnzpoFgHQ51RLKc9N1E4LVvHJwtu/Au/ChuM24POuXiXlEzh28WNGRmFj
dPJ3IfBhFk7CEGcix2QlnPfQfxwDJq+IVvEI/Q/3kXaK+SWVFIZrmpsje00jcoJa
lZD07Q9uZ1VdjTdzf6uoNDHJGIvDty/otkFqndurUZWCztvIzeJtlhTt1GXw6Da7
n8Jm+B3JyxkDgxiha5QnTr7IWl0wu47j0wQo6UKhoJ/uRCyMmWDt5OyJif0rnJsC
57Azjyvq8go//Gh+p0TE
=FTPM
-----END PGP SIGNATURE-----

--1X+6QtwRodzgDPAC--
