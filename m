From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] cxgb4: fix undefined behavior in mem.c
Date: Fri, 01 Mar 2019 09:26:59 -0500
Message-ID: <d796cd9bea794179136b869218dcad5755380029.camel@redhat.com>
References: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
         <1551394596.31902.209.camel@acm.org>
         <abf425b1-19ba-9cf5-8288-87ac0dbf6ac7@cs.utah.edu>
         <1551396788.31902.213.camel@acm.org>
         <a03cc0b7-c508-4937-f2dc-c5f9dbc356ba@cs.utah.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CuL6LvVFcXB6UHBrbjN8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a03cc0b7-c508-4937-f2dc-c5f9dbc356ba@cs.utah.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaobo He <shaobo@cs.utah.edu>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org
Cc: Steve Wise <swise@chelsio.com>, Jason Gunthorpe <jgg@ziepe.ca>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-CuL6LvVFcXB6UHBrbjN8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-02-28 at 16:57 -0700, Shaobo He wrote:
> Good catch. But if we agree on that memory management functions are those=
=20
> specified by the C standard, would it be OK to ignore so-called use after=
 free=20
> or double free bugs for the kernel as C standard does not apply to kfree?

No, most kernel use-after-free bugs are real bugs.  This one might be
technically a bug by certain readings of the standard, but it's a non-
issue.  Real use-after-free bugs don't just look at the value of a local
stack variable to get the memory's old address (which is what this does,
and the same could be achieved and be totally in spec by doing this:

    old_ptr =3D mhp;
    kfree(mhp);
    pr_debug("%p\n", old_ptr);)

Real use after free things would actually dereference the pointer to
either read or write from the old memory region.  That leads to data
corruption or kernel data leaks.  Plus, in this case, the purpose of
printing the literal value of mhp is simply to provide a unique name for
tracing purposes.  Since kfree() doesn't alter the local stack variable,
the name is still present in the local stack variable at the point you
call pr_debug().

It could be fixed.  It's not like this patch is wrong.  But I wouldn't
submit it this late in the -rc cycle, I'd just take it for next.

> On 2/28/19 4:33 PM, Bart Van Assche wrote:
> > On Thu, 2019-02-28 at 16:18 -0700, Shaobo He wrote:
> > > I can't afford a pdf version of the C standard. So I looked at the dr=
aft version
> > > used in the link I put in the commit message. It says (in 6.2.4:2),
> > >=20
> > > ```
> > > The lifetime of an object is the portion of program execution during =
which
> > > storage is guaranteed to be reserved for it. An object exists, has a =
constant
> > > address, and retains its last-stored value throughout its lifetime. I=
f an object
> > > is referred to outside of its lifetime, the behavior is undefined. Th=
e value of
> > > a pointer becomes indeterminate when the object it points to (or just=
 past)
> > > reaches the end of its lifetime.
> > > ```
> > > I couldn't find the definition of lifetime over a dynamically allocat=
ed object
> > > in the draft of C standard. I refer to this link
> > > (https://en.cppreference.com/w/c/language/lifetime) which suggests th=
at the
> > > lifetime of an allocated object ends after the deallocation function =
is called
> > > upon it.
> > >=20
> > > I think maybe the more problematic issue is that the value of a freed=
 pointer is
> > > intermediate.
> >=20
> > In another section of the same draft I found the following:
> >=20
> > J.2 Undefined behavior [ ... ] The value of a pointer that refers to sp=
ace
> > deallocated by a call to the free or realloc function is used (7.22.3).
> >=20
> > Since the C standard explicitly refers to free() and realloc(), does th=
at
> > mean that that statement about undefined behavior does not apply to mun=
map()
> > (for user space code) nor to kfree() (for kernel code)?
> >=20
> > Bart.
> >=20

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-CuL6LvVFcXB6UHBrbjN8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlx5QTMACgkQuCajMw5X
L90zKBAAnEDp8f+HIkyz0HdZ5XufXwatwzmTO8hSmTd6V2eQaMCJrir+DEBFyTjT
CQ+aL4sMovylM7mRl9t7VlHkRQRWq5082AFEnd9LHkoe5CdGfWJnExrS+4A9nWeO
gJ0c4CMcumdHiAp8DmADt67xc3ZWV9KluT2VYzv58o60SDOQ2q+PtNL801MqCwJ4
XkLKsvXtPTHrOA2cK1biIOmGHWPB8uzBkUWu6jIjw06uZ771YJqa0zdmOGYTPt2Y
ZPitgGplUVmGZejT6pSJ5sIsbNEOxmd97/I5PA26JcBUCyO34L/44PN4peIvyGIX
drnK9FbFv3XdwBUX4KkvaLWVAdzsferROv22WeO+b2DcA2NTkDfgr8U/cLtW2aJF
G447MFJhPMg/gQdLBmLq8yaLImkDw619PqEC7oi41zNgWlXykjAOAHyyihTIPcqY
q+LXNcMYJkaUvuw0MJRdIhbDoPPysIlJ4t39tM44mAlfztUP2F3xeQ5Ca/xy3t7S
LfhVtpiUrweQl4ZWLWiGJ73HOKy4UT+fm4YXfPZNEdnd8DR+5TKtMrodxUt1QKTL
Vob9asY78umFoh842I2krYCHo1wAx1z0XjqQ4ahL26CDSbwoF3pk6Gx/+ZwUP/5j
39nOO86w19xajkisX/AvO8cLdaYkxSA/B/0q24nHQKPJeJfFQRc=
=SctM
-----END PGP SIGNATURE-----

--=-CuL6LvVFcXB6UHBrbjN8--
