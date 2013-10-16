From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/netlink: remove superfluous =?UTF-8?Q?RDMA=5FNL=5F?=
 =?UTF-8?Q?GET=5FOP=28=29=20masking?=
Date: Wed, 16 Oct 2013 10:08:09 +0200
Message-ID: <109afe07b19a529bd9e5001fa5324838@meuh.org>
References: <1380571434-15391-1-git-send-email-minipli@googlemail.com>
 <CA+rthh87D+yLE-nTQwVG-LGar_e8sYUKievWUnmk30RH-q7=GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+rthh87D+yLE-nTQwVG-LGar_e8sYUKievWUnmk30RH-q7=GA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 15.10.2013 18:10, Mathias Krause a =C3=A9crit=C2=A0:
> On 30 September 2013 22:03, Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>=20
> wrote:
>> 'op' is the already RDMA_NL_GET_OP() masked 'type'. No need to mask =
it
>> again.
>>=20
>> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
>> ---
>>  drivers/infiniband/core/netlink.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/infiniband/core/netlink.c=20
>> b/drivers/infiniband/core/netlink.c
>> index da06abd..a1e9cba 100644
>> --- a/drivers/infiniband/core/netlink.c
>> +++ b/drivers/infiniband/core/netlink.c
>> @@ -148,7 +148,7 @@ static int ibnl_rcv_msg(struct sk_buff *skb,=20
>> struct nlmsghdr *nlh)
>>         list_for_each_entry(client, &client_list, list) {
>>                 if (client->index =3D=3D index) {
>>                         if (op < 0 || op >=3D client->nops ||
>> -                          =20
>> !client->cb_table[RDMA_NL_GET_OP(op)].dump)
>> +                           !client->cb_table[op].dump)
>>                                 return -EINVAL;
>>=20
>>                         {
>> --
>> 1.7.10.4
>>=20
>=20

> Ping. Comments, anybody?
>=20

I confirm RDMA_NL_GET_OP() is already applied on op.

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
