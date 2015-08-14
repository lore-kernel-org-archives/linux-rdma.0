From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Fri, 14 Aug 2015 09:36:58 -0400
Message-ID: <55CDEEFA.4010803@redhat.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com> <20150731223153.GA1518@obsidianresearch.com>
 <55BBFF03.7000505@sandisk.com> <20150731231430.GA1955@obsidianresearch.com>
 <55BD2689.3080602@redhat.com> <55CA600B.1050706@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5FOadTkohQ2XOTA4R3u0laoDK1D6TJp4C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CA600B.1050706-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5FOadTkohQ2XOTA4R3u0laoDK1D6TJp4C
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/11/2015 04:50 PM, Bart Van Assche wrote:
> On 08/01/2015 01:05 PM, Doug Ledford wrote:
>> On 07/31/2015 07:14 PM, Jason Gunthorpe wrote:
>>> On Fri, Jul 31, 2015 at 04:04:35PM -0700, Bart Van Assche wrote:
>>>
>>>> With only patches 1/12 and 8/12 applied my test passes.
>>>
>>> Thanks Bart!
>>>
>>> If you like, I can try and work on #9 (no promises :(), but I think
>>> I'll need some way to test it here.
>>>
>>> Do you by chance have a straightforward recipe to setup SRP and SRPT
>>> on two Linux's for this simple purpose?
>>>
>>> Doug, just drop #9 'IB/srp: Do not create an all physical insecure
>>> rkey by default' please, thanks.
>>
>> I've pulled in the series for 4.3.  I've included patch #9, but that's=

>> on the understanding that if it can't be fixed before the initial pull=

>> request, I'll drop it at that time.  I have the resources to test this=
,
>> so I can work on it, and that factors into my path forward here.
>=20
> Hi Doug,
>=20
> Do you feel comfortable enough to queue the nine patches that replace
> Jason's patch #9 for kernel v4.3 (see also
> http://thread.gmane.org/gmane.linux.drivers.rdma/28153/focus=3D28419) o=
r
> would you rather prefer to take out patch #9 and queue these nine
> patches for kernel v4.4 ? Please advise.

I was planning on queueing up the 9 replacement patches.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5FOadTkohQ2XOTA4R3u0laoDK1D6TJp4C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVze76AAoJELgmozMOVy/dpVcQAISIUnLAOZeK67pzXz3vqOy8
ly5+I+BXDIvIfFgQmPXjjcdbrSqugh270HicQkLwswBG737eWebE24ObH8GLuzpH
DI//GQvg9VtlHOBqrz2EdYIdrU9Yc+rSD4/lqw1RQnK2AQITKwmJz6O8RFmAHApp
atyEyQJBNfY2CrfeCTil02HBpAzcXArJ6FIIO8n9uh0FzUu06M4vv5M3yGPHeAju
m5AnoQMdxXZXzRNaaIf8GnsUa+JPHIqzseopJcVxiz1vLeqOGxZGH4VYns4z3xRt
CNO3NYBdjzZc7UmUsmdakaJdsbrp19DC44BkhX5j/nHtl0WkeU4c0CeX58HbM4ZD
VzKqWQjeMC9kwr6fuhiBi4NUrraPeSu9HRRXKjQ+aQJiArf1i8WQZHTu7yoH+075
TA9nAMVxkSISUELo7KMc/y79B90pwTr+LTTDvFibhpn4bkcwLtklpiny4rrWJWRS
zXXSRudQGiH2wwjoAMtLRosfl7vkiOK6b/l2PwDz56EkZVfzWATwEYCZhTGlyXVv
B5vVIiBmJ+JPnalkIOlA5fdt1B17YJLYv4Qz9Cx9Tlh3rgWdOySqDWGOwVaorIF5
nzini5e2/V5pTvnzmJgw7WtlkhTJNiNUcVzf1mGrmMWrVv3WZMwwI8fOs/gXl762
tNP75wSlfkuD/Qjr5m51
=WA+E
-----END PGP SIGNATURE-----

--5FOadTkohQ2XOTA4R3u0laoDK1D6TJp4C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
