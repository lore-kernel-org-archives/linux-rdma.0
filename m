From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Convert UMR CQ to new CQ API
Date: Thu, 3 Mar 2016 11:26:23 -0500
Message-ID: <56D865AF.5000507@redhat.com>
References: <1456565984-28998-1-git-send-email-hch@lst.de>
 <1456565984-28998-2-git-send-email-hch@lst.de>
 <56D2D731.5060904@dev.mellanox.co.il> <56D3F1EA.9090800@mellanox.com>
 <20160303083822.GB13828@lst.de> <56D7FE93.9020503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xjq6VugNBGNeLGNsq26QsXp2wMTUu1Cqm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D7FE93.9020503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xjq6VugNBGNeLGNsq26QsXp2wMTUu1Cqm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/03/2016 04:06 AM, Sagi Grimberg wrote:
>=20
>> Thanks for the review Haggai.  I noticed I left a stray
>> ib_req_notify_cq in the code, which is harmless but not needed with
>> the new API.  Patch with that one line updated below.
>>
>> Doug, can you picks this up for the mlx5 branch?
>=20
> The patch looks fine to me too,
>=20
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I took the later version of the patch, but I had to fix it up due to
conflicts with both the rereg_me patchset and the mmkey cleanup
patchset.  Please double check this in the mlx5 branch of my github repo
to make sure it's all good.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xjq6VugNBGNeLGNsq26QsXp2wMTUu1Cqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2GWvAAoJELgmozMOVy/dv8YQAK+S+Myrp/rhofYSBzCBDR9q
vCZ/rWPRyis2swLmx37R+EcOd6zxGkARMxbYRyGdm3r+Oxg2e2UCDF2Y8S0hMiiJ
Fq4eb2H9eiapAKb2Sgf7tLsD4fAfA5R9CnOA7zMw7PkYz+8ftincOjxqDYZ2Aw8T
xRF+DjT1F/iFBG97uKESRGrkZEXi22UvBnnlEi0GZ2xLo55BfA5XIPZ3oyYHcxdO
KVVp4AAgJfCCEsurlVSv+PmnbZ8Li18rLZGIqF7wKKFs3PLNuYlHolx86vR+9MdQ
hr2PewD5gWevEo69lGSNnKfgPSAuHLQQliKnLbOLKOGQdLFsNn5pu7bNKa/0P11h
KwUgXajir52vjKuAoDNdbxYtszgbdq22LWdI/ZifOq/Lc1noK+EDvZtr+tXRU647
zozvL59fNaG/hexh0KiObu5GarxRfHWKKbKMHbI/V7FzbIfeUkX8MNu2KCipTWMQ
ftOOScvHlucAIzdOmmn2lD4McQzNXxPvooGn2UikGsvPY3jCgMv2PKCePWN92f8R
ZbitactbBRSLrHLtSL465MgvSbRR6XYOg38eXyrBQn0hGrrU6gv0tLFXKlCtfN/7
csiHUEQ9RC4TLjiMYhxtVF8eTkojXvS67eKLvimgerqjI2I+28jybE8vk7e451Uc
krcpOe/ZRwsgQT7ji27A
=uShg
-----END PGP SIGNATURE-----

--xjq6VugNBGNeLGNsq26QsXp2wMTUu1Cqm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
