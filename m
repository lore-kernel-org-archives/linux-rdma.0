From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Fri, 29 May 2015 12:59:27 -0400
Message-ID: <1432918767.114391.110.camel@redhat.com>
References: <CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com>
	 <20150526185315.GF11800@obsidianresearch.com>
	 <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com>
	 <20150526220724.GC4502@obsidianresearch.com>
	 <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com>
	 <20150527184856.GA16059@obsidianresearch.com>
	 <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
	 <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com>
	 <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org>
	 <20150528162416.GA6515@obsidianresearch.com>
	 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-bcAlm51vzXvGaS/tgTPu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1505281212330.1711-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-bcAlm51vzXvGaS/tgTPu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-28 at 12:14 -0500, Christoph Lameter wrote:
> On Thu, 28 May 2015, Jason Gunthorpe wrote:
>=20
> > After a quick look through, the biggest question in my mind is what
> > should the timestamp value in the wc be?
> >
> > Right now it is some coded thing in clock cycles.
>=20
> This is sufficient since it can be converted to ns or whatever one wants.

It is sufficient for your use.  It is not, however, a good API.

> > Should we require the driver to convert to ns before passing the wc
> > back to the app? (Looks like the socket implementation uniformly uses
> > us or ns)
>=20
> But that requires additional processing.

Yes.

> > Should the app open code the conversion from clock cycles to ns, or
> > vfunc down to the driver?
>=20
> The API provides the abilty to retrieve the clock freq which is
> sufficient for the user to convert the value to meaningful time values.

I would prefer if the access to the timestamp were implemented via a
function in libibverbs (I haven't looked at the git repo, too little
time, I'll get to it).  Something like ibv_get_cqe_timestamp().  That
function should be general and return a suitable, normalized value (ns
probably).  If you just want a simple comparator without the overhead of
normalizing to time, and are willing to accept the consequences of that,
then I would expect you to use something like
ibv_get_raw_cqe_timestamp() to get the unadulterated cycle counter.  For
the most part, the user space application should not know details like
"we are using a cycle counter in the HCA processor for timestamping",
that's below the level of abstraction we attempt to maintain at the
verbs level.  Libmlx4 should be the only thing aware of that fact, and
it talks to the mlx4 driver in the kernel to get the details it needs.
And by putting it into a function that libmlx4 implements, if libcxgb4
decides to implement timestamps and does it in a different way, the app
doesn't care, it just uses the same call.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-bcAlm51vzXvGaS/tgTPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaJrvAAoJELgmozMOVy/dVBcQAJtKMW7zMAdnWl/zSLspL03e
Vw6U661bC+4OxWFTbTFditWu+9xUvhuLgMmr0fpRE+wBIVGbn3308MoN935reaD6
TQuAJhDWDw6LgP6J9AATKDQX+1ieT/lqkfOaBjRaagxC3bKYIh3BFch9kqVXqKKk
78OIwKiN5QwYDxUQHrvbmssW/qYG5vXAvRJ5IDz9lKcPwb3zJFmbg0X+JF39oUW6
WhQESsbZr0YTbNJDzjHMDa+2H6ijvaalYsIyGqhBlQuhT12/jx/heAweG1+2RzEu
KrItitQbuPMOs8ELD8Zm1nMtKod6Ty8EhLxluzbf3IUNzkbcZpyM47K9zSkEKy5V
j2Uu/JGtpH89vv4aVnp+niFlKr+p14UsmqelBh0Tq3+v2cHhiE6BP+8CsCORjTSR
IuKp2RWNp8ToIXnJiQnuy0XZo932mbKT5aHukMHtIPD2Yl5p3Rc8nK6T87M8mUQR
9K7FowYMPaBU0CF7VmyI4ePdRQ8K/1ImzbKEydRviKHNZnNA60KrFYRaAqMe4hcL
Be31RuO5phuBw02cz5h4vMpVopTONIG168pYWizOzpJkUUz+Iv+V8sncgm08UClf
Sq2c8XsX5y1Jz7hBS9PFcHaLB/hQhURGWXxwgWeER2V0WUm6dpo8j6W2+JJ1qNdO
iUYsMk2Opeh0WlDFiMoS
=2KJZ
-----END PGP SIGNATURE-----

--=-bcAlm51vzXvGaS/tgTPu--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
