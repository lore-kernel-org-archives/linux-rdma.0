From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Thu, 7 Mar 2019 10:33:02 +0200
Message-ID: <20190307083302.GM1789@mtr-leonro.mtl.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
 <20190223092615.GM23561@mtr-leonro.mtl.com>
 <11ec7e04-1bff-e3b2-1b89-db134cd537ba@opengridcomputing.com>
 <021201d4ceda$56d9e560$048db020$@opengridcomputing.com>
 <20190303135052.GY15253@mtr-leonro.mtl.com>
 <007901d4d294$62d5d280$28817780$@opengridcomputing.com>
 <b487f61e-d9a7-0151-51f5-25f79597a2fa@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LZFKeWUZP29EKQNE"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b487f61e-d9a7-0151-51f5-25f79597a2fa@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--LZFKeWUZP29EKQNE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 06, 2019 at 03:50:13PM -0600, Steve Wise wrote:
>
> On 3/4/2019 8:13 AM, Steve Wise wrote:
> > Hey Leon, adding this to rd_recv_msg():
> >
> > @@ -693,10 +693,28 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback,=
 void
> > *data, unsigned int seq)
> >                 ret =3D mnl_cb_run(buf, ret, seq, portid, callback, dat=
a);
> >         } while (ret > 0);
> >
> > +       if (ret < 0)
> > +               perror(NULL);
> > +
> >         mnl_socket_close(rd->nl);
> >         return ret;
> >  }
> >
> > Results in unexpected errors being logged when doing a query such as:
> >
> > [root@stevo1 iproute2]# ./rdma/rdma res show qp lqpn 176
> > error: Invalid argument
> > link mlx5_0/1 lqpn 176 type UD state RTS sq-psn 0 comm [ib_core]
> > error: Invalid argument
> > error: No such file or directory
> > error: Invalid argument
> > error: No such file or directory
> >
> > It appears the "invalid argument" errors are due to rdmatool sending a
> > RDMA_NLDEV_CMD_RES_QP_GET command using the doit kernel method to allow
> > querying for just a QP with lqpn =3D 176.  However, rdmatool isn't pass=
ing a
> > port index in the messages that generate the "invalid argument" error f=
rom
> > the kernel.  IE you must provide a device index and port index when iss=
uing
> > a doit command vs a dumpit command.  I think.

QPs are per-device and not per-port, so I can't issue "real" port on
multi-port devices.

> >
> > This error was not found because rd_recv_msg() never displayed any erro=
rs
> > previously.  Further, the RES_FUNC() massive macro has code that will r=
etry
> > a failed doit call with a dumpit call.  I think _##name() should distin=
guish
> > between failures reported by the kernel doit function vs failures becau=
se no
> > doit function exists.  Not sure how to support that.

We can suppress prints from failures to find .doit, by adding extra
parameter to _res_send_idx_msg(): for example _res_send_idx_msg(..., no_err=
or_print);
and provide this "no_error_print" to rd_recv_msg(), through "void
*data".

> >
> >
> >         static inline int _##name(struct rd *rd)
> > \
> >         {
> > \
> >                 uint32_t idx;
> > \
> >                 int ret;
> > \
> >                 if (id) {
> > \
> >                         ret =3D rd_doit_index(rd, &idx);
> > \
> >                         if (ret) {
> > \
> >                                 ret =3D _res_send_idx_msg(rd, command,
> > \
> >                                                         name##_idx_pars=
e_cb,
> > \
> >                                                         idx, id);
> > \
> >                                 if (!ret)
> > \
> >                                         return ret;
> > \
> >                                 /* Fallback for old systems without .do=
it
> > callbacks */ \
> >                         }
> > \
> >                 }
> > \
> >                 return _res_send_msg(rd, command, name##_parse_cb);
> > \
> >         }
> > \
> >
> >
> >
> > The "no such file or dir" errors are being returned because, in my setu=
p,
> > there are 2 other links that do not have lqpn 176.   So there are 2 iss=
ues
> > uncovered by adding generic printing of errors in rd_recv_msg()
> >
> > 1) the doit code in rdmatool is generating requests for a doit method i=
n the
> > kernel w/o providing a port index.
> > 2) some paths in rdmatool should not print "benign" errors like filteri=
ng on
> > a GET command causing a "does not exist" error returned by the kernel d=
oit
> > func.
> >
> > #1 is a bug, IMO.  Can you propose a fix?
> > #2 could be solved by adding an error callback func passed to rd_recv_m=
sg().
> > Then the RES_FUNC() functions could parse errors like "no such file or =
dir"
> > when doing a filtered query and silently drop them.  And functions like
> > dev_set_name() would display all errors returned because there are no
> > expected errors other than "success".
> >
> > Steve.
> >
>
> Hey Leon, you've been quiet. :)=A0=A0 Thoughts?

I missed your email, sorry.

>
> Thanks,
>
> Steve.
>
>

--LZFKeWUZP29EKQNE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcgNc+AAoJEORje4g2clincREQAJhjX2qPnmVjkAAhmmOI3/2n
BQ8FYKqrj17kFKe0UbtHTCn+Lc+QMrBOScj53dukC7hZec7EgEvtsviYStNYi66H
Ej46ZedneQvvqMIcCgyP/my7coOFO0Bxey7CYSvYi5H7cXQ2UX+4886Ri8ELnJPd
HawGC8gHs4OiG16wWMxrGWfKAM9CAIhulqKmo2miBGKUcHGI83AvQ/T+CFRRSgBL
4EreimvnCK/PpeKUR3yeaY5LA3IWFlpzvGJ99pJUnJ+1iZDar/QRrSIV2Pp05Sjr
JkhMUc3+BNx93RaAnRTG10A6LSQEclroL8xy6sUy634j5ixb7kBd6NERzC2YEXoh
f14c4pLncyI4BavigsPDXDZC7Eg15lA8IomBUx9k2EOORAOYquys3tY1GdVuDCof
syiC/y6bBfTXSuhW6j/ytBiPfDGZnuTgo4rVe0Qt5lID8JDy6NNXRX1DmyDlXILl
Nq+EpJ22+Vo6amL34e32bG+w2a5rfL6gnyBICAB1u62kjwmhoX+OOubNNEdoT3Hr
67NbaP1BhScmZ2EJ85f5ORGVdWoaMTfiFhBmkG0V588cTZeXeqvtMSleOmbPSe58
0CGUyZ2fF/WhiC63VVfbSS6rfaImXvmgDaIn9p7ysjOdXJypCmJXUCKFkMVLHa0F
Mv339YqlWt19asclhFlt
=YI/5
-----END PGP SIGNATURE-----

--LZFKeWUZP29EKQNE--
