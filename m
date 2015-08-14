From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Stop the scsi_eh_<n> and scsi_tmf_<n> threads if
 login fails
Date: Fri, 14 Aug 2015 17:29:21 -0400
Message-ID: <55CE5DB1.6040805@redhat.com>
References: <55CE2CE5.40103@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3q134Ttk3TGk4cPrvcjRG1Uhpx7mlADqv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CE2CE5.40103-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Konstantin Krotov <kkv-IRcc4E3C6l4@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3q134Ttk3TGk4cPrvcjRG1Uhpx7mlADqv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/14/2015 02:01 PM, Bart Van Assche wrote:
> scsi_host_alloc() not only allocates memory for a SCSI host but also
> creates the scsi_eh_<n> kernel thread and the scsi_tmf_<n> workqueue.
> Stop these threads if login fails by calling scsi_host_put().
>=20
> Reported-by: Konstantin Krotov <kkv-IRcc4E3C6l4@public.gmane.org>
> Fixes: fb49c8bbaae7 ("Remove an extraneous scsi_host_put() from an erro=
r path")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v3.19


Thanks, added to the srp branch.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3q134Ttk3TGk4cPrvcjRG1Uhpx7mlADqv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzl2xAAoJELgmozMOVy/d57kQAIRFnT76wpq1VzIvQyutvhS+
rARHAFgwO78Izl+4y6JZeXAw//RlAPAaFvwaEnsVWKzPkawpOrkVVaFfPMTUgpTg
2dCIWEhv8ib6v2AhmjjZo/EW3Rke8knzaHmtsfTAszlXtuB1dXniJ+8j9AGYPR+A
VL5oJWcdVDwU6vESquAv4HROLAWyBNZzyFuD+bRYoqzNOi5WjyGnL2xjwvbN+4jY
pbCPgNLHdNOhaYxlAYwVqdTNgBKa+clUC13geUxdikb/hpLRFco9aVIMyXv8yWgW
GXc+QJhU0ibZRcrKjKyesezHdIVxQ8C0uXaG/nC8bvsRCHkiayYDjWwCrLZuN9qu
ymtkj/3CyVex81pvebo5y8Tg3VoK371EHJATIYuSFhUuBL8H+R6x3kjLFXt6ljT4
Gd2WoximBUrHyAfz3twCy9ZD8N7t4obJCBJGHPw+Dojyc+mRv8q3UyHx46Gat61w
hOsnJfyvSkQIS9LvIMuv8I8Rd33mLKiqXdoJFueNSIJuD6eyrJOP/s31m1KP7+4h
BFDyPJoFhf7rml1U8rdRIAR6cwz51l4ZsgK+T1xqupGTWMMRZ6jP/WxNu+40Fhgw
2uuMLJY5wBKvItwHIZXt0vBhjzEuIopr2nOeOGG5aZ721NnMFHlnqNoq68JSDb7/
vuw3c0lOeA33+zg1oRNK
=7dmR
-----END PGP SIGNATURE-----

--3q134Ttk3TGk4cPrvcjRG1Uhpx7mlADqv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
