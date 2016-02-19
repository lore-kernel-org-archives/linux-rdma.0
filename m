From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 01/32] IB/core: Macro for RoCEv2 UDP port
Date: Fri, 19 Feb 2016 13:26:10 -0500
Message-ID: <56C75E42.8050102@redhat.com>
References: <1450948698-13383-1-git-send-email-kamalh@mellanox.com>
 <1450948698-13383-2-git-send-email-kamalh@mellanox.com>
 <20151227065815.GE8501@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8agPd6Hrjm5o0gjHJf9DEgKrdnk0I7cgW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151227065815.GE8501-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8agPd6Hrjm5o0gjHJf9DEgKrdnk0I7cgW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/27/2015 01:58 AM, Leon Romanovsky wrote:
> On Thu, Dec 24, 2015 at 11:17:47AM +0200, Kamal Heib wrote:
>> From: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Adding a macro for RoCEv2 UDP destination port.
> You are adding define and not macro.
>=20
>>
>> Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  include/rdma/ib_verbs.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 368fc22..9904394 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -79,6 +79,8 @@ enum ib_gid_type {
>>  	IB_GID_TYPE_SIZE
>>  };
>> =20
>> +#define ROCE_V2_UDP_DPORT      4791
>> +
>>  struct ib_gid_attr {
>>  	enum ib_gid_type	gid_type;
>>  	struct net_device	*ndev;
>> --=20
>> 1.8.3.1

This patch was skipped anwyay.  It was already added via a different
patchset some time ago.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--8agPd6Hrjm5o0gjHJf9DEgKrdnk0I7cgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWx15CAAoJELgmozMOVy/daP4QAIrgi1KMBFVLOVFEasmkdPmZ
+yn8Vi2mQYIssyNaRCVQ0VckGix10XqI9X2YgVzsCyaHU7ZAZGNsxCyWg5JmSWQX
qg6gFHkteIhQB2tklyqXqsMFSyaG8GuvRC59ABkFn6CNRKzDQGKQXqDqoID+bzBL
iNmJvktdMWfNv3F+5iOy+u0RrfTRZ3VfaT9qGAizW9kKWQiNtFgdMxQaBQdVNrGm
ksiwa6JdlBsAWyFM0g1OQiZEu0h/8038PX7iFS9CEoByDJNzCrOioVwKtoNL+ISM
3BzioJWkdwDLLPdQljbK/FcwMZiIh3dnjUxjiOjJnfXg7aQb/snT8i9OU2vZa4XI
aR0nmG7DMeU7W5Q90VSPAvig83kCjVUwg2oLvKQRaLF7/wWZf8DLkeWnfIZBd3Ha
+nbkDAV2YAx0+6ccHvd9S7I0nr1g5k7MVCC+660qTwegKJKT6Mir4b+rLESU+3Jw
EFDxLPphV0mgTBPk2gi+wDjyb8B8/VciOpxCN+2s4DRdvPfjOXqZQykR3DE0JHbo
13sSN0B9qiN4m7ubF8HWlqtXWr5RoNugCKvmAq8OrL45MJR0pOdA2yEXPyaB8fUY
Qv0r3ViPmwOgjVRM3/+IQAYbdEhrpS2Q9GhtiGCwD8M6usStIrkG7DgpeQlx4TmT
cUvbhke4N5VvtJF0dTTl
=xzGx
-----END PGP SIGNATURE-----

--8agPd6Hrjm5o0gjHJf9DEgKrdnk0I7cgW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
