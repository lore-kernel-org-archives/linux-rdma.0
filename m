From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] IB/hns: Fix return value check in
 hns_roce_get_cfg()
Date: Mon, 22 Aug 2016 14:15:55 -0400
Message-ID: <c27a3c5f-9604-546a-5ac7-e70613d93d50@redhat.com>
References: <1470445284-28970-1-git-send-email-weiyj.lk@gmail.com>
 <20160807053115.GQ27667@leon.nu>
 <087f4381-d830-fc57-ea5d-c516a1b160b5@gmail.com>
 <20160807131419.GS27667@leon.nu> <57AC56D4.3050401@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XqiDU5sVK6t3ja7PtvBQQkuXH1aKeaO5N"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57AC56D4.3050401-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XqiDU5sVK6t3ja7PtvBQQkuXH1aKeaO5N
Content-Type: multipart/mixed; boundary="sXo3tmiVBQp4pJk5IkwTn8l8wvI6tFUVd"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <c27a3c5f-9604-546a-5ac7-e70613d93d50-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] IB/hns: Fix return value check in
 hns_roce_get_cfg()
References: <1470445284-28970-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <20160807053115.GQ27667-2ukJVAZIZ/Y@public.gmane.org>
 <087f4381-d830-fc57-ea5d-c516a1b160b5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <20160807131419.GS27667-2ukJVAZIZ/Y@public.gmane.org> <57AC56D4.3050401-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <57AC56D4.3050401-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

--sXo3tmiVBQp4pJk5IkwTn8l8wvI6tFUVd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/11/2016 6:43 AM, Wei Hu (Xavier) wrote:
> Hi,  Doug Ledford
>=20
>   Can you give me a suggestion that what we should do? Thanks very much=
!

I still have a branch for your driver, the hns-roce branch in my tree
(only available via my github repo for now).  Now that Dave Miller has
taken in the most recent patch to add the needed reset function to the
hns net driver, I rebased your branch in my tree on his net-next branch.
 I'll submit it in the next merge window.  I then applied this patch on
top of that branch.  So, future patches to your driver need to be
against my hns-roce branch in my github repo, at least until I merge it
into my official k.o/for-4.9 branch.

> Regards
> Wei Hu
>=20
> On 2016/8/7 21:14, Leon Romanovsky wrote:
>> On Sun, Aug 07, 2016 at 08:19:39PM +0800, Wei Yongjun wrote:
>>> On 08/07/2016 01:31 PM, Leon Romanovsky wrote:
>>>> On Sat, Aug 06, 2016 at 01:01:24AM +0000, Wei Yongjun wrote:
>>>>> In case of error, the function devm_ioremap_resource() returns
>>>>> ERR_PTR()
>>>>> and never returns NULL. The NULL test in the return value check sho=
uld
>>>>> be replaced with IS_ERR().
>>>>>
>>>>> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> On which branch did you base your patch?
>>>> It would be helpful to us if you followed SubmittionPatches document=
,
>>>> section with Fixes description. In such case "git describe" will giv=
e
>>>> immediate answer on my first question.
>>>>
>>> This patch is based on the linux-next.git tree.
>>> Fixes: 5e43122add63 ('IB/hns: Add driver files for hns RoCE driver')
>> This driver wasn't part of last pull request and it is worth to consul=
t
>> with Doug Ledford on the plans for this driver (stay in ->next, resubm=
it
>> e.t.c).
>>
>> Right now, there is no tree to apply this patch.
>>
>> Thanks
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--sXo3tmiVBQp4pJk5IkwTn8l8wvI6tFUVd--

--XqiDU5sVK6t3ja7PtvBQQkuXH1aKeaO5N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0FbAAoJELgmozMOVy/dQzIP/RYPqcvVvyE7lQO+konkkK9R
TIyLmhSVGZoPleOP/ddRd6cHqwjB+IvnnTdowQ6OlV6IMBSipUs1Ad59fmFS/pjM
f6GrHIjTX6uOx45a/DdAPl4mCtz1C54m/hukYkh8KPponfWuZIvfnS+N93nnIh9i
Ljw+5WmloKBVmAqrj8cJPOq7IQ0aX8At5xb3Y/pTUpd2G/PZAzmmzOm/NVSYKsLT
aiNR1QcKgeSSvRKv/3i2sNBxTCn+D92FWo+opsFXNIwYQBtic8EfSeQSic7IV3eJ
KV6A1yg2jiwAK7dSScbmtltzDrMpU7W95zkmEjGIl4sgwZIU01VqCifkM+AZ1fkY
zph31krp0BXqnkSoAv97gkmmRtsdCW/U4QsklHwp41TxhtgFkqnhlOSAXZtNF2X/
q4Qb3LW1N9RlqzA7/9nDPgdu8xZC+CkrEz9lJ9YJuFAu708vMRgbupAHMg0zV9hF
Wczn5Uom8od2SYmx6jPq9PwG23OqP4UH1leCqObwcu5l3NuBQjCPQ/iOdsNX/Raj
WioppD8RZl2liAiF+uUswYdWhOJ0b9AfwyjgjyRoykBtsaUjHn9p6fIXvx2f9GjE
qs8lzYDA2QgZ10dMytn0Pj9DbLeHfdK8GFQwsDUf3IajqkKY8mYa9TZ3lIHGL/eb
QZErbWFLcg0BZhanSEEI
=foiC
-----END PGP SIGNATURE-----

--XqiDU5sVK6t3ja7PtvBQQkuXH1aKeaO5N--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
