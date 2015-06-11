From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Thu, 11 Jun 2015 00:49:59 -0400
Message-ID: <1433998199.71666.144.camel@redhat.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
	 <55769561.8000300@mellanox.com> <5577FAFB.8020205@mellanox.com>
	 <20150610150010.GA11243@obsidianresearch.com>
	 <557852EE.5030107@mellanox.com>
	 <20150610184954.GA26404@obsidianresearch.com>
	 <1433984788.71666.78.camel@redhat.com>
	 <20150611035727.GA16599@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-e8NzYwlLB9+sS6FTHTBN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611035727.GA16599-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-e8NzYwlLB9+sS6FTHTBN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-10 at 21:57 -0600, Jason Gunthorpe wrote:
> On Wed, Jun 10, 2015 at 09:06:28PM -0400, Doug Ledford wrote:
>=20
> > People tend to push the "patches should be small, self contained,
> > incremental" ideal.  In some cases, that gets carried to an extreme.  I=
n
> > this case, patch 1 introduces one side of the locking and patch 3 and 5
> > introduce the other halves.
>=20
> I already did spot check patches 3 and 5 for exactly that. They add
> other uses of RCU, but they appear to be totally different -
> objectional for style reasons, but probably not incorrect.
>=20
> For instance the rcu lock grabs in patch 3 and 5 are protecting the
> call to netdev_master_upper_dev_get_rcu in patch 10. 'get_netdev' is
> more correctly called 'get_netdev_rcu' in this design. (as I said, this
> placement of rcu_read_lock is ugly).

Without going back to review it, I was thinking that patches 3 and 5
were related, but the rcu locking in the remaining patches were related
to core netdev rcu locking that is irrespective of what we do in the
roce gid table.  But, that just underscores my other point: we need the
patches that implement all of the relevant rcu locking for the gid table
ndev in the same patch.

> .. and just searching through the patches for 'rcu' to write this, I
> noticed this:
>=20
> +void ib_enum_roce_ports_of_netdev(roce_netdev_filter filter,
> [..]
> +	down_read(&lists_rwsem);
> +	list_for_each_entry_rcu(dev, &device_list, core_list)
> +	     ib_dev_roce_ports_of_netdev(dev, filter, filter_cookie, cb,
> +					    cookie);
> +	up_read(&lists_rwsem);
>=20
> Should't call list_for_each_entry_rcu under a rwsem, this is just left ov=
er
> from the old locking regime...
>=20
> > > I think you've got the right basic idea for a cleanup series here. It
> > > is time to buckle down and execute it well.
> >=20
> > Except that this isn't really a cleanup, and calling it that clouds the
> > issue.
>=20
> Well, I've been asking for a cleanup .. The entire goal is to make
> things more reviewable and a no-functional-change cleanup would sure
> help that..

In this case I'm not sure that's entirely realistic though.  Due to the
fact that the mlx4 driver and the ocrdma driver had their own gid
management code, there were some distinct differences between the two.
The gid at index 0 never matched up in my testing for example.  One
supported bonding, the other didn't.  Even if you tried to limit things
to a cleanup, you would still end up altering behavior of both drivers
just because the cleanup would have to merge the two implementations and
the result would be different than either one of them.  So I don't think
there is any such thing as a no-functional-change cleanup possible here.
Now, they could have went minimal, but instead they went "create new
implementation that is supposedly done right and standardized, then
switch existing drivers over to it" with some dubious rcu locking.

> > it. But that's not the case.  The new core code implements everything
> > that the two drivers do, and then some more.
>=20
> I'd be interested to see a list of the 'some more' included in the
> patch comments, I didn't look with a fine toothed comb, but not much
> functional stood out to me...

I get the impression that a lot of the extra is scalability changes for
perceived need (probably due to upcoming namespace/container additions).
But, just to be fair, the entire mlx4 gid code was -500 lines and
included bonding support.  The base gid code addition was +500 for the
gid table, +600 for the table population functions, +170 for default
gids, +290 for bonding support, and +140 lines to hook it into the
existing cache routines.  While part of this might be would seem to be
the over-designed locking, part of it is probably exactly as Matan said,
code growth due to generalization and standardization.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-e8NzYwlLB9+sS6FTHTBN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeRN3AAoJELgmozMOVy/dfKUP/0nSlmRQk9uiw56fAM9ZK6bx
9qtXtBYG0PINvOiiGZ9+iErIpvlAGzSoVuJizNSdIWBP2j66i6i06pQ1US5Pxrlf
j6xBJZUqFJlvlQToFfCCoY5vO9CaiipErF3tG7rdlVMJapIHR6/GKsC+BNe/XuXn
RcL4Dr1BDxwoW3V5iwtxL6kJYvPJIkrFixMjK9lMAv7ECHKLlzfSqOY6UPSKAiUH
/Q1JrPeYN8qkQgT+PHekwLq+O0ganqH5nlfysUqQi0HanhsTrnT3YyLFjbYGLLFg
5l0TcI3kJXBiPuZ/+iv7d5DaHy+GnpO4vpGOjiwzPIStOS6yoUM1pSCZeOnZtM17
4IDKRoof+AIBxoEvlgu2tE8Jl2b6r8XVSin1tZwiq7qe69S90cTtzgYO1m1dOWRN
gPo14ytuVzSiITdKxqFl/ojhDfwTydMkeNNBuugAdZfv5kJHtwqSEfvrBgii1sbM
UKtmoH8PHl1BokPzFAH9bZCAoM1WvdPDWDwxn8XGHj7Epd9GRT4jnNjBjVP2561n
9LwXGd3w3utS/lNu/IbtXGx7960o+Fhsisqu50swyapTUCktrgC7vGvX2iAxyMfS
QZMJoGABb7Dt9hnHZBzj7KefKd+gXdTZjPBdsesG7rol4ODPwSU7UVPFdFv03GdK
5x/lTSjAc0aLl1up7iPe
=on4H
-----END PGP SIGNATURE-----

--=-e8NzYwlLB9+sS6FTHTBN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
