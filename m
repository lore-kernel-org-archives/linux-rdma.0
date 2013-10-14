From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in
 uverbs =?UTF-8?Q?create=5Fflow?=
Date: Mon, 14 Oct 2013 17:46:57 +0200
Message-ID: <72b95284386dc57dfa1c7c883b4f45af@meuh.org>
References: <cover.1381510045.git.ydroneaud@opteya.com>
 <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
 <525C0BF2.2060201@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525C0BF2.2060201-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 14.10.2013 17:21, Matan Barak a =C3=A9crit=C2=A0:
> On 11/10/2013 8:19 PM, Yann Droneaud wrote:
>> Flow spec length don't depend on the size of the command
>> header: they are part of different layers.
>>=20
>> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
>> Link: http://marc.info/?i=3Dver.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>> Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>> ---
>>   drivers/infiniband/core/uverbs_cmd.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/infiniband/core/uverbs_cmd.c=20
>> b/drivers/infiniband/core/uverbs_cmd.c
>> index 3b732f6..1e5f0dd 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -2671,8 +2671,8 @@ ssize_t ib_uverbs_create_flow(struct=20
>> ib_uverbs_file *file,
>>          if (cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYER=
S)
>>                  return -EINVAL;
>>=20
>> -       if (cmd.flow_attr.size > (in_len - sizeof(cmd) - sizeof(stru=
ct
>> -           ib_uverbs_cmd_hdr_ex)) || cmd.flow_attr.size >
>> +       if (cmd.flow_attr.size > (in_len - sizeof(cmd)) ||
>> +           cmd.flow_attr.size >
>>              (cmd.flow_attr.num_of_specs * sizeof(struct=20
>> ib_kern_spec)))
>>                  return -EINVAL;
>>=20
>> --
>> 1.8.3.1
>>=20
>=20
> Hi,
>=20
> I agree that it was better if the command size we pass to the uverb
> didn't include the header size, but since the current implementation
> of ib_uverbs_write and its user-space counterpart passes the command
> size including the header - I think this fix is incorrect. I think
> it'll actually break the current implementation.

You're correct. I'm wrong. I broke this.

I'm so wrong, I've sent a whole patchset that *didn't* take this into=20
account.
See http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

I had to re-read it again:

         return uverbs_cmd_table[hdr.command](file, buf + sizeof hdr,
                                              hdr.in_words * 4,=20
hdr.out_words * 4);

Seems I'm not mentally trained to accept that the input buffer size
is larger than buffer it's related to. I keep thinking it's written

         return uverbs_cmd_table[hdr.command](file, buf + sizeof hdr,
                                              hdr.in_words * 4 - sizeof=
=20
hdr, hdr.out_words * 4);


And that's what I've proposed in the extensible infrastructure.

> Furthermore, patch 8 overwrites this anyway, so I guess we could
> reduce this patchset size by removing it.
>=20

I will follow your advice.

Let's try for inclusion in v3.12-rc6

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
