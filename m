From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/7] IB/srp: Second series of patches for kernel v4.7
Date: Thu, 12 May 2016 14:44:04 -0400
Message-ID: <0dc43faf-18d4-15e2-2e10-fd4a0447d501@redhat.com>
References: <5734C181.2020003@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SV4uv4uv610a5dR56ArJq2AfwipS7Cq73"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5734C181.2020003-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SV4uv4uv610a5dR56ArJq2AfwipS7Cq73
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/12/2016 01:46 PM, Bart Van Assche wrote:
> Hello Doug,
>=20
> Since the first eight patches of the patch series "[PATCH 0/11] More SR=
P
> patches for kernel v4.7" have already been applied I'm reposting versio=
n
> two of the reworked remaining patches. These patches are:
>=20
> 0001-IB-srp-Print-ib_srp-prefix-once.patch
> 0002-IB-srp-Fix-a-memory-descriptor-leak-in-an-error-path.patch
> 0003-IB-srp-Fix-srp_create_target-error-handling.patch
> 0004-IB-core-Enhance-ib_map_mr_sg.patch
> 0005-IB-srp-Swap-two-code-blocks-in-srp_add_one.patch
> 0006-IB-srp-Prevent-mapping-failures.patch
> 0007-IB-srp-Do-not-register-memory-if-never_register-has-.patch
>=20
> The changes compared to v1 of this patch series are:
> * Fixed a bug in patch 4/7, the patch that modifies ib_map_mr_sg().
> * Added code that checks how many data has been mapped in patch 6/7.
>   This code can be enabled and disabled dynamically via the dynamic
>   debug mechanism.
> * Added a seventh patch that introduces the never_register parameter.
>=20
> This patch series is based on Christoph's RDMA read/write API rework
> patch series.
>=20
> A git tree with these patches is available at
> https://github.com/bvanassche/linux/commits/srp-initiator-for-next.
>=20
> Thanks,
>=20
> Bart.

Thanks Bart, these have been applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SV4uv4uv610a5dR56ArJq2AfwipS7Cq73
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNM70AAoJELgmozMOVy/d2U8QALjVCOrLZTcY1048SId49rBU
roYHTIgRw8+9LEz5Sq6vSTuay1ZJmjk3+VnhZImJRsxvUjCDbJGQmFgimOyqNGBS
QWJAHmiXoDojEV2J70n14+xMtbxAIin24GWWbh95RFsmfXrEo93xYRVbnTwV2a+t
PoMpFs3uO8UtrBq15v0AqadIHWZ8EzTS6CHInrbpQ5s0MXMIjXRM8zNAhAyGQ3Dn
fnLFImPo/HZOtHiXdjYKnDPn8yTcz+sJYSZtKdUHXOG0PSyqN7fPDUuZdzD80ZdB
MOxK90TeopsFNnNMIS+WKxLr7emugsTJnwhSgMQzaaDKPQXFhW1AnbhaO+UsCEkO
s7psNmwNeZ8HpOBkmZyRDGu9yjbWf8oe4AAFc2wkJUrXpx8dLUGHNzidJ6Ge5GsL
VarBE/2P8vRc2/56afWiKdLH/2b5In+sQN2VrcH8RZAbaqJYGIUzOy3MHGHoA1CG
7jY1dqnXaRudVra6zmirEGi2fT3zvw5QDMg0WKjwAI8jerVgeprH7KrZk+oKNyqU
hDwxMKSpA4mqWO6HuqavHAaGleUzPtcqhKr4+wq6GQHFjIuw1bgGmCuj6gaqJVJx
/7R6SWT4/XenJjDS1CESVnR7+VJBhterkS6rcKO8qwWGdvDiSOyWewxj1GmBBkYD
wpWftW/DzLU/Fifzr+Zv
=/9pe
-----END PGP SIGNATURE-----

--SV4uv4uv610a5dR56ArJq2AfwipS7Cq73--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
