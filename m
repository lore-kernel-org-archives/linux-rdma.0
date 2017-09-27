From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 05/20] RDMA/hns: Add command queue support for
 hip08 RoCE driver
Date: Wed, 27 Sep 2017 08:21:13 -0400
Message-ID: <1b8bda3b-c514-7e46-08bf-3ea50ea68096@redhat.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
 <1504084998-64397-6-git-send-email-xavier.huwei@huawei.com>
 <1506359213.120853.75.camel@redhat.com>
 <20170925171821.GQ25094@mtr-leonro.local>
 <1506361015.120853.81.camel@redhat.com> <59CA5261.80209@huawei.com>
 <81dd332d-e060-d7e3-bec9-1791511c5470@redhat.com>
 <9172f8c5-3dd6-a573-8e28-1b3ae4b1726b@tom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ro5C2U4eTdQvEhlRPHRVh8Cw4qFOn0smW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9172f8c5-3dd6-a573-8e28-1b3ae4b1726b-WVlzvzqoTvw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ro5C2U4eTdQvEhlRPHRVh8Cw4qFOn0smW
Content-Type: multipart/mixed; boundary="fQFpOw0iVEURaBIwIveBsUB1xAFCikdC5";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Wei Hu (Xavier)" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
 liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
 linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <1b8bda3b-c514-7e46-08bf-3ea50ea68096-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 05/20] RDMA/hns: Add command queue support for
 hip08 RoCE driver
References: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 <1504084998-64397-6-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 <1506359213.120853.75.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925171821.GQ25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <1506361015.120853.81.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <59CA5261.80209-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 <81dd332d-e060-d7e3-bec9-1791511c5470-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <9172f8c5-3dd6-a573-8e28-1b3ae4b1726b-WVlzvzqoTvw@public.gmane.org>
In-Reply-To: <9172f8c5-3dd6-a573-8e28-1b3ae4b1726b-WVlzvzqoTvw@public.gmane.org>

