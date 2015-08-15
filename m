From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Fri, 14 Aug 2015 22:08:57 -0400
Message-ID: <55CE9F39.4090903@redhat.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com> <20150731223153.GA1518@obsidianresearch.com>
 <55BBFF03.7000505@sandisk.com> <20150731231430.GA1955@obsidianresearch.com>
 <55BD2689.3080602@redhat.com> <55CA600B.1050706@sandisk.com>
 <55CDEEFA.4010803@redhat.com> <55CE1554.60001@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IQuLBMoRLS7g59nFQqfRdgDRTahJNTfEB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CE1554.60001-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ben Woodard <woodard-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IQuLBMoRLS7g59nFQqfRdgDRTahJNTfEB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/14/2015 12:20 PM, Bart Van Assche wrote:
> On 08/14/2015 06:36 AM, Doug Ledford wrote:
>> On 08/11/2015 04:50 PM, Bart Van Assche wrote:
>>> On 08/01/2015 01:05 PM, Doug Ledford wrote:
>>>> On 07/31/2015 07:14 PM, Jason Gunthorpe wrote:
>>>>> On Fri, Jul 31, 2015 at 04:04:35PM -0700, Bart Van Assche wrote:
>>>>>
>>>>>> With only patches 1/12 and 8/12 applied my test passes.
>>>>>
>>>>> Thanks Bart!
>>>>>
>>>>> If you like, I can try and work on #9 (no promises :(), but I think=

>>>>> I'll need some way to test it here.
>>>>>
>>>>> Do you by chance have a straightforward recipe to setup SRP and SRP=
T
>>>>> on two Linux's for this simple purpose?
>>>>>
>>>>> Doug, just drop #9 'IB/srp: Do not create an all physical insecure
>>>>> rkey by default' please, thanks.
>>>>
>>>> I've pulled in the series for 4.3.  I've included patch #9, but that=
's
>>>> on the understanding that if it can't be fixed before the initial pu=
ll
>>>> request, I'll drop it at that time.  I have the resources to test th=
is,
>>>> so I can work on it, and that factors into my path forward here.
>>>
>>> Hi Doug,
>>>
>>> Do you feel comfortable enough to queue the nine patches that replace=

>>> Jason's patch #9 for kernel v4.3 (see also
>>> http://thread.gmane.org/gmane.linux.drivers.rdma/28153/focus=3D28419)=
 or
>>> would you rather prefer to take out patch #9 and queue these nine
>>> patches for kernel v4.4 ? Please advise.
>>
>> I was planning on queueing up the 9 replacement patches.
>=20
> Hello Doug,
>=20
> I hope that someone who has access to a DDN system has the time to test=

> this patch series against a DDN array. The memory key that is associate=
d
> with the indirect data buffer descriptor is never used by the upstream
> SRP target driver (ib_srpt) but is used by DDN arrays to transfer the
> indirect data buffer descriptor. DDN arrays support indirect data
> buffers that are larger than what fits in the SRP_CMD information unit
> but the upstream SRP target driver not.

It will be ready to go very early in the merge window, so they would
have plenty of time to test.  Even pre-merge window if they wanted to.

Ben, can you find out if there would be an ability to test an upstream
kernel against a DDN array where you are?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IQuLBMoRLS7g59nFQqfRdgDRTahJNTfEB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzp85AAoJELgmozMOVy/d/uYP/0HoNv62kDDK86Mq9AaUaTQ7
SA5dx/kwaJppx4asYREgyXdBdu9IMackfrvmkvceDZPNvS36Aja/qFO5q5epjBIg
0OD4XsPJNDTCp9Z243eUvFGbjy4qIrChmAsIlnsquoC/F2wTA4vhEaTzN2nbTNsB
eOk7k1LUe8OM0f0ucAM1p5HrdrPlOJ1W11UsHbjdMTaEWVzdy4xQ2B2Y5g7+gsVM
9yf35V2H6c3TK4DNy0MiK4jpA2II9mMQmyGQJ2rLmRwt5EKYo+bG8zMMQeLkRs77
8ZsSMgr8i2RpwS9AWGslbnNlQwI+pHWBk4CQYwENTNJ7elljxQZl0VvePb50/Cub
9tjRyHlqId3UynDhi+H90Z8vGK/BDddx8mrkLvXviE/61g2p5Ljxx5/qKDY5zEfn
3Q+B9d4KD72cwVEOdCrtiCjOmKOZEhyp4cREhxCwzLkNsIHl306yrjklNZGl9bOg
v7wPVP6bVk5QJfxPGXotoGBm94xoaFI/RoeVMjHnWq2+vgb4ZLb0wtDfS/sIgTV2
l/oP+xwnm+K4iC9VbVC/zETj/CMpyBlegi3QwWP3ASuqKbx4TuapaPIIuSbluXO7
ccNVwCDFeV8VxrGi2hqqAvYTA51IWV5QaBFij8uXc1I113mR+6ApLiD6Xufy+e6V
doOimOrfxwKuTcLxPXFr
=xFJ4
-----END PGP SIGNATURE-----

--IQuLBMoRLS7g59nFQqfRdgDRTahJNTfEB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
