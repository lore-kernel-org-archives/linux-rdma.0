From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Reduce RDMA RW API SGE limit
Date: Wed, 13 Jul 2016 09:18:42 -0400
Message-ID: <88382a49-0fd2-cac8-d415-4fc9c22d98eb@redhat.com>
References: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XHtpFAvW4lLQktoSv9vHI8N3SoO8UHa5O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XHtpFAvW4lLQktoSv9vHI8N3SoO8UHa5O
Content-Type: multipart/mixed; boundary="Kj8M33mD3f69r0wG6S6uCQxSnBFCUQxOu"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
 "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>,
 Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman
 <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <88382a49-0fd2-cac8-d415-4fc9c22d98eb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Reduce RDMA RW API SGE limit
References: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--Kj8M33mD3f69r0wG6S6uCQxSnBFCUQxOu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/30/2016 9:46 AM, Bart Van Assche wrote:
> Hello Doug,
>=20
> The five patches in this series modify the RDMA RW API slightly. This i=
s
> needed to avoid that the SRP and iSER target drivers submit RDMA
> requests with an SGE list that exceeds the queue pair limits. The
> ib_srpt changes in this series have been tested but the ib_isert change=
s
> not yet.
>=20
> The changes compared to v1 of this patch series are:
> * max_send_sge is now stored in struct ib_qp. This greatly simplifies
>   this patch series.
> * An unneeded initialization that I had added to rdma_rw_init_one_mr()
>   has been left out again.
> * Corrected "Fixes" tag in the patch description where needed.
>=20
> The individual patches in this series are:
>=20
> 0001-IB-core-Make-rdma_rw_ctx_init-initialize-all-used-fi.patch
> 0002-IB-core-RDMA-RW-API-Do-not-exceed-QP-SGE-send-limit.patch
> 0003-IB-srpt-Limit-the-number-of-SG-elements-per-work-req.patch
> 0004-IB-srpt-Simplify-srpt_queue_response.patch
> 0005-IB-isert-Remove-an-unused-member-variable.patch
>=20
> Thanks,
>=20
> Bart.

Based on the review from Sagi, I'll wait on v3 of this set.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Kj8M33mD3f69r0wG6S6uCQxSnBFCUQxOu--

--XHtpFAvW4lLQktoSv9vHI8N3SoO8UHa5O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhj+4AAoJELgmozMOVy/dSG4QAJJOx25QA2pMHVtFCqE63gRI
nPS3xL0aQYgDrxEfMBaF8iFoDrSlTEfBE/pogtL821Es7Zj0FKlbDfEmqlKzkOzP
FUOLMQBZtX57vegA/lue1+GXopiUqfUGbVYfdlEtxjUGa8fWfRdzgptXqSDmFxD1
McK+WoAMznpzrms3PfAROzdR47SijaG63A0CIh1nk2obg3jL9JB8yI37hqO+4arW
TMUjvHOHJpvSaEFcZmzid+cLrw8kazpf1ucrlBCi68k/uhtr9j+VaW8xDnA1hp8W
u1965gqi1fLnZGV2LJErVWYHgFy+IlhPHpKDRo9w6s+NEVjpKLxiI6BLXX147pKb
POptIcz1t7nmr65Xv4OO/Zby7xuHA7mr6CgTodYFpL7GmnIXONfuG4m1b4rDotZD
rNXVp7TsOnw6YEXN4PhagmApxy3jW3PnCylNG7I7ip23eGkri6aIJOc4DM6spcM2
Stc4PnLAQuceb65Cn4xTOQSmg0NkaI9uB1GrpASXLx/HeLQZNmoAc20/8P6/h5W8
fC0kDSW0dAbz+C9F2vQcJmKrJ/jMd/40kMZfGAWyqjROFFeVJjoqV/J1a3kZVSoZ
a06VY++o7y3vX2oSs8w6HqGx5qE1taQsO0+wwbdLHSi6FrkiNo6llx0veSavZhDv
hxKpYK/Okm075F0ZDrgH
=yfGq
-----END PGP SIGNATURE-----

--XHtpFAvW4lLQktoSv9vHI8N3SoO8UHa5O--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
