From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: infiniband-diags needs libibmad with
 'mad_dump_mlnx_ext_port_info'
Date: Thu, 3 May 2012 10:59:56 +0200
Message-ID: <20120503105956.0f32a657@b012350-ux>
References: <loom.20120503T081916-361@post.gmane.org>
	<20120503095144.708d32a6@b012350-ux>
	<4FA247ED.2030702@science-computing.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FA247ED.2030702-Pt+Xe7GJXK+P2YhJcF5u+nqWYbMAw+HU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Kniep <C.Kniep-Pt+Xe7GJXK+P2YhJcF5u+nqWYbMAw+HU@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 03 May 2012 10:55:09 +0200
Christian Kniep <C.Kniep-Pt+Xe7GJXK+P2YhJcF5u+nqWYbMAw+HU@public.gmane.org> wrote:

> Salut S=C3=A9bastian,
>=20
> omg, I am stupid... :)
> Found the bad files:
> /usr/lib64/libibmad.so
> /usr/lib64/libibmad.so.5
> /usr/lib64/libibmad.so.5.1.2
>=20
> 'yum erase libibmad' solved my problem.

  OK good. I've already been bitten by this kind of thing.

>=20
> Merci

  De rien ;)

  S=C3=A9bastien.

> Christian
>=20
>=20
> Am 03.05.2012 09:51, schrieb sebastien dugue:
> >=20
> >   Hi Christian,
> >=20
> > On Thu, 3 May 2012 06:26:04 +0000 (UTC)
> > Christian Kniep <c.kniep-Pt+Xe7GJXK+P2YhJcF5u+nqWYbMAw+HU@public.gmane.org> wrote:
> >=20
> >> Hey list,
> >>
> >> I just compiled the newest version of libibumad,-ibmad, opensm and
> >> infiniband-diags and I got an error I am not able to eliminate.
> >> ####
> >> checking for mad_dump_mlnx_ext_port_info in -libmad... no
> >> configure: error: mad_dump_mlnx_ext_port_info() not found.
> >>         diags require libibmad with mad_dump_mlnx_ext_port_info su=
pport.
> >> ####mad_dump_mlnx_ext_port_info
> >> My installation on centos6.2 is discribed here:
> >> https://github.com/ChristianKniep/QNIB/wiki/Installation
> >>
> >> How could I fix this?
> >=20
> >   what does config.log tells you regarding the check for mad_dump_m=
lnx_ext_port_info?
> >=20
> >   has libibmad been installed in the standard place? Maybe configur=
e is finding an old
> > libibmad that's previously been installed (and without mad_dump_mln=
x_ext_port_info).
> >=20
> >   Also beware of the lib vs lib64 thingy.
> >=20
> >   Regards,
> >=20
> >   S=C3=A9bastien.
> >=20
> >>
> >> Thanks & kind regards
> >> Christian
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
