From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Tue, 23 Jan 2018 20:57:32 +0200
Message-ID: <20180123185732.GA1393@mtr-leonro.local>
References: <20180123115013.12213-1-leonro@mellanox.com>
 <20180123152142.GB30619@mellanox.com>
 <1516723456.3339.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XLTQE3HqOi3RIrZG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516723456.3339.3.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XLTQE3HqOi3RIrZG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2018 at 04:04:17PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-23 at 08:21 -0700, Jason Gunthorpe wrote:
> > /*
> >  * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for =
dynamic
> >  * initialization and destruction of rcu_head on the stack. rcu_head st=
ructures
> >  * allocated dynamically in the heap or defined statically don't need a=
ny
> >  * initialization.
> >  */
> >
> > The commit that introduced init_rcu_head is
> > 546a9d8519ed137b2804a3f5a3659003039dd49c which suggests it exists only
> > to help the slab allocators, although curiously the allocators never
> > call it these days..
> >
> > Maybe Paul can confirm?
>
> It would be great if Paul could provide feedback. The comment in
> include/linux/rcupdate.h seems to contradict the following paragraph from
> Documentation/RCU/Design/Requirements/Requirements.html for statically
> allocated objects:
>
> 	The corresponding <tt>rcu_head</tt> structures that are
> 	dynamically allocated are automatically tracked, but
> 	<tt>rcu_head</tt> structures allocated on the stack
> 	must be initialized with <tt>init_rcu_head_on_stack()</tt>
> 	and cleaned up with <tt>destroy_rcu_head_on_stack()</tt>.
> 	Similarly, statically allocated non-stack <tt>rcu_head</tt>
> 	structures must be initialized with <tt>init_rcu_head()</tt>
> 	and cleaned up with <tt>destroy_rcu_head()</tt>.

Right, I missed it.

So how are we going to solve that rdma/for-next doesn't compile?

Thanks

>
> Bart.N?????r??y????b?X??=C7=A7v?^?)=DE=BA{.n?+????{??=D9=9A?{ay?=1D=CA=87=
=DA=99?,j=07??f???h???z?=1E?w???=0C???j:+v???w?j?m????=07????zZ+?????=DD=A2=
j"??!

--XLTQE3HqOi3RIrZG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpnhZwACgkQ5GN7iDZy
WKdILxAArs4N0JJmCqNIgvSbUvQH6aa2yLPQzjNeROVfeXNfQDR58mqJlPvRLdIf
DV2xrim53yP5B8vMMK+kPr7NEFRLVl+AfShXzwttCUUkSQcVAEM6U1+dfJnr5grU
cogsBYUWajCao8cdPnnFD0Z06ng3EQlzQoWwm/F5gtkY+95HiH2DbtjZoND8OgkT
Y/rOGcbKjPQ0PRJXuF56/lBsV8LbCvd9iLI111EpZLoIR2Gv0odwgPjiCo5IFiFn
Cg5+vw1idNozrFwqJOYGYSgomf4tRmZsfZ4zJnqBs9TfNLHrpH/thmLQ85r/hUMu
tmv1XNi9Nu/kRFV0dqiQzCAPAQLVcDyrpSXgNnABmZwp4UWdeD8v23/wbGUacGnC
nAi+Rw9n06LVAyNtNPxkbPN9Wn145cpeYz1b5pWjgf3GA7C368F5VkgmnGEFR7l5
ntewtLmV316PtXnWnvzo4+5KwXPwhqJsVwY8Byc5NXF1qnx2ho//NAdHbvX8PdxP
C4L9m8gq02lCsXyuG9R+9qS/7qzzeGFVz6PiyPp5ni8K1/TIHqduSj/Kpm3/Le9q
JF5WHgOebvDCbDexZDLIK05OVyGOt/C+M/cHfn9LKX7SHlhHPcKMO3ginn5Rc2Q0
bpJOBUI4nQQNb7IFt9pT/7dGeNUHqZ6oZNyhVUhYWszKxa8a4eg=
=r0mR
-----END PGP SIGNATURE-----

--XLTQE3HqOi3RIrZG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
