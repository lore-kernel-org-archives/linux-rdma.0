From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Improve ib_map_mr_sg() documentation
Date: Mon, 3 Oct 2016 10:38:00 -0400
Message-ID: <34a7530c-6532-1df9-c34a-aafc3e603dd3@redhat.com>
References: <b75ad680-88e5-e725-80cd-9a0b41bbb2ec@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CWNKlsERc6umuRrKeD2Q9xRe86GsaqKck"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b75ad680-88e5-e725-80cd-9a0b41bbb2ec-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CWNKlsERc6umuRrKeD2Q9xRe86GsaqKck
Content-Type: multipart/mixed; boundary="pmrPL7qKMLqoOhpcKMrmEfLSklLfAD92U";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <34a7530c-6532-1df9-c34a-aafc3e603dd3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Improve ib_map_mr_sg() documentation
References: <b75ad680-88e5-e725-80cd-9a0b41bbb2ec-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <b75ad680-88e5-e725-80cd-9a0b41bbb2ec-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--pmrPL7qKMLqoOhpcKMrmEfLSklLfAD92U
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/26/2016 12:09 PM, Bart Van Assche wrote:
> Document that ib_map_mr_sg() is able to map physically discontiguous
> sg-lists as a single MR. Change IB_MR_TYPE_SG_GAPS_REG into
> IB_MR_TYPE_SG_GAPS.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--pmrPL7qKMLqoOhpcKMrmEfLSklLfAD92U--

--CWNKlsERc6umuRrKeD2Q9xRe86GsaqKck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8m1IAAoJELgmozMOVy/duqwP/jLRP7OVEDRsOirHKx33SCco
e7R3aUOA3z23OrJlQT/g15PGIpHJcq4TT3X0XZmOSZTf2MjIyDUp2hsCCZkzgw1I
gOzxPmozY7iIgFQk9e/amsduf63lOYTPvZ5+2CN11cAAuyPjKSTeMleqFsFjAeLb
wXikv135CoPFWNUgU3cH2XF/K4MJnkLwLg/21Nsl5EFKT0m3sDROyv0XeSZ7t19A
MuDRzkgQVLSXKrkJYcftrttcBkB7U6gcik+4MEOjoW9SlRChE7k24PcMiDKkMtBe
93DiM+UjBTHdhBL2a7ENfodXXRsCbL+toGbAzdIISrH6J/1vhTD6hKTe2Ok6s0mh
33aE6nLlQylLVV6Jt+n9ZJYVaNPBrKYzJjNqnyHcLj1JvBSPAe0FOpRZm1JjUDVq
ovir04NYSOI7hNO7BfUR6k3DmGKn5eJtvL7RM4bs8CFhm5P2ghrGShfP2Zu7MO0+
v4+mz7yKNBBNFcUwJy/LY00btlPza6LUFstEiOhLAiImr+jZqUsiB/pivI48cpFb
gYHUY78KxiA+/3RcB/fvLtalB0h6Jow2wH3PbwJAJwAbqf9L8WrXGdk+CvTDqNFu
ebrSHHsDrA3Ah0+VpRBr6CyUIcaayrGKdys5K5ROaiJLhXBaF3+6jrM4iQ2dasei
4uummhncIS3slkDoOXH/
=mt+g
-----END PGP SIGNATURE-----

--CWNKlsERc6umuRrKeD2Q9xRe86GsaqKck--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
