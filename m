From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Wed, 13 Jun 2018 10:36:53 +0300
Message-ID: <20180613073653.GC3275@mtr-leonro.mtl.com>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
 <20180612203322.GG6314@ziepe.ca>
 <20180613000739.GA32191@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613000739.GA32191@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2018 at 05:07:39PM -0700, Matthew Wilcox wrote:
> On Tue, Jun 12, 2018 at 02:33:22PM -0600, Jason Gunthorpe wrote:
> > > @@ -377,13 +378,24 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
> > >  		goto error4;
> > >  	}
> > >
> > > -	spin_lock_irq(&port_priv->reg_lock);
> > > -	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
> > > +	idr_preload(GFP_KERNEL);
> > > +	idr_lock(&ib_mad_clients);
> > > +	ret2 = idr_alloc_cyclic(&ib_mad_clients, mad_agent_priv, 0,
> > > +			(1 << 24), GFP_ATOMIC);
> >
> > I like this series, my only concern is this magic number here, at the
> > very least it deserves a big comment explaining why it
> > exists..
>
> Yes, you're right.  Maybe something like this ...
>
> /*
>  * The mlx4 driver uses the top byte to distinguish which virtual function
>  * generated the MAD, so we must avoid using it.
>  */
> #define AGENT_ID_LIMIT		(1 << 24)
>
> ...
>
> 	ret2 = idr_alloc_cyclic(&ib_mad_clients, mad_agent_priv, 0,
> 			AGENT_ID_LIMIT, GFP_ATOMIC);
>
> > Let me see if I can get someone to give it some test time, I assume
> > you haven't been able to test it it?
>
> I don't have any IB hardware.  Frankly I'm scared of Infiniband ;-)

I took it for regression, reliable results will be after -rc1 only.

Thanks

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbIMmVAAoJEORje4g2clinhC0QAKb9tFYihLRWT+2+/JJMEyZZ
blKKXZgQlxNnKWUNAn5iQhwsXNrQrmXR9S2nxKuVIenIrUrig57FG1ULp7jttsFq
qXiCIrYgHU78nvMmQnr78Xkjstm2EBkmKFnLWjVyPuDYp/IsJgcq4/q7lSu8gSAK
VMYrAkEQUD6k+oegXaiKLsLpMVIiU3VNSQvNA6+mJm3VWUI640sWRWiPuAo8KXsw
FqpS2dSMKVM+LLRpV1Xqtl+3HpvgL4rPHra+HXfQqbpNpDBwWsPa538DCFFp+Ep6
1F+6OsiD/m1xIZntX0hMNueUKEkNeEgI7nSJJC+PUb1BstOVQ2Z0W6+YmrX0XqyZ
Xc3I5kfyWmtvdulwGl4OatBiLzfj4ni6Wdj47+JF9r0b2beVJYj9rBJlUtRBAK5w
XwHqSfkh97F7S62609E376lsMgUiVIQ/4NfWFP/ESES5LeVtMr0jVNsaV9EIzzZs
3y3llRC1qM9p7iVFuM8Gbx2dL+eS0eUbQq4h84sLziNRK81ws2k0A49iLeRKk6ZJ
z91VT1FzT4K5KcRRRrtO3OXaEy/vbT3frtJUxEwuyxF2VHUahyZNvJSfkxY9LEUJ
32RyvQQZs6sQRZUcdsd8+zC51RIAUtoOsWRNbmC7R0E+MNbjf4Gg7IW9GIimtPTg
cP1PlC2rxb0gyIfawXUK
=1UG0
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
