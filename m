From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] Fix create/destroy flow API
Date: Fri, 4 Sep 2015 17:51:11 -0400
Message-ID: <55EA124F.2070305@redhat.com>
References: <9665e46a71940f2721b30fdb4aaa0853161babc9.1441401379.git.dledford@redhat.com>
 <20150904213226.GB20758@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L1BFU9V515TcIKFvMIoRJG1widFqbf9iF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150904213226.GB20758-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L1BFU9V515TcIKFvMIoRJG1widFqbf9iF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/04/2015 05:32 PM, Jason Gunthorpe wrote:
> On Fri, Sep 04, 2015 at 05:17:38PM -0400, Doug Ledford wrote:
>> +		/*
>> +		 * In order to maintain backward/forward binary compatibility
>> +		 * with libmlx4-1.0.6, which has the original version of the
>> +		 * flow steering patches, we need to set the two
>> +		 * ABI_compat_placeholder entries to match the driver
>> +		 * set flow entries.  This is because, in the specific instance
>> +		 * of using libmlx4-1.0.6 with the fixed version of
>> +		 * libibvberbs, the ibv_create_flow inline function already
>> +		 * compiled into libmlx4-1.0.6 will be loooking in the
>> +		 * ABI_placeholder spots for the function pointer to the
>> +		 * create and destroy flow verbs.
>>  		 */
>=20
> This isn't quite the right comment, it has very little to do with mlx,
> ibv_create_flow is the user entry point, the above applies to
> everything linked to ibverbs.

You're right.  I'll correct that.

> My suggestion was to not change the ibverbs->user ABI at all and just
> mangle the driver side, ie move the ABI_placeholder to what was drv_
> instead of lib_.

As you pointed out, this doesn't make the entire matrix of old/new
driver/libibverbs/app work.  I can think of two things that would be
ugly about doing it this way if we wanted to make that matrix fully
operational.  With the way I did it, things are clean in the new driver
and mostly clean in the new libibverbs, and the full matrix works.

> Can't see anything wrong with it this way, off hand, other than the
> comment.

Thanks for looking at it ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--L1BFU9V515TcIKFvMIoRJG1widFqbf9iF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6hJPAAoJELgmozMOVy/dPd0QAIN17N3gPq+IAOmCHMks1dX8
2WN94OO1bLowZbW4yxH9Jjhm27qC9vo1rxTpgEOOshxZHk38GL8Gpxvuztq3E05r
6Mr2qpAWt7jR+Kmh8NZsE4fXBPSrgiOH0KFuevvSxVnb+aDCurLQDDMVPOEMuwx8
ydGunDJr3dlMwG1tndxA8oZXWVTfHSXkSM60W3abXgC+p9gu/ncFpgAyTdOZwExt
YQ/Xr9KOvRjFnf6xYFDWZtwu7MKRwGEwV54UHrWER4E4W5nL/XffTX5XZ9hTcxU5
NEcI8vdSh3tt4hctAnvvdn44olcCtnzygn8ey/Qc648gpDXym7Devp22GiGt+UHM
3IQoLV9O0+wl9sysgMbrk8M7QCWMcectZkeMRpp1l79zdGlxcsY5WfKtyMmaY0lD
f58HLIluzPdlLptQ/5Esayffrl3fVr5W8rbcInT6dOFUtZLGaZ0nLY0QaMVC/2BX
EBqvfa41bKeF60Ck1yrR0Ie+yeJwJqRyQZVo9XC+REOhnMECk11AVrUmKIvWy6I2
MJsnRUO7e0wFgRJ5JzbUB3mE7ZljqKkH3Ozm6wVecF9YRwUzUQ8O9N3LFW4eYLrT
nly5Ry2+2vz+ksnSijaYgtWZK8eDCtAL7K2dKujAq1tMghlSD9Qlny9glArnLNqN
YV0XXIOjJvzJO44Mgvis
=8SRp
-----END PGP SIGNATURE-----

--L1BFU9V515TcIKFvMIoRJG1widFqbf9iF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
