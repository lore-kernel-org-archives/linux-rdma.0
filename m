From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/4] IB/core: extended command: an improved
 infrastructure for uverbs commands
Date: Wed, 09 Oct 2013 14:42:30 +0200
Message-ID: <aed172268c582761ad08767119877942@meuh.org>
References: <cover.1381177342.git.ydroneaud@opteya.com>
 <70486466a70aae3e3facf5a12c1d0bb960a9a462.1381177342.git.ydroneaud@opteya.com>
 <5255402F.4000806@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5255402F.4000806-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 09.10.2013 13:38, Or Gerlitz a =C3=A9crit=C2=A0:
> On 07/10/2013 23:49, Yann Droneaud wrote:
>> Commit 400dbc9 added an infrastructure for extensible uverbs
>> commands while later commit 436f2ad exported=20
>> ib_create_flow()/ib_destroy_flow()
>> functions using this new infrastructure.
>>=20
>> According to the commit 400dbc9, the purpose of this infrastructure =
is
>> to support passing around provider (eg. hardware) specific buffers
>> when userspace issue commands to the kernel, so that it would be=20
>> possible
>> to extend uverbs (eg. core) buffers independently from the provider=20
>> buffers.
>>=20
>> But the new kernel command function prototypes were not modified
>> to take advantage of this extension. This issue was exposed by
>> Roland Dreier in:
>>=20
>>    Subject: Re: [PATCH V2 for-next 2/4] IB/core: Infra-structure to=20
>> support verbs extensions through uverbs
>>    Date: 2013-06-26 13:05:16 GMT
>>   =20
>> Message-Id:<CAL1RGDWxmM17W2o_era24A-TTDeKyoL6u3NRu_=3Dt_dhV_ZA9MA@ma=
il.gmail.com>
>>=20
>> So the following patch is an attempt to a revised extensible command
>> infrastructure.
>=20
> Yan, repeating my request, could you please remove all references to
> email threads from the change-logs of your series and resend it.
>=20

I've removed all the other related to the previous submissions of the=20
patch.

> FWIW you can leave them in the section below the --- line so git am
> will not pick them.
>=20

I'm gonna add the reference to Roland's remarks as a Link: tag. Is is O=
K=20
this way ?

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
