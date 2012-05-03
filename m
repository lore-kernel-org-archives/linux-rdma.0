From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: infiniband-diags needs libibmad with
 'mad_dump_mlnx_ext_port_info'
Date: Thu, 3 May 2012 09:51:44 +0200
Message-ID: <20120503095144.708d32a6@b012350-ux>
References: <loom.20120503T081916-361@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20120503T081916-361-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Kniep <c.kniep-Pt+Xe7GJXK+P2YhJcF5u+nqWYbMAw+HU@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


  Hi Christian,

On Thu, 3 May 2012 06:26:04 +0000 (UTC)
Christian Kniep <c.kniep-Pt+Xe7GJXK+P2YhJcF5u+nqWYbMAw+HU@public.gmane.org> wrote:

> Hey list,
>=20
> I just compiled the newest version of libibumad,-ibmad, opensm and
> infiniband-diags and I got an error I am not able to eliminate.
> ####
> checking for mad_dump_mlnx_ext_port_info in -libmad... no
> configure: error: mad_dump_mlnx_ext_port_info() not found.
>         diags require libibmad with mad_dump_mlnx_ext_port_info suppo=
rt.
> ####mad_dump_mlnx_ext_port_info
> My installation on centos6.2 is discribed here:
> https://github.com/ChristianKniep/QNIB/wiki/Installation
>=20
> How could I fix this?

  what does config.log tells you regarding the check for mad_dump_mlnx_=
ext_port_info?

  has libibmad been installed in the standard place? Maybe configure is=
 finding an old
libibmad that's previously been installed (and without mad_dump_mlnx_ex=
t_port_info).

  Also beware of the lib vs lib64 thingy.

  Regards,

  S=C3=A9bastien.

>=20
> Thanks & kind regards
> Christian
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
