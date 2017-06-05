From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Mon, 5 Jun 2017 20:32:30 +0300
Message-ID: <20170605173230.GQ6868@mtr-leonro.local>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <1496674541.7171.168.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4ZQ/M1iA+qg8otEW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496674541.7171.168.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4ZQ/M1iA+qg8otEW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 05, 2017 at 10:55:41AM -0400, Doug Ledford wrote:
> On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> > On Wed, May 31, 2017 at 07:04:37AM +0300, Leon Romanovsky wrote:
> > >
> > > 2. The commit cea05eadde broke NETLINK semantics for whole RDMA.
> >
> > How did it break? What's the issue?
>
> As I understand it, and I'll let Leon correct me if I'm wrong, the rest
> of the linux kernel's NETLINK interfaces all have a standard they
> follow:
>
> When you open a netlink socket, it is by default asynchronous and non-
> blocking. =A0In order to have it any other way, you must issue the
> standard libnl commands to switch the socket to the other behavior.
> =A0Leon's argument is that because of the problem iw_portmapper was
> having, instead of adding the 3 or 4 lines to iw_portmapper so that it
> would issue the necessary and typical calls to libnl to change the
> socket semantics, this patch changed the default symantics for the RDMA
> subsystems netlink sockets.
>
> The point, then, is that this is not normal accepted practice for
> solving a problem. =A0Normally, you would fix the user space application.
> =A0If someone is used to programming network side netlink interfaces, and
> they then get a new job and end up programming rdma side netlink
> interfaces, they are going to find this difference confusing, to say
> the least. =A0We will have broken the normal netlink API for the RDMA
> subsystem in the name of not fixing a broken user space application.
>
> Does that summarize your argument Leon?

Thanks Doug,
And to add, it is not only NETLINK_RDMA behaviour vs. all other NETLINKs.
It is inconsistency inside NETLINK_RDMA family too. iWARP portmapper is blo=
cking,
while rest is non-blocking.

>
> FWIW, I would take this issue very seriously. =A0Having a default netlink
> socket that behaves one way if it happens to belong to the network
> subsystem and a default netlink socket that behaves another way if it
> belongs to the RDMA subsystem is just flat wrong. =A0We should never
> create an ambiguous API like that. =A0And if we broke it and made it
> ambiguous, then it absolutely needs fixed.
>
> > >
> > > 3. The commit cea05eadde made libnl library (basic block of user-
> > > space part of netlink)
> > > to work incorrectly and not according to _blocking/_nonblocking
> > > semantics.
> >
> > How? Is libnl calling ibnl_unicast? As far we can understand
> > ibnl_unicast is only called
> > by portmapper kernel code.
>
> Let's not forget that Leon is working on a new tool, similar to the ip
> command from iproute2, for configuring the rdma subsystem. =A0Feedback
> has already established that it needs to be done all via netlink. =A0So,
> the RDMA subsystem's current use of netlink is but a drop in a bucket
> compared to what it will be and where it's going. =A0It is highly likely
> that Leon stumbled across this issue as he was working on this tool and
> started needing to deal with the RDMA subsystem's netlink support.

Right,
And I started from refactoring and cleaning the code.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/rdmatool-rfc-v1
Currently work in progress and I'm trying to minimize "the damage" as much =
as possible, but future work
will include delete of a lot of dead and useless code in iwarp (the whole r=
egistration logic is complete
trash and can be replaced by very small number of lines), introduce nla_pol=
icy to support properly
annotated netlink attributes, get rid of custom functions to build messages=
 and many more.

>
> > > 4. Reverting is a common practice in Linux kernel. Patches are not
> > > carved in stones.
> >
> > Reverting a patch that's introduced during RC cycle is fine,
> > introducing
> > regression is NOT and that is what you are doing by simply proposing
> > to revert
> > this patch.=A0=A0Reverting this patch will introduce a REGRESSION error
> > with respect to
> > port mapping functionality for all iWARP vendors.
>
> Reverting buggy patches, however, is not considered a regression, but a
> bug fix. =A0This is a bit of a special case in that, if Leon's arguments
> are right, this is both a bug fix and a regression. =A0It means that
> there might need to be a flag day to push out a new, fixed
> iw_portmapper to people, followed by the revert. =A0But just because
> buggy code is in use does not mean it gets to stay in use.
>
> > >
> > > 5. I proposed a solution -> go and fix your user space program.
> > This is a kernel patch you are trying to revert, you are breaking
> > existing
> > kernel functionality.=A0=A0Nothing to do with user space.
>
> It absolutely has to do with user space. =A0If this is an issue that
> should have never been fixed via kernel space in the first place and
> should have been resolved in user space all along by making
> iw_portmapper treat the RDMA netlink socket just like any network
> netlink socket would need to be treated, then Leon is right,
> iw_portmapper needs fixed and this needs reverted.
>
> > Bottom line, come up with a solution that will address both port
> > mapper
> > functionality and your issue.
>
> No. =A0If he's right (and I plan to investigate whether he is) that the
> normal netlink socket semantic is asynchronous and non-blocking by
> default, and you normally use libnl commands to migrate the socket to
> blocking/synchronous once the socket is opened, then this patch will
> eventually be reverted and you absolutely need to fix iw_portmapper.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD
>

--4ZQ/M1iA+qg8otEW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk1la4ACgkQ5GN7iDZy
WKdUAA//bgIn3DBCR1326QjJhjSzOvtKIHj1qL7lLd5yYBRAOs6kzshBGbJNCMZH
KiPdw4828s1SPHBbjD5zOfbjeg2dsVvktrMfDKqE/5DXGWIooALtidBn7KSl9yh1
H789JwAaLBX0yrTjuL/H8Pdc2ZIcwFZG+lcjkk5scqtNVq/SlMoCMdx3wDsJZLPX
h0z1t6iM9fyc7hU8Y8hTlFHuLMMxDgs5BJ9vdfLKNUonXwAGrxe/913VGtQ46EwQ
aj1jhUM/b3YMTKHwPjHbq1uvetEXNtiPF+2Ay0zd/dT62TjIKC/BYhue5KJ7nx8D
rxp04my2k/udzwFXwyPdsZyp3bmhZ39SfR5iO8UgOW+hxafd0bRE7ywpK3mUT0lB
D0FDA+pZ/HOYozEI9z7pxiMSKCPvJ0ujoFpaZRgn+rPhRYOJQy9DGVqSRoI9y5Qn
cWv+O8eXiLlDmthTUpUWOzr5mnDs9IlnrzZIzMOFs/qi1WE8Ausaz7DEjUbAPgP0
E9MhOpFIloVsApsguCK3BKWlYkaZQXyPHGV7cRaORVhZUIQwlFJwmySqA1KUksiI
E4NGVJLJNfKR502GAfBKfY+XWXcQsai5QDBnXChsf3rp8gWcXjLHGouEaYwkZ3oY
vLW/Nf049nOJFR95LYrppAUqUybig1+z75nYT6walc/qflTbeb4=
=TXT2
-----END PGP SIGNATURE-----

--4ZQ/M1iA+qg8otEW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
