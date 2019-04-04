From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 00/12] Move IB representors to single IB device
 multiple ports
Date: Thu, 4 Apr 2019 20:42:38 +0300
Message-ID: <20190404174238.GC3201@mtr-leonro.mtl.com>
References: <20190328132742.12070-1-leon@kernel.org>
 <20190404130221.GA15890@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yTwVabqJa5IUz21H"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190404130221.GA15890@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--yTwVabqJa5IUz21H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2019 at 10:02:21AM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 28, 2019 at 03:27:30PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > >From Mark,
> >
> > Hi,
> >
> > This series starts from two refactoring patches performed in mlx5_core
> > and they are part of a larger series intended to expose the ability
> > to insert FDB steering rules by the RDMA side.
> >
> > They are followed by patches which move IB representors to single IB
> > device. Currently when moving to switchdev mode an IB device is created
> > per virtual function (and one for the uplink). While initially this was
> > right approach, the limitation of this model requires us to change it.
> >
> > Such limitations includes:
> >  - Inability to share resources between IB devices.
> >  - Lack of DEVX to allow more control and device specific functionality.
> >  - Interacting with the E-Switch.
> >  - Doesn't work well with namespaces.
> >
> > In this series we move to a single IB device with multiple ports where
> > each port represents a different virtual function (port 1 is for the
> > uplink). All the limitations listed above are now resolved and the
> > software model exposed to users is more cohesive.
> >
> > Thanks
> >
> > Mark Bloch (12):
> >   net/mlx5: E-Switch, don't use hardcoded values for FDB prios
> >   net/mlx5: E-Switch, add a new prio to be used by the RDMA side
> >   RDMA/mlx5: Move netdev info into the port struct
> >   RDMA/mlx5: Free IB device on remove
> >   RDMA/mlx5: Move ports allocation to outside of INIT stage
> >   RDMA/mlx5: Use correct size for device resources
> >   RDMA/mlx5: Move rep into port struct
> >   RDMA/mlx5: Move default representors SQ steering to rule to modify QP
> >   RDMA/mlx5: Refactor netdev affinity code
> >   RDMA/mlx5: Move SMI caps logic
> >   RDMA/mlx5: Move to single device multiport ports in switchdev mode
> >   RDMA/mlx5: Remove VF representor profile
>
> This looks Ok, can you update the shared branch please

Thanks Jason,

I'll slightly delay update till Sunday, internally, we have doubts about
"RDMA/mlx5: Use correct size for device resources" patch.

Thanks

>
> Jason

--yTwVabqJa5IUz21H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcpkINAAoJEORje4g2clin6hAP/3FoAKd/nCicCMGzLaQICDKk
hneuwbc5DeoW8yyxreD7yIdc0kZFHz6C+YNcKM0WEwJqseeDFfS4NoiDrpqUTbPx
B21yYCyD+IvVjJ1lOFxCoSdRC45erKSMwLPWLj1U/HIMq/0AoV0qrkwFNU36KNBU
FqZ7ZiEQH9CAUu5K3f0cAlMmYIH2oySfT9qo72wOm9Bs/hA9jhCYYEI36ONQA64x
KLMdAq58V5G3GbBeVf+PIIE2bkky9Su670l9aRDNf118knmf1MCJUxg3llhqeGt+
aINI6bHLHuAQCmpDzlelZaFcwCVoPDCBQjhD1hiFHg5CQozZDlJvAN9ydsWjk+P0
RYjoV/dfVVwafRRNMCENA+Gh9QOnITUmkNBl06UXIeMLM4Q7gOmLXE9kK/25nzJm
4BtqxVNvg5h1bAS7eO4lhpT/LRePr2r+adE8iVe5ggcj4VuHRj/lJd3T7cHnWhBu
nLkp+VGRI32bH/MCn9w2+BfGgzyALifW0t8GY67g5iVmwTWpfPdrQTWZ69a+W2qI
HRfOPcAx12pugLYLpIGr9hoPwShY6qEbcWRPNRXKBQX9wflzsa7lrYXbHhTlCz7d
X9HW3bU3JW/IQXbcZIKTMQL4qzJZ/FKbMcmb+V9XSYQgjtnaT97/PcA9Bsynpg1C
hxSRfVI7iv3ALFUxmXUB
=y02s
-----END PGP SIGNATURE-----

--yTwVabqJa5IUz21H--
