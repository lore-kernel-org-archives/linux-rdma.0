From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] IB/sa: Restrict SA Netlink to admin users
Date: Wed, 12 Aug 2015 16:06:27 -0400
Message-ID: <55CBA743.9070808@redhat.com>
References: <1439261215-28078-1-git-send-email-ira.weiny@intel.com>
 <20150812194313.GA1086@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GJrwsDWc7974h63WRKLHgbEDCcJF1faE3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150812194313.GA1086-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GJrwsDWc7974h63WRKLHgbEDCcJF1faE3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/12/2015 03:43 PM, ira.weiny wrote:
> On Mon, Aug 10, 2015 at 10:46:55PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> The recently added SA Netlink service requires admin privileges to rec=
eive
>> kernel requests.  This is only partially sufficient to protect the ker=
nel from
>> malicious users.  This patch fixes two issues.
>>
>> 	1) Path responses from user space could be spoofed if the sequence
>> 	   number was properly guessed.
>> 	2) The set timeout request message could be issued by any user.
>>
>> Ignore these messages if not submitted by an admin user.
>>
>> Fixes: 6619209af36c ("IB/sa: Route SA pathrecord query through netlink=
")
>> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> ---
>> Changes from V1:
>> 	Use netlink_net_capable rather than ns_capable
>=20
> Doug,
>=20
> As per the thread with the V1 patch we are looking to merge this into a=
 v9 of
> Kaikes series once we do some more testing with the netlink_bind and
> namespaces.
>=20
> So you can safely ignore both v1 and this patch.

Ok.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--GJrwsDWc7974h63WRKLHgbEDCcJF1faE3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVy6dDAAoJELgmozMOVy/dYx0P/34f/ZrZ7S3dVBvFiLlJ/5lJ
ioIu/Law1Xu2vORqbmjlCXrUADPJvHpSjDSGJoY6LJ9ch0Md2PRCH2skgNOtIiB1
AdCI9KTa6oDLOkp9ekGEQvmta/xKBDYn0nn0fDRAERyjkq8tW8VEM59DO9FHNhxw
OlD5kfBb7YuwlSUVsHFQSKasg44itZiJHu1RiwUuCTfSVJvkFg6B6uzqYLiMnblB
I/6Uf6xOzZ6c72LXSqN9pGv72I8xRJiAWAjmSUr2sIX81qjisO7J+7tySbJlkRfa
OzAU06ycdpSMC3CVOQ/dVs8gFKUWzTCFLGtDO69o+zO65XuDF3GPUs5WP9dYNewZ
fchVlHlEoWu5TK/Rcbdkd2mwOkkgkxAx6g91yNSOPMSe+axbPuMDe/6OR5pIoBEw
plbhYdFG1QlJ+V1ZK1K/Ugxhz6L+LYkyskVljOWb9SGxC+XIdwRNLAG97mGSI1VC
Wt6eoeHGoPq9BrD9GTag3Rib0YsxxywEJm83WejckoqPtZwz5J2mpb3oObDpf98l
fJ6GiMZIz7czhWnYEwYul9EuTZWDoF3ZiX19QLtHyYTLZm3Pem3vONzhogIxfpXv
mukmhLgbqf4yuf++xiNazWeudHbpxvH+WNjCqNlAKjyKMXGOCX9iHHFX3Iqu14Hk
d2zILnKRzltjwNxrlpQ3
=Ug4n
-----END PGP SIGNATURE-----

--GJrwsDWc7974h63WRKLHgbEDCcJF1faE3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
