From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ucma: check workqueue allocation before usage
Date: Tue, 20 Oct 2015 13:38:38 -0400
Message-ID: <56267C1E.4040701@redhat.com>
References: <1442520259-2248-1-git-send-email-sasha.levin@oracle.com>
 <20150917225934.GA22326@obsidianresearch.com> <560D491F.7020200@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DLIePnULmk972BLsQCQ7SFqwMLfmmhudN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560D491F.7020200-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DLIePnULmk972BLsQCQ7SFqwMLfmmhudN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/01/2015 10:54 AM, Sasha Levin wrote:
> On 09/17/2015 06:59 PM, Jason Gunthorpe wrote:
>> On Thu, Sep 17, 2015 at 04:04:19PM -0400, Sasha Levin wrote:
>>> Allocating a workqueue might fail, which wasn't checked so far and wo=
uld
>>> lead to NULL ptr derefs when an attempt to use it was made.
>>
>> Indeed.
>>
>> Yishai, please check this and check the other patches you've sent to
>> see if they have a similar error.
>=20
> Ping? It doesn't seem that the patch got anywhere.

Sorry, I took the "it applies to linux-next" to mean it wasn't against
my tree yet and was against upcoming patches.  That wasn't the case.
It's been applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--DLIePnULmk972BLsQCQ7SFqwMLfmmhudN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJnweAAoJELgmozMOVy/dkTQP/Ri62QQ9Jpm9WlUi8g6zgvlt
WgfYh+l83uaKa5HgPRwLj7iP4MaXOvOKI/zSZyAYxIQ2VRqigR0DpZ8tQ9RCGI1m
Vf1DzvR3e4o1xvcecyl36weKuYdsXSJFzbgSMp/aQZtiMFdQ/yuoKAh/sIoCYCNH
zbSf+1QJTWYL+i6zZSdVXE3eU3ptZhRtMZC37ZoBmRTf2B3rXA9Y2JcWPsV3kaiQ
K2Oj40K91/EdkwA/zK/1C1EnHSxDvBRe7zyjI1tTJkfwUI9OWpNcAOGRjelEIWyG
r09ROChgwYCvLIXnOzCaELpHBluQaWS8TfbnZnm8mb6sapGLXIjaXryVhEM13iXv
jhDhYN/QHi8pet/Mg0U0f0r+DqD6bcnb5uZdZIdX5N/nRJNxmwaDOSbyDueahjOq
f+HTzrI8X4LfRSyi8yIsL2scb/e583bs7M1H6tg68R2xm++q02fIht49HLyD/Lqe
O661yOun/NGQhac2rA1agqLM8iX71+K4+kIwqHlX6c5pZjKJ8uiLVUrHFltem5wQ
rhLC0sVRMO8JV/sVq/prjuBEGVEM+5rhgILyZ5qaT2ZvHilvzT3nHSCKfbUmT3yU
w6hCyt142SQWB8YvsgFfECQu8YL9jmPBbDF+eFUo/nitIPvMh1jWU12LWCgb5G8a
+TeiWGbK+5fnSK68CIp/
=jBdV
-----END PGP SIGNATURE-----

--DLIePnULmk972BLsQCQ7SFqwMLfmmhudN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
