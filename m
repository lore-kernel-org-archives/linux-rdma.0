From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 05/20] RDMA/hns: Add command queue support for
 hip08 RoCE driver
Date: Tue, 26 Sep 2017 12:18:56 -0400
Message-ID: <81dd332d-e060-d7e3-bec9-1791511c5470@redhat.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
 <1504084998-64397-6-git-send-email-xavier.huwei@huawei.com>
 <1506359213.120853.75.camel@redhat.com>
 <20170925171821.GQ25094@mtr-leonro.local>
 <1506361015.120853.81.camel@redhat.com> <59CA5261.80209@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="08FKXsd1onNh2eUteTQTCui7lxcPqAIro"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <59CA5261.80209-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--08FKXsd1onNh2eUteTQTCui7lxcPqAIro
Content-Type: multipart/mixed; boundary="HEOW0d8NA41qx8SQbA4o8bq73kdaOrwKf";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
 charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
 zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Message-ID: <81dd332d-e060-d7e3-bec9-1791511c5470-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 05/20] RDMA/hns: Add command queue support for
 hip08 RoCE driver
References: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 <1504084998-64397-6-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 <1506359213.120853.75.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925171821.GQ25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <1506361015.120853.81.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <59CA5261.80209-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <59CA5261.80209-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

--HEOW0d8NA41qx8SQbA4o8bq73kdaOrwKf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/26/2017 9:13 AM, Wei Hu (Xavier) wrote:
>=20
>=20
> On 2017/9/26 1:36, Doug Ledford wrote:
>> On Mon, 2017-09-25 at 20:18 +0300, Leon Romanovsky wrote:
>>> On Mon, Sep 25, 2017 at 01:06:53PM -0400, Doug Ledford wrote:
>>>> On Wed, 2017-08-30 at 17:23 +0800, Wei Hu (Xavier) wrote:
>>>>
>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * If the command is sync, wait for the fi=
rmware to
>>>>> write
>>>>> back,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * if multi descriptors to be sent, use th=
e first one to
>>>>> check
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +=C2=A0=C2=A0=C2=A0 if ((desc->flag) & HNS_ROCE_CMD_FLAG_NO_INTR) {=

>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (hns_roce_cmq_csq_done(hr_dev))
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 usleep_range(1000, 2000);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 timeout++;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (timeout < priv=
->cmq.tx_timeout);
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> then we spin here for a maximum amount of time between 200 and
>>>> 400ms,
>>>> so 1/4 to 1/2 a second.=C2=A0 All the time we are holding the bh loc=
k on
>>>> this CPU.=C2=A0 That seems excessive to me.=C2=A0 If we are going to=
 spin
>>>> that
>>>> long, can you find a way to allocate/reserve your resources, send
>>>> the
>>>> command, then drop the bh lock while you spin, and retake it before
>>>> you
>>>> complete once the spinning is done?
>>> They don't allocate anything in this loop, but checking the pointers
>>> are
>>> the same, see hns_roce_cmq_csq_done.
>> I'm not sure I understand your intended implication of your comment.=C2=
=A0 I
>> wasn't concerned about them allocating anything, only that if the
>> hardware is hung, then this loop will hang out for 1/4 to 1/2 a second=

>> and hold up all bottom half processing on this CPU in the meantime.
>> That's the sort of things that provides poor overall system behavior.
>>
>> Now, since they are really only checking to see if the hardware has
>> gotten around to their particular command, and their command is part o=
f
>> a ring structure, it's possible to record the original head command,
>> and our new head command, and then release the spin_lock_bh around the=

>> entire do{ }while construct, and in hns_roce_cmd_csq_done() you could
>> check that head is not in the range old_head:new_head.=C2=A0 That woul=
d
>> protect you in case something in the bottom half processing queued up
>> some more commands and from one sleep to the next the head jumped from=

>> something other than the new_head to something past new_head, so that
>> head =3D=3D priv->cmq.csq.next_to_use ends up being perpetually false.=

>> But, that's just from a quick read of the code, I could easily be
>> missing something here...
> Hi, Doug
> =C2=A0=C2=A0=C2=A0 Driver issues the cmds in cmq, and firmware gets and=
 processes them.
> =C2=A0=C2=A0=C2=A0 The firmware process only one cmd at the same time, =
and it will take
> =C2=A0=C2=A0=C2=A0 about serveral to 200 us in one cmd currently, so th=
e driver need
> =C2=A0=C2=A0=C2=A0 not to use stream mode to issue cmd.

I'm not sure I understand your response here.

I get that the driver issues cmds in the cmq, and that the firmware gets
them and processes them.

I get that the firmware will only work on one command at a time and only
move to the next one once the current one is complete.

I get that commands take anywhere from a few usec to a couple hundred use=
c.

I also get that because you are sleeping for somewhere in between 1000
and 2000 usecs, that the driver could easily finish a whole slew of
commands.  It could do 10 slow commands, or 100 or more fast commands.
What this tells me is that the only reason your current implementation
of hns_roce_cmq_csq_done() works at all is because you keep the device
locked out from any other commands being put on the queue.  As far as I
can tell, that's the only way you can guarantee that at some point you
will wake up and the head pointer will be exactly at csq->next_to_use.
Otherwise, if you didn't block them out, then you could sleep with the
head pointer before csq->next_to_use and wake up the next time with it
already well past csq->next_to_use.  Am I right about that?  While you
are waiting on this command queue, any other commands are blocked from
being placed on the command queue?

I don't understand what you mean by "so the driver need not to use
stream mode to issue cmd".

> =C2=A0=C2=A0=C2=A0 Regards
> Wei Hu
>>>>> +#define HNS_ROCE_CMQ_TX_TIMEOUT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 200
>>>> or you could reduce the size of this define...
>>>>
>>>> --=20
>>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 GPG KeyID: B826A3330E572FDD
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Key fingerprint =3D AE6B 1BDA 122B 23B4 265=
B=C2=A0 1274 B826 A333 0E57
>>>> 2FDD
>>>>
>>>> --=20
>>>> To unsubscribe from this list: send the line "unsubscribe linux-
>>>> rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.h=
tml
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--HEOW0d8NA41qx8SQbA4o8bq73kdaOrwKf--

--08FKXsd1onNh2eUteTQTCui7lxcPqAIro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZyn3wAAoJELgmozMOVy/doOUQALKCyirMdJyyBQgqbLxJ0+oa
W0JaowKa9A8zJb98DgLtDESdqB926AXk/+kdwaTLCKq1Mx9v5IWHtQvC/JD+PAuT
N6hlmIzZNghim0DpfylZV+5117i2PB4IZFYAhNAAIUfmbOIxAHinH+hFkDFcP40s
eH1kVWQUZ2hYTWLM0aGTLTLeGHzYhk5Pqw6Pu+KznQu7NE5qjbZ/l3+HDUGYDqHt
9gAijcBI0C5Ivk2MzhwcOs4ZG3NkZhtoKVgWadSlgemjIFvC5e0NaDikWE1ty/lD
Z+3pBto2JDz1XcpmG/5vPxaVUmGigZUdz2QX0mlmSoOosEw5ZUk8oMPY8R4xl6Db
aS+FqkL5P5MxHZNRBHEZ1aVNxyK82dBnRRw3gyI6q9XLXLM+xFO0WhISx8AvTTV6
fV5Hwd4qe3jAORP99t0ENlLvIq+vPfnFwmHRVvbKQcm0etWd1AfMZqrFpZ7Nb1mQ
ZqfxSRVht7DxFPJ6UGjwPEW/6/h7JzLNLUdp5HrwqQErRyYtEh9Nx4rnltiIcX0m
FojXPTQVoXdt8v4RPDc4qgwWSMX49ELL7npm7SBLagfoBMTrkrQ0grDIAEgsesoc
I1YwZwH1jdjXDXBuc7WAwOigaj74T+PiTJ+gm/NCDAeFqJDRq10JwDQ4yB002dY4
YwQFImaNY50yrwofpIDs
=h4G3
-----END PGP SIGNATURE-----

--08FKXsd1onNh2eUteTQTCui7lxcPqAIro--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
