From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 04/15] IB/pvrdma: Add functions for Verbs support
Date: Tue, 23 Aug 2016 15:07:21 -0400
Message-ID: <1cf44765-31e5-9621-7156-409c3bbb1b06@redhat.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-5-git-send-email-aditr@vmware.com>
 <20160823151341.GA10264@yuval-lap> <20160823184322.GM15065@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NarjGCi4qJKxepng6xD16uvQlejh8qcEo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823184322.GM15065-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NarjGCi4qJKxepng6xD16uvQlejh8qcEo
Content-Type: multipart/mixed; boundary="KVUquBUnrhMUWhdth9kjVs8ckeDNJlM8p"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org,
 georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Message-ID: <1cf44765-31e5-9621-7156-409c3bbb1b06-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 04/15] IB/pvrdma: Add functions for Verbs support
References: <1470266864-16888-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
 <1470266864-16888-5-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
 <20160823151341.GA10264@yuval-lap> <20160823184322.GM15065-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160823184322.GM15065-2ukJVAZIZ/Y@public.gmane.org>

--KVUquBUnrhMUWhdth9kjVs8ckeDNJlM8p
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 2:43 PM, Leon Romanovsky wrote:
> On Tue, Aug 23, 2016 at 06:13:42PM +0300, Yuval Shaia wrote:
>> On Wed, Aug 03, 2016 at 04:27:33PM -0700, Adit Ranadive wrote:
>>> + */
>>> +int pvrdma_query_port(struct ib_device *ibdev, u8 port,
>>> +		      struct ib_port_attr *props)
>>> +{
>>> +	struct pvrdma_dev *dev =3D to_vdev(ibdev);
>>> +	union pvrdma_cmd_req req;
>>> +	union pvrdma_cmd_resp rsp;
>>> +	struct pvrdma_cmd_query_port *cmd =3D &req.query_port;
>>> +	struct pvrdma_cmd_query_port_resp *resp =3D &rsp.query_port_resp;
>>> +	int err;
>>> +
>>> +	memset(cmd, 0, sizeof(*cmd));
>>> +	cmd->hdr.cmd =3D PVRDMA_CMD_QUERY_PORT;
>>> +	cmd->port_num =3D port;
>>> +
>>> +	err =3D pvrdma_cmd_post(dev, &req, &rsp);
>>
>> Patch order again, this guy is added in patch 7/15 ("IB/pvrdma: Add de=
vice
>> command support").
>> Maybe it is only me having trouble to read it so do not want to be a n=
agger
>> here but don't we have some (hidden) agreement that each patch is atom=
ic
>> and i should be able to compile the kernel after each one?
>=20
> IMHO, Doug will squash all these patches to one a second before adding
> it into his tree. The patches divided here for easy review.
>=20
> Thanks
>=20

Indeed.  When adding a new driver, the separation for review is handy,
but bisectability is best maintained by a squashed commit.  I like to
have a good cover letter page for using as the squashed commit's log
message when I do that.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--KVUquBUnrhMUWhdth9kjVs8ckeDNJlM8p--

--NarjGCi4qJKxepng6xD16uvQlejh8qcEo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvJ7pAAoJELgmozMOVy/dx6AP/ioIZ9dKVF4TgizycvF5xSwr
rNAS5SrtuFOKmz9BxknPlq2j6fFUXZppjEi1Q5YoNunxJdlMm0m4M7H7ZOz18jI4
HBOGFz5uExN4TbH9x15eZeRpCi5qvl4+lu3RSka3X+RuKwarrelznGfP4xoheOEd
qfaJxwxL7frGjDXqoJGY5spLjzM8yupmOo15w225gF2/PP/ZDvIGXzc9OaW65DOj
J3m20zsJ05Z30xJfgmgKA/sgq4i7NlFDdsUzDIQpanENGzSiCrAlfqpM7ieTP+fT
D2QwAfFR3Ze7WHqkmt7GXjGXE53MWO8zvmI/QjVM2vLFp9wgY9WUcL3SNEbRZ6S6
KyNvZIqk9KnwcyB+seZwPupPDo7MFEJUuQ5R1D43ZGzpCUA+4ey5WiTtoTrJHTF7
4sHRXxPTHbo1C06GT6Wq0hhPC2Xz9UKwxQAUH70NO2Mdu8mj/7nhckZrTVJ/CGQr
l28F7YZrjEQwOa56lPVGAqomZqWUYnhPd/IwEf8t21xd3pai8qHzfbmZsl2Cu6RZ
4WOyqTsrx1N3NF1w/hctgm8txvAzHHoypgTP90hwWYBgFpSassSeC+2r/VI8v3dx
T/rvzo4eiyX17kyISdOtdfcF6vsORezBCMQ7l9DZbyUQRVdd1o/LoDGtng8B+2FB
vAMWtode27WsvUzr18Ch
=6aGa
-----END PGP SIGNATURE-----

--NarjGCi4qJKxepng6xD16uvQlejh8qcEo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
