From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDS: sync congestion map updating
Date: Thu, 31 Mar 2016 09:24:59 +0800
Message-ID: <56FC7C6B.4040106@oracle.com>
References: <1459328902-31968-1-git-send-email-wen.gang.wang@oracle.com>
 <20160330161952.GA2670@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160330161952.GA2670-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

=E5=9C=A8 2016=E5=B9=B403=E6=9C=8831=E6=97=A5 00:19, Leon Romanovsky =E5=
=86=99=E9=81=93:
> On Wed, Mar 30, 2016 at 05:08:22PM +0800, Wengang Wang wrote:
>> Problem is found that some among a lot of parallel RDS communication=
s hang.
>> In my test ten or so among 33 communications hang. The send requests=
 got
>> -ENOBUF error meaning the peer socket (port) is congested. But meanw=
hile,
>> peer socket (port) is not congested.
>>
>> The congestion map updating can happen in two paths: one is in rds_r=
ecvmsg path
>> and the other is when it receives packets from the hardware. There i=
s no
>> synchronization when updating the congestion map. So a bit operation=
 (clearing)
>> in the rds_recvmsg path can be skipped by another bit operation (set=
ting) in
>> hardware packet receving path.
>>
>> Fix is to add a spin lock per congestion map to sync the update on i=
t.
>> No performance drop found during the test for the fix.
> I assume that this change fixed your issue, however it looks suspicio=
us
> that performance wasn't change.
Sure it I verified that patch fixes the issue.
=46or performance, I will reply to Santosh's email later, please check =
there.
>> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>   net/rds/cong.c | 7 +++++++
>>   net/rds/rds.h  | 1 +
>>   2 files changed, 8 insertions(+)
> According to get_maintainer script, you send this patch to wrong list=
s
> and persons.
>
> =E2=9E=9C  linux git:(master) ./scripts/get_maintainer.pl -f net/rds/=
cong.c
> Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> (supporter:RDS - REL=
IABLE DATAGRAM SOCKETS)
> "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> (maintainer:NETWORKING [GENER=
AL])
> netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:RDS - RELIABLE DATAGRAM SOCKETS)
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:RDS - RELIABLE DATAGRAM SOCKETS=
)

So linux-rdma is here :)

thanks,
wengang
> rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org (moderated list:RDS - RELIABLE DATAGRAM SOCK=
ETS)
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)
>
>> diff --git a/net/rds/cong.c b/net/rds/cong.c
>> index e6144b8..7afc1bf 100644
>> --- a/net/rds/cong.c
>> +++ b/net/rds/cong.c
>> @@ -144,6 +144,7 @@ static struct rds_cong_map *rds_cong_from_addr(_=
_be32 addr)
>>   	if (!map)
>>   		return NULL;
>>  =20
>> +	spin_lock_init(&map->m_lock);
>>   	map->m_addr =3D addr;
>>   	init_waitqueue_head(&map->m_waitq);
>>   	INIT_LIST_HEAD(&map->m_conn_list);
>> @@ -292,6 +293,7 @@ void rds_cong_set_bit(struct rds_cong_map *map, =
__be16 port)
>>   {
>>   	unsigned long i;
>>   	unsigned long off;
>> +	unsigned long flags;
>>  =20
>>   	rdsdebug("setting congestion for %pI4:%u in map %p\n",
>>   	  &map->m_addr, ntohs(port), map);
>> @@ -299,13 +301,16 @@ void rds_cong_set_bit(struct rds_cong_map *map=
, __be16 port)
>>   	i =3D be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
>>   	off =3D be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
>>  =20
>> +	spin_lock_irqsave(&map->m_lock, flags);
>>   	__set_bit_le(off, (void *)map->m_page_addrs[i]);
>> +	spin_unlock_irqrestore(&map->m_lock, flags);
>>   }
>>  =20
>>   void rds_cong_clear_bit(struct rds_cong_map *map, __be16 port)
>>   {
>>   	unsigned long i;
>>   	unsigned long off;
>> +	unsigned long flags;
>>  =20
>>   	rdsdebug("clearing congestion for %pI4:%u in map %p\n",
>>   	  &map->m_addr, ntohs(port), map);
>> @@ -313,7 +318,9 @@ void rds_cong_clear_bit(struct rds_cong_map *map=
, __be16 port)
>>   	i =3D be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
>>   	off =3D be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
>>  =20
>> +	spin_lock_irqsave(&map->m_lock, flags);
>>   	__clear_bit_le(off, (void *)map->m_page_addrs[i]);
>> +	spin_unlock_irqrestore(&map->m_lock, flags);
>>   }
>>  =20
>>   static int rds_cong_test_bit(struct rds_cong_map *map, __be16 port=
)
>> diff --git a/net/rds/rds.h b/net/rds/rds.h
>> index 80256b0..f359cf8 100644
>> --- a/net/rds/rds.h
>> +++ b/net/rds/rds.h
>> @@ -59,6 +59,7 @@ struct rds_cong_map {
>>   	__be32			m_addr;
>>   	wait_queue_head_t	m_waitq;
>>   	struct list_head	m_conn_list;
>> +	spinlock_t		m_lock;
>>   	unsigned long		m_page_addrs[RDS_CONG_MAP_PAGES];
>>   };
>>  =20
>> --=20
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