--fQFpOw0iVEURaBIwIveBsUB1xAFCikdC5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/26/2017 10:46 PM, Wei Hu (Xavier) wrote:
>=20
>=20
> On 2017/9/27 0:18, Doug Ledford wrote:
>> On 9/26/2017 9:13 AM, Wei Hu (Xavier) wrote:
>>>
>>> On 2017/9/26 1:36, Doug Ledford wrote:
>>>> On Mon, 2017-09-25 at 20:18 +0300, Leon Romanovsky wrote:
>>>>> On Mon, Sep 25, 2017 at 01:06:53PM -0400, Doug Ledford wrote:
>>>>>> On Wed, 2017-08-30 at 17:23 +0800, Wei Hu (Xavier) wrote:
>>>>>>
>>>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * If the command is sync, wait for the =
firmware to
>>>>>>> write
>>>>>>> back,
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * if multi descriptors to be sent, use =
the first one to
>>>>>>> check
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>>>> +=C2=A0=C2=A0=C2=A0 if ((desc->flag) & HNS_ROCE_CMD_FLAG_NO_INTR)=
 {
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do {
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (hns_roce_cmq_csq_done(hr_dev))
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 usleep_range(1000, 2000);
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 timeout++;
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (timeout < pr=
iv->cmq.tx_timeout);
>>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>> then we spin here for a maximum amount of time between 200 and
>>>>>> 400ms,
>>>>>> so 1/4 to 1/2 a second.=C2=A0 All the time we are holding the bh l=
ock on
>>>>>> this CPU.=C2=A0 That seems excessive to me.=C2=A0 If we are going =
to spin
>>>>>> that
>>>>>> long, can you find a way to allocate/reserve your resources, send
>>>>>> the
>>>>>> command, then drop the bh lock while you spin, and retake it befor=
e
>>>>>> you
>>>>>> complete once the spinning is done?
>>>>> They don't allocate anything in this loop, but checking the pointer=
s
>>>>> are
>>>>> the same, see hns_roce_cmq_csq_done.
>>>> I'm not sure I understand your intended implication of your comment.=
=C2=A0 I
>>>> wasn't concerned about them allocating anything, only that if the
>>>> hardware is hung, then this loop will hang out for 1/4 to 1/2 a seco=
nd
>>>> and hold up all bottom half processing on this CPU in the meantime.
>>>> That's the sort of things that provides poor overall system behavior=
=2E
>>>>
>>>> Now, since they are really only checking to see if the hardware has
>>>> gotten around to their particular command, and their command is part=
 of
>>>> a ring structure, it's possible to record the original head command,=

>>>> and our new head command, and then release the spin_lock_bh around t=
he
>>>> entire do{ }while construct, and in hns_roce_cmd_csq_done() you coul=
d
>>>> check that head is not in the range old_head:new_head.=C2=A0 That wo=
uld
>>>> protect you in case something in the bottom half processing queued u=
p
>>>> some more commands and from one sleep to the next the head jumped fr=
om
>>>> something other than the new_head to something past new_head, so tha=
t
>>>> head =3D=3D priv->cmq.csq.next_to_use ends up being perpetually fals=
e.
>>>> But, that's just from a quick read of the code, I could easily be
>>>> missing something here...
>>> Hi, Doug
>>> =C2=A0=C2=A0=C2=A0=C2=A0 Driver issues the cmds in cmq, and firmware =
gets and processes
>>> them.
>>> =C2=A0=C2=A0=C2=A0=C2=A0 The firmware process only one cmd at the sam=
e time, and it will
>>> take
>>> =C2=A0=C2=A0=C2=A0=C2=A0 about serveral to 200 us in one cmd currentl=
y, so the driver need
>>> =C2=A0=C2=A0=C2=A0=C2=A0 not to use stream mode to issue cmd.
>> I'm not sure I understand your response here.
>>
>> I get that the driver issues cmds in the cmq, and that the firmware ge=
ts
>> them and processes them.
>>
>> I get that the firmware will only work on one command at a time and on=
ly
>> move to the next one once the current one is complete.
>>
>> I get that commands take anywhere from a few usec to a couple hundred
>> usec.
>>
>> I also get that because you are sleeping for somewhere in between 1000=

>> and 2000 usecs, that the driver could easily finish a whole slew of
>> commands.=C2=A0 It could do 10 slow commands, or 100 or more fast comm=
ands.
>> What this tells me is that the only reason your current implementation=

>> of hns_roce_cmq_csq_done() works at all is because you keep the device=

>> locked out from any other commands being put on the queue.=C2=A0 As fa=
r as I
>> can tell, that's the only way you can guarantee that at some point you=

>> will wake up and the head pointer will be exactly at csq->next_to_use.=

>> Otherwise, if you didn't block them out, then you could sleep with the=

>> head pointer before csq->next_to_use and wake up the next time with it=

>> already well past csq->next_to_use.=C2=A0 Am I right about that?=C2=A0=
 While you
>> are waiting on this command queue, any other commands are blocked from=

>> being placed on the command queue?
> Hi, Doug,
> you are right.
> And one "hns_x" ib device only has one command queue in hip08,
> other commands will be blocked when waiting on the command queue.
>>
>> I don't understand what you mean by "so the driver need not to use
>> stream mode to issue cmd".
> Sorry, my expression error.
> stream -> pipeline
>=20
> And if you argee, after this patchset has been accepted we will send a
> following up patch :
> =C2=A0=C2=A0=C2=A0 In hns_roce_cmq_send function, replace
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 usleep_range(1000, 2000);
> =C2=A0=C2=A0=C2=A0 with the following statement:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 udelay(1);
> =C2=A0=C2=A0=C2=A0 And if so, we can avoid using usleep_range function =
in spin_lock_bh
> spin region,
> =C2=A0=C2=A0=C2=A0 because it probally cause calltrace.

Ok, I'm fine with that.  I'll pull these in.



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--fQFpOw0iVEURaBIwIveBsUB1xAFCikdC5--

--Ro5C2U4eTdQvEhlRPHRVh8Cw4qFOn0smW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZy5e/AAoJELgmozMOVy/dLzMQALZJ7FeVSaHZERu8dqvJpHg1
Zqum/VCuf4pr74zCUSmqSf0I9s/Z7LMqDkwjEzHhB3ySpPaKKueq7EvnlzH8+dsC
mU9/IpinCTNNqPboN5q7DHYxwU0hgmoVc80glWOgEpmZu7H08a3MEC7mFeO04+3Y
hnXI4+4/Qe/Pwyekfbg6gfPtjgvw009+OEj7Xpicn+MM03SI3aAl1b61mP3TAlFl
SpvseSll3HqTcmBrNnAR/z0p03j4642H58bpFQDYag/snZ2A2yBFPZjKuissqSu0
S4PmhYsNaTBC0dkDSkGOOYp3jg5hJCpMoZTm97SE8jxngsAUupSOca+/X3FnXIo1
rfSyveOS9H9UlLOzHVEMm6KwEHD2lsVlpDEkWOGHxjaAP3EDFzupG+GGapNUDwlf
Wc9m9vNr5auE+Z8tTYPGCPPxU9F01jW94EORyhChF+5GUidYSuTOX0Pw9bALKjni
3I44ndo70eAQWS1p9qQZisBm61JMBW7f6+lnjtUjvbZHvBn+MaHMwwtfiEE/NWgj
0JCpSK4rNO6rprWLMUzHGe5rAwPEN0qKvaUdBQanbVcNVLc34FQ7BWq9Edlsfics
lzabi8JTxbKdK8IUiq6dO329f9gGCyxntpFIa8TGNHJo2eGMEcVln4k7OhcwUgx8
msauEzDivAEiTAWTGSIg
=WgSN
-----END PGP SIGNATURE-----

--Ro5C2U4eTdQvEhlRPHRVh8Cw4qFOn0smW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
