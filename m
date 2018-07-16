From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] IPoIB: use kvzalloc to allocate an array of bucket
 pointers
Date: Mon, 16 Jul 2018 20:18:29 +0200
Message-ID: <EF345418-FC8F-4104-88C5-38B7597453B5@oracle.com>
References: <1531144263-24717-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <20180716191953.28b7821d@virtuozzo.com>
Mime-Version: 1.0 (Mac OS X Mail 11.4 \(3445.8.2\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716191953.28b7821d@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Yuval Shaia <yuval.shaia@oracle.com>, Alex Vesker <valex@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Kees Cook <keescook@chromium.org>, Evgenii Smirnov <evgenii.smirnov@profitbricks.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org



> On 16 Jul 2018, at 18:19, Jan Dakinevich =
<jan.dakinevich@virtuozzo.com> wrote:
>=20
> On Mon,  9 Jul 2018 16:51:03 +0300
> Jan Dakinevich <jan.dakinevich@virtuozzo.com> wrote:
>=20
>> This table by default takes 32KiB which is 3rd memory order.

Only if PAGE_SIZE is 4KiB...

>> Meanwhile, this memory is not aimed for DMA operation and could be
>> safely allocated by vmalloc.
>>=20
>> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>

lgtm,

Reviewed-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>


Thxs, H=C3=A5kon

>> ---
>> drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> b/drivers/infiniband/ulp/ipoib/ipoib_main.c index 26cde95..cb752df
>> 100644 --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> @@ -1526,7 +1526,7 @@ static int ipoib_neigh_hash_init(struct
>> ipoib_dev_priv *priv) return -ENOMEM;
>> 	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
>> 	size =3D roundup_pow_of_two(arp_tbl.gc_thresh3);
>> -	buckets =3D kcalloc(size, sizeof(*buckets), GFP_KERNEL);
>> +	buckets =3D kvcalloc(size, sizeof(*buckets), GFP_KERNEL);
>> 	if (!buckets) {
>> 		kfree(htbl);
>> 		return -ENOMEM;
>> @@ -1554,7 +1554,7 @@ static void neigh_hash_free_rcu(struct rcu_head
>> *head) struct ipoib_neigh __rcu **buckets =3D htbl->buckets;
>> 	struct ipoib_neigh_table *ntbl =3D htbl->ntbl;
>>=20
>> -	kfree(buckets);
>> +	kvfree(buckets);
>> 	kfree(htbl);
>> 	complete(&ntbl->deleted);
>> }
>=20
> ping
>=20
> --=20
> Best regards
> Jan Dakinevich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
