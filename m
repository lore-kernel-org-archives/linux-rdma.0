From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Wed, 24 Jan 2018 08:43:37 +0200
Message-ID: <20180124064337.GB1393@mtr-leonro.local>
References: <20180123115013.12213-1-leonro@mellanox.com>
 <20180123152142.GB30619@mellanox.com>
 <1516723456.3339.3.camel@wdc.com>
 <20180123220337.GE3741@linux.vnet.ibm.com>
 <1516746545.3339.46.camel@wdc.com>
 <20180123225054.GK3741@linux.vnet.ibm.com>
 <1516748369.3339.59.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Cou6PmgoyP0+llr2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516748369.3339.59.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Cou6PmgoyP0+llr2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 23, 2018 at 10:59:30PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-23 at 14:50 -0800, Paul E. McKenney wrote:
> >
> >     rcu: Fix init_rcu_head() comment.
> >
> >     The current (and implicit) comment header for init_rcu_head() and
> >     destroy_rcu_head() incorrectly says that they are not needed for
> >     statically allocated rcu_head structures.  This commit therefore
> >     fixes this comment.
> >
> >     Reported-by: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
> >     Signed-off-by: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 043d04784675..36360d07f25b 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -214,10 +214,12 @@ do { \
> >  #endif
> >
> >  /*
> > - * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
> > - * initialization and destruction of rcu_head on the stack. rcu_head structures
> > - * allocated dynamically in the heap or defined statically don't need any
> > - * initialization.
> > + * The init_rcu_head_on_stack() and destroy_rcu_head_on_stack() calls
> > + * are needed for dynamic initialization and destruction of rcu_head
> > + * on the stack, and init_rcu_head()/destroy_rcu_head() are needed for
> > + * dynamic initialization and destruction of statically allocated rcu_head
> > + * structures.  However, rcu_head structures allocated dynamically in the
> > + * heap don't need any initialization.
> >   */
> >  #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> >  void init_rcu_head(struct rcu_head *head);
>
> Thanks!
>
> Feel free to add:
>
> Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
>
>

Paul,

Are you going to send it through your tree?

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--Cou6PmgoyP0+llr2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpoKxkACgkQ5GN7iDZy
WKeguBAAvUNhjxhrYpbHP2GjwORxHqFJCVh/A/yuODoCc7QePiOytgYvZ9p9iqC7
u69JtM+Ev882S43PHVQIkQIoNd2Y7DS3XswlFrw0UEownD95iTkDDfvXTLJGP1+S
RY+Tkv9e01JiCTVIfOYtvEwRwf5BLUic9iBGkbtJkNA6xPZNkw84aZZ08fTUTHf0
7xLL8qeoR+SRhvMMSe5uYHmVUlvAN+c5buvHqFo5aXsnH3EVd7eSagWSN3Thvl8n
j+03uXkJ4B5VKUA22ia9dLseeYtxiTYvIE4dBYqqwAGWJMGsg/tfvp0Kjq+957Sb
EJfIJ1sjePYSY9k8fDHhH3Rmfn9cwNv28Ln4k+Ho5Wwva8f3f7B64oTZqm50HXE6
xu8OiwX/osvAnI2FLFv/SA7XMiTVig8QQn/jFu+HpetpjehWnUFB/mac5ab9JkU0
LBwkpxB6HpLupmKipGPKj8ZZQ9YoYqubNAxVnCKAnyrckjo0TZwQQwgkUx4CqMLV
EtqVzijGX4xFYz+prLmZ2olpNOpj1tZ8OYby66TGmuQJFDgenClQVjJGe2mSAz9O
YaEcDKgoEOtWRBxuihhEszrB4L8nHnkxpTwLNVX6UcuvoBV6xvAm+Gbv4iTYqSkk
YI08BzEuQx/zSQZT4S9psp3nSIKGb/g9iFYSim/5BLbO7HCKgss=
=1zYW
-----END PGP SIGNATURE-----

--Cou6PmgoyP0+llr2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
