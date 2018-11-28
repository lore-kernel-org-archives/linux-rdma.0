From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 22:02:04 +0200
Message-ID: <20181128200204.GO4559@mtr-leonro.mtl.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
 <20181128182645.GJ4559@mtr-leonro.mtl.com>
 <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
 <a55d4291-7c60-dc64-54ef-5ffaf60ed2e6@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6THr7QwYWIbrk6Kt"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a55d4291-7c60-dc64-54ef-5ffaf60ed2e6@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org


--6THr7QwYWIbrk6Kt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 01:34:14PM -0600, Steve Wise wrote:
> ...
>
> >>> +	rd_prepare_msg(rd, RDMA_NLDEV_CMD_NEWLINK, &seq,
> >>> +		       (NLM_F_REQUEST | NLM_F_ACK));
> >>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, name);
> >>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_LINK_TYPE, type);
> >>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_NDEV_NAME, dev);
> >>> +	ret =3D rd_send_msg(rd);
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	ret =3D rd_recv_msg(rd, link_add_parse_cb, rd, seq);
> >>> +	if (ret)
> >>> +		perror(NULL);
> >> Why do you need rd_recv_msg()? I think that it is not needed, at least
> >> for rename, I didn't need it.
> >> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/tree=
/rdma/dev.c#n244
> > To get the response of if it was successfully added.=A0 It provides the
> > errno value.
> If I don't do the rd_recv_msg, then adding the same name twice fails
> without any error notification.=A0 Ditto for deleting a non-existent
> link.=A0 So the rd_recv_msg() allows getting the failure reason (and
> detecting the failure).=A0
>

Shouldn't extack provide such information as part of NLM_F_ACK flag?

just shooting into the air, will take more close look tomorrow.

Thanks

>

--6THr7QwYWIbrk6Kt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb/vQ7AAoJEORje4g2clinHbIQAJ3Jgb+1N7E58S71fxov/aH7
mwnB0EkZ/Lv0XKvZZ7bFKbgvg285fKdtPp/Fm7ODydQZfmSPYWlhDFjZtfAbECGm
7AnNgAcbR23ZpJUSpF58LC8YR/VNQW+Brq1IWv+Iz/Pc+HsdXnMjkR7l8FJ+pSz2
2IJuPuuCBshlYVA3vrKD0Il4681+pEJiraukHgMFF6xii1zhA75VjU6tHXyclWfl
UeEB9KE7uMXEBE8lo/cqDCPMSOcfimu879ioNN4nt93PELhFq8dLKzmqxvABXP9E
AvPaZ98W/OOICczze6dBAeHyDFagrUPM8V185Bym5JVwmIcgVzXlcFjskYgvn6rN
R23ddB241bbm5tRs1LsYb98gCEpNUJTOSedNItsFfADofRwcAOR2I8LQDaRAP00t
I460P0UfHDfIqreHw2qU7/7mPXSxJA0QM4vT4FgvLW1cnYbYxkyrhHueyr4ltyAm
MVDgcteO6H0nqwZfJZGci+zCh5cPfFtg6DVDur+DUVtFqrUeJvAJyvob0Z/cY9wH
gCeqt9iqZMqFN2W5fxlmYdJpEiDEMjaCcr00Wm9HiVLnZvpWE6154hZclJCA5r/x
y5FJXgRjgVTDmYHtB4rPXfPemmZhvF7NNTteJBOScMLsnBHuCmHbG/DxHzMxu8E4
eSgvwAYo1o7UAvxGzLzp
=RJ6R
-----END PGP SIGNATURE-----

--6THr7QwYWIbrk6Kt--
