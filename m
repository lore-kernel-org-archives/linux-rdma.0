From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Tue, 25 Aug 2015 14:35:27 -0400
Message-ID: <55DCB56F.5000001@redhat.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com> <20150825182233.GA20744@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="STiEN3KhuT9HLovVxiTkSEJ15h0J2EM1I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150825182233.GA20744-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--STiEN3KhuT9HLovVxiTkSEJ15h0J2EM1I
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/25/2015 02:22 PM, Jason Gunthorpe wrote:
> On Tue, Aug 25, 2015 at 01:50:05PM -0400, Doug Ledford wrote:
>> On 08/21/2015 07:34 PM, Jason Gunthorpe wrote:
>>> Even though we don't expect the group to be created by the SM we
>>> sill need to provide all the parameters to force the SM to validate
>>> they are correct.
>>
>> Why does this patch embed locking changes that, as far I can tell, are=

>> not needed by the rest of the patch?
>=20
> test_bit was lowered into ipoib_mcast_join, which requires pushing the
> lock unlock down as well. The set_bit side holds that lock.

I see the confusion.  The test bit of SENDONLY isn't protected by the
lock, just the setting and clearing of BUSY.  There isn't any need to
push the locking down into mcast_join just because we are checking
SENDONLY in mcast_join.

>> If the locking changes are needed for some reason, then they likely
>> need to be their own patch with their own changelog.
>=20
> It doesn't make sense to move the locking without the code motion that
> motivates it, IMHO.

Sure, I agree with you on that point.  I thought you were changing the
locking for some other reason that I wasn't groking, I didn't think you
were doing that for the SENDONLY flag test.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--STiEN3KhuT9HLovVxiTkSEJ15h0J2EM1I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV3LVvAAoJELgmozMOVy/dy28P/jznfQCrGJxYUfQb2/ofteoZ
TT6Rzi/aoeXPqlxzC0geEVqYMYktuNDUCIW7VM8khx466AIN4qtFpVxu1fUUffdP
ybdgVspIrGNc4Q5TkL0N7RGK0syY0xNQSXtlKROd1aftoOJsZ484g9XvzKDsEaVt
bGhHSE0ybuzxzqEPAoG4jkG94w2lWusIEJBNmWRuws0L4Mj3n00ruFoxkCXtOq2c
1pj305g46drLIcfP85C9gv5pUxoqCcZHuXErR623Out+Bz8La40uKexzDP0Bw3J6
LXCg1eyrGP9HcdCzr/JiT04mGs+gNnUCGokjTDb1eltBESBYBCkHxQm9f20CK2c9
qIsM4SBndfIdacmN5oDfgpNzUdIew9FxZloliH+Qab4hZ9/0Cl8gWCDcL6Piw/tr
6wgcPpoyX/2xgnKQ4TYFqDTVPyXkw7zv1nur02azzxmIAIYLT20uuvaRymCA/zP1
gvzT+Cv2S98+liRchLCHA3reC22sHVoI0PkUhtdXkJUuh1dcoLnQMn6woP3HH0ll
whnnPW6CZDVSRs0JGqnuJ9uDObFzAI/njtvvRRtExDyouoZQV4BP2bOiX8AdDZoR
SAA/oujT6XuxqGe867xCKBJVHE1nKceAFbMBL9XyITsv15dFfW5y904riM/fmfKa
K8OcH+rdXMq4INX3BamW
=+uvC
-----END PGP SIGNATURE-----

--STiEN3KhuT9HLovVxiTkSEJ15h0J2EM1I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
