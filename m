From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v2 00/20] Introduce mlx5 DEVX interface
Date: Tue, 19 Jun 2018 19:46:57 +0300
Message-ID: <20180619164657.GN7557@mtr-leonro.mtl.com>
References: <20180617100006.30663-1-leon@kernel.org>
 <20180618220504.GH6805@ziepe.ca>
 <20180619045930.GA7557@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180619045930.GA7557@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 19, 2018 at 07:59:30AM +0300, Leon Romanovsky wrote:
> On Mon, Jun 18, 2018 at 04:05:04PM -0600, Jason Gunthorpe wrote:
> > On Sun, Jun 17, 2018 at 12:59:46PM +0300, Leon Romanovsky wrote:
> >
> > > Leon Romanovsky (2):
> > >   drm/i915: Move u64-to-ptr helpers to general header
> > >   kernel.h: Reuse u64_to_ptr macro to cast __user pointers
> >
> > I dropped these since they are not needed by this series when using a
> > union.
>
> No problem, it was my idea to reuse existing macro, before it was
> hard-coded implementation, but union makes it cleaner.
>
> >
> > > Matan Barak (5):
> > >   IB/uverbs: Export uverbs idr and fd types
> > >   IB/uverbs: Add PTR_IN attributes that are allocated/copied
> > >     automatically
> >
> > Revised this one, as noted
>
> Thanks
>
> >
> > >   IB/uverbs: Add a macro to define a type with no kernel known size
> > >   IB/uverbs: Allow an empty namespace in ioctl() framework
> > >   IB/uverbs: Refactor uverbs_finalize_objects
> >
> > I put the above in a branch and can apply them if you ack my revisions..
> >
>
> Except the line "return (void *)attr;", which should be "return ERR_CAST(=
attr);"
> everything looks reasonable. I didn't test it, but I'm not worried, we wi=
ll have
> enough time to fix if needed.
>
> > >   net/mlx5_core: Prevent warns in dmesg upon firmware commands
> > >   IB/core: Improve uverbs_cleanup_ucontext algorithm
> >
> > I dropped these two (they are linked), need comments addressed and
> > resent.
>
> They are linked only logically, the second patch will trigger warning
> which is suppressed by first patch. So actually mlx5-net branch will have
> only first patch "net/mlx5_core: Prevent warns in dmesg upon firmware com=
mands"
> and you will apply "IB/core: Improve uverbs_cleanup_ucontext algorithm" in
> your rdma-next.
>
> >
> > > Yishai Hadas (13):
> > >   net/mlx5: Expose DEVX ifc structures
> > >   IB/mlx5: Introduce DEVX
> > >   IB/core: Introduce DECLARE_UVERBS_GLOBAL_METHODS
> > >   IB: Expose ib_ucontext from a given ib_uverbs_file
> > >   IB/mlx5: Add support for DEVX general command
> > >   IB/mlx5: Add obj create and destroy functionality
> > >   IB/mlx5: Add DEVX support for modify and query commands
> > >   IB/mlx5: Add support for DEVX query UAR
> > >   IB/mlx5: Add DEVX support for memory registration
> > >   IB/mlx5: Add DEVX query EQN support
> > >   IB/mlx5: Expose DEVX tree
> >
> > I put these in a branch also and can apply them, but I need the first
> > two patches in the mlx5 core branch first please, thanks.
> >
> > Since this requires so many core patches I think I prefer to merge the
> > mlx core branch then apply rather merge a branch.
>
> So to summarize, I'm applying those three patches to mlx5-next:
>  * net/mlx5_core: Prevent warns in dmesg upon firmware commands
>  * net/mlx5: Expose DEVX ifc structures
>  * IB/mlx5: Introduce DEVX

Updated mlx5-next with two patches and squashed ifc and commands bits
=66rom third commit into second one.

>
> And resend:
>  * IB/core: Improve uverbs_cleanup_ucontext algorithm
>

Resent.

> Thanks
>
> >
> > Jason



--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbKTOBAAoJEORje4g2clinVuIP/RX6Yk1e4Vkm3Cwbic73uY3p
TkwEDt+Rrd3HmplQy8E/REsedpr/Xl3xFbarJ+n6Tsx6Ltvi5f8SZCS6fMKJg4GJ
pUOaEfp64sOgJj5Df23W7GK5em8azsbtQlc0ZlLFmfJjofteU3JfChHfOu3lXzl3
PJsf2AojvJubfhJsyd4rqGLptcf9WTapMWJlFx/kpbYFvWSrLAT3LXxa1XaR8gxi
Qyqb5hxq4oL8mrHH3jZqq0YEu3xOU8znk/5omVYp/+487uU1L2AzNH2LT/p7pr1f
wCOn0umr1K4Xqfn5rJzMz3crzA23lsDCXAT5phn0pnZBykYvNbNJPL7ZAyExA+k1
Ps5WYmtTBnnTYzNNEmlKzF8nByAFjZO+KbI8zxvA6Hb/aQwDNjZaxL+cx79/zU88
6qSNoS9spQb7i0kGjwRxzsV10Q3J4LLKDjTn9hRFSi+qKOSvYYNrK6jpHddIsLgB
/D5YbeweTX2uEvP1XTOM0c+mxgcl457GwC2i+daQIrs/CpjNpGbd4trDLItS/N6x
8jon877yDp6vsGmtmOtyY22UdgdVNwiSgjlA/OztgvI296Z8w3EfG2Vi34choLjd
31KRnzA8bfnrJ9vkGfC0j5L2gA3LdQdH9Bp5olSKr3t6mizOeVMi9juZTF2RZlq4
ELXD1/OBgnaqSIAMpG2p
=sc/W
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
