From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Sun, 29 May 2016 23:39:35 -0400
Message-ID: <574BB5F7.2040201@redhat.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com> <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
 <20160530013507.GA19230@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HWIj23eT8MibamCu9s7m7hVC9AS6nLVm2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160530013507.GA19230-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HWIj23eT8MibamCu9s7m7hVC9AS6nLVm2
Content-Type: multipart/mixed; boundary="h76MQ1m1ep9ss4nbe56E9oxbCutgPivvS"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <574BB5F7.2040201-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
References: <1464533475-18949-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <1464533475-18949-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <574B6F71.9060808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <20160529233009.GA12420-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160530013507.GA19230-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160530013507.GA19230-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--h76MQ1m1ep9ss4nbe56E9oxbCutgPivvS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/29/2016 9:35 PM, Jason Gunthorpe wrote:
> On Sun, May 29, 2016 at 07:47:54PM -0400, Doug Ledford wrote:
>>> You should really read the whole prior discussion
>>
>> If there's something in particular you'd like to point out, feel free.=
=20
>=20
> You can't ignore the mailing list and expect the rest of us to carry
> you along when you finally wake up..

Who said I ignored anything?  I didn't get your reference and needed you
to be more explicit.  You don't have to be a dick about it.

>> It doesn't have to be refs. If I recall correctly, the libmlx4
>> driver has to clear each cqe by changing the ownership status back
>> to the hardware or something like that. The release could just as
>> easily be setting that ownership on the cqe.
>=20
> It also has to notify the hardware of the new ring head pointer which
> becomes more expensive with refs, especially on a lockable CQ.

It's no more expensive under what I just outlined.

>> The original bitmask version included a copy to an interim, variable
>> struct.  The idea here is that the cqe is an opaque pointer directly
>> to the hardware cqe. There would be no interim copies, just
>> retrieving the desired data directly from the cqe. Maybe I should
>> have called it a hcqe to be more clear.
>=20
> Unless I'm mistaken, something much more more complex than just a
> simple offsets is required to handle the usual hcqe format used by our
> various drivers.

That's a valid point of discussion.

> I agree if you could describe the typical hcqe extractor in a format
> like offsets/mask/shift for all supported drivers then that might be
> better (unclear if an unaligned load/mask/shift is more expensive than
> a branch).  I believe I already explained that possibility earlier in
> the thread, and went further to suggest doing a direct HW optimized
> DIRECT option like libfabric has.

And that's what I want to explore.

> However, getting this wrong limits the future hardware we can support,
> which is scary, and the branch option clearly doesn't have that
> problem.
>=20
> So the performance win would have to be substantial, IMHO.



--h76MQ1m1ep9ss4nbe56E9oxbCutgPivvS--

--HWIj23eT8MibamCu9s7m7hVC9AS6nLVm2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXS7X3AAoJELgmozMOVy/d9VcQAJLVI9qsKoVi0Gfljqd+V71q
hQTc9S+num3zAlZ0e41+QZ4Flkipo+Ilbqu3BJOVjK8WiA0Z7jb7iDUDrvEnBllb
Jqah/Oh5saNCaVGrLwsD/b/Gwneips/qzgFUkYykQBj38e/LJxn81aDiWoN741Mk
55iB6djWcl3G+s3hEBAac+EdwzrYqUElmWrxzqvvDtKnu2SeB2uKQKvpjnLywyEX
JIy2uoc9jmtBKkmhYIEL0Pp8RoYhhC5srXQ4t5lJiVI7sBnqozMGHMZM0AlG9VAG
055qqd2gKAsGIbsZTdaFk9UJck9oDTzW2KN1qvjDhudsmHix5ObZKYTOEiVPEntU
YQIM/i2EflmWhnSBMPWXelF2Xfc5AaelEgXaNcKFZ91LN9X0Jhd0mUaaX+1ECE85
fM0NPsgk+BHqlOM7fLp4AbI/ylkjf04BnQLT4fi5jTyN4k86mgNzsL1h6zbJ9i/s
t7hQpC132qWSTDbmEdsdWJbNvcOzq/IlgMl9K2rFuvdsM7+QLRlefpeOzRXwWX5W
VQaOwHkXQOxPFnUgCoVesKAzuxiHtDcPfv5NGqlqN6l4Uay4ODFfVG63ys206Lo5
UMFKBb67BfsqwkMLGBExvnnVTbjm1pwE97+tpNEtkhxPUBBjPWGx1FHTR2adld1P
RvwXBOljcM5mx/8f99fH
=vJv8
-----END PGP SIGNATURE-----

--HWIj23eT8MibamCu9s7m7hVC9AS6nLVm2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
