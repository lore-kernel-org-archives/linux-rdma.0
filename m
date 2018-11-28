From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 22:08:44 +0200
Message-ID: <20181128200844.GQ4559@mtr-leonro.mtl.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
 <20181128182645.GJ4559@mtr-leonro.mtl.com>
 <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
 <a55d4291-7c60-dc64-54ef-5ffaf60ed2e6@opengridcomputing.com>
 <20181128200204.GO4559@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2OzUYMsT4j3Kc+NU"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128200204.GO4559@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org


--2OzUYMsT4j3Kc+NU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 10:02:04PM +0200, Leon Romanovsky wrote:
> On Wed, Nov 28, 2018 at 01:34:14PM -0600, Steve Wise wrote:
> > ...
> >
> > >>> +	rd_prepare_msg(rd, RDMA_NLDEV_CMD_NEWLINK, &seq,
> > >>> +		       (NLM_F_REQUEST | NLM_F_ACK));
> > >>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, name);
> > >>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_LINK_TYPE, type);
> > >>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_NDEV_NAME, dev);
> > >>> +	ret =3D rd_send_msg(rd);
> > >>> +	if (ret)
> > >>> +		return ret;
> > >>> +
> > >>> +	ret =3D rd_recv_msg(rd, link_add_parse_cb, rd, seq);
> > >>> +	if (ret)
> > >>> +		perror(NULL);
> > >> Why do you need rd_recv_msg()? I think that it is not needed, at lea=
st
> > >> for rename, I didn't need it.
> > >> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/tr=
ee/rdma/dev.c#n244
> > > To get the response of if it was successfully added.=A0 It provides t=
he
> > > errno value.
> > If I don't do the rd_recv_msg, then adding the same name twice fails
> > without any error notification.=A0 Ditto for deleting a non-existent
> > link.=A0 So the rd_recv_msg() allows getting the failure reason (and
> > detecting the failure).=A0
> >
>
> Shouldn't extack provide such information as part of NLM_F_ACK flag?
>
> just shooting into the air, will take more close look tomorrow.

OK, it was easier than I thought.

You are right, need both send and receive to get the reason.

Can you prepare general function and update rename part too?
Something like send_receive(...) with dummy callback for receive path.

Thanks

>
> Thanks
>
> >



--2OzUYMsT4j3Kc+NU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb/vXMAAoJEORje4g2clinFxMP/jVtMr5Ctybv8vLv3mmK3oZD
1eYJ/nA9MgbQrF57taFSA07xn3BO0vahV8iXuNIYPnZ1zOmwkAwgw7ILfcl1nlDY
7vEXOSzSA+2Rl+A3R3w6wKSy6GuKGVTUT8ibeS7BDrRzw8z0QRAuS+NgR7A2k4HI
jvL4URUl+FSHCMCzby/kEYa+FeMMWHChbOjOOFIPrOaoNLGxtNAjEhsVxQUwbnfV
aHOUR0H7YXYSPidGsluzip4T9E6n+A9EQt4GMw2Yo83n4O0+3B6vvqQBRDoW2BXp
osroqgNwQ3k7Q+5b3Up0+woBtgGUZOzPLAHaXvowie1e90QTIsmptLVsP+yN3VSR
ADcu+o5Ksn7WTLWHa1av/Me4sDQtZDBpXkrV9dsQjia+NJl/ZjlwYJuAozZLLsnv
u5EVMmdXbb8lQEzdysfzDANq2WorFRIzJh3OokbmgLg+y/xuvyy/uLic7/yN7WR+
KpT9qbbm/fRiimVjXnHBlrVCT+jSi6aW+ruGZZ8M2RUvAriesTtf5T0tcO7nC05v
AhlH3dzXlHFyCY9pOxN1iXv5Zg1M1eciNVxGvyt+bcEzNc1MVv98OS+1g7tUxIWT
UC9tEGaqlrWOjG3xwhdP4C552NqcZwh1rNzSe4h6N2YrKAfbWW13BSMV2TnPoaGV
u24V5BwTFhYKKFhyuPlQ
=JK2q
-----END PGP SIGNATURE-----

--2OzUYMsT4j3Kc+NU--
