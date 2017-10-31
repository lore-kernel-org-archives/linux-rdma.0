From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Tue, 31 Oct 2017 07:08:02 +0200
Message-ID: <20171031050802.GE16127@mtr-leonro.local>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
 <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca>
 <20171030152815.GA16127@mtr-leonro.local>
 <20171030155236.GC12392@ziepe.ca>
 <20171030190952.GC16127@mtr-leonro.local>
 <20171030230753.GB4081@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1XmnKQGVLLNJnMip"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171030230753.GB4081-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1XmnKQGVLLNJnMip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 30, 2017 at 05:07:53PM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 30, 2017 at 09:09:52PM +0200, Leon Romanovsky wrote:
>
> > However, I don't think that kernel to libibverbs API should follow the
> > same path. The centralized entry points to the kernel provides better
> > enforcement and minimizes system call bloat.
>
> How so? I didn't think selinux intersected with the CQs at all..
> I've never worried about the # of verbs entries, we have so many
> already.

Not SELinux enforcement, but various copy_{to|from}_user checks, unified
return values, easy folding in case of errors, e.t.c.

It is a matter of personal view and less technical thing. You prefer bazillion
entry points to the kernel and I think that such design good for user-space only,
and mostly not applicable for kernel<->user interfaces.

>
> I also don't like the modify semantic, because IMHO, modify should
> mirror create, and we don't specify the moderation parameters during
> create.

It is completely different thing, no one needed it, so no one added it.

>
> Jason

--1XmnKQGVLLNJnMip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln4BTIACgkQ5GN7iDZy
WKc+VQ//QuEsaZLCaB06PQbsOZb/UqaDdKpRDMS70Iz0Up93J3qs3qHQuzjuFWkQ
qIu/9OSV1sJBkmHGVjQTDpz2S1SORX5G44CCPyntxOWHKyCEQXcYR3KfWitnsyNY
ngQQJ+8ikEpEBllt0BNno2W8xvh7UDVtQuYdYjomEN8wGuh1Ei227Qg3yXhbN0tP
q7wn4jq9PWllnuLPZItPvo9lqS87tk/Ij6DovikNeDypNgnVTtLNLRC5LZOLUsRF
U2yN6FWvlBypSW2aJUu9SYW3gMlH9KODdSWBDXaSwU7LY/LZ88dNpMLIz6uO7rDm
+rXhAB46yg3/KisndrrsBkryUIrwF9ZA0Kx5MkS8ZPZEcLKYT4Bg4xuNycGFTSPn
Oawzgh8QuuXh6KJf4lKEJXy6zBlLPff1yCqLewS4x9+w0VyZ23TkK0gopUJgVX4R
JpoZPRANNZO/QPLuAfC47m7dGApKmCz+vP6EnxzzlQvKkqJPdvhbOwI6NkO+vG4h
s6zX30CIJdusnQxOJdPCymdc6PM2H3FyP+AtWIoSTCLa+JJMHpEqFvKjLtPY5t3H
DVBuCVTCfz+caer9g/IrySt3Scr5Rn3LjcJN+sXiwyKLVz45reqf2wtmmTWWL4wT
yDyLxzj7zuC8LEC9f1q8jDZhxb7kIYhTwubtL+K9jXggfUDMfH8=
=qGee
-----END PGP SIGNATURE-----

--1XmnKQGVLLNJnMip--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
