From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Add QP creation flags, allow
 blocking UD multicast loopback
Date: Thu, 18 Sep 2014 15:51:38 +0300
Message-ID: <541AD55A.50102@mellanox.com>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>	 <1410700802-27848-2-git-send-email-ogerlitz@mellanox.com> <1410799972.7830.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410799972.7830.25.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/15/2014 7:52 PM, Yann Droneaud wrote:
> Hi,
>
> Le dimanche 14 septembre 2014 =C3=A0 16:20 +0300, Or Gerlitz a =C3=A9=
crit :
> Commit identifier is too short, 12 digits is the norm.=20

OK, will fix

>> As a result, applications who send and recieve over the same QP to
>> the same multicast group get all their packets bouncded back to them=
,
>> which is terribly bad performance wise.
>>
>> To fix this long standing issue, add the ability to provide QP
>> creation flags through uverbs.
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/infiniband/core/uverbs_cmd.c |   35 ++++++++++++++++++++++=
++++++++++-
>>   include/uapi/rdma/ib_user_verbs.h    |    2 +-
>>   2 files changed, 34 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniba=
nd/core/uverbs_cmd.c
>> index 0600c50..1ad489c 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -1579,6 +1579,31 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs=
_file *file,
>>   	return in_len;
>>   }
>>  =20
>> +enum ib_uverbs_qp_create_flags {
>> +	IB_UVERBS_QP_CREATE_LSO	    =3D 0,
>> +	IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK =3D 1,
>> +	IB_UVERBS_SUPPORTED_FLAGS
>> +};
> IB_UVERBS_QP_CREATE_LSO and IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPB=
ACK
> should moved in include/uapi/rdma/ib_user_verbs.h.
>
> If this is going to be flags, these values might be OR-ed together ?
> Then the userspace values should be defined like the kernel ones
> (see commit 47ee1b9f2e7b):
>
> +enum ib_uverbs_qp_create_flags {
> +	IB_UVERBS_QP_CREATE_LSO	    =3D                  1 << 0,
> +	IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK =3D 1 << 1,
> +}
>

Some misunderstanding here.. enum ib_uverbs_qp_create_flags is internal=
=20
kernel construct used
to check the flags provided by user space (the _flags suffix is=20
confusing, will remove it). The actual flags
values to be used by user space are shifted values (e.g 1 <<=20
IB_UVERBS_QP_CREATE_LSO).

As the whole set of flags/enum/attribute values moved between libibverb=
s=20
to the kernel, this will be defined
in libibverbs header (take a look on include/uapi/rdma/ib_user_verbs.h=20
it doesn't have the enumeration for event types defined).


> IB_UVERBS_SUPPORTED_FLAGS must be kept in this module, but defined
> as:
>
> #define IB_UVERBS_QP_CREATE_FLAGS_ALL (IB_UVERBS_QP_CREATE_LSO | \
> 				       IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
>
>> +
>> +static int ib_uverbs_create_qp_trans(u8 u_flags)
>> +{
>> +	int i;
>> +	int res;
>> +	static const enum ib_qp_create_flags ib_uverbs_qp_create_flags[IB_=
UVERBS_SUPPORTED_FLAGS] =3D {
>> +		[IB_UVERBS_QP_CREATE_LSO] =3D IB_QP_CREATE_IPOIB_UD_LSO,
>> +		[IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK] =3D IB_QP_CREATE_B=
LOCK_MULTICAST_LOOPBACK,
>> +	};
>> +
>> +	if (u_flags & ~((1 << IB_UVERBS_SUPPORTED_FLAGS) - 1))
>> +		return -1;
>> +
> 	if (u_flags & ~(u8)(IB_UVERBS_QP_CREATE_FLAGS_ALL))
> 	   return -1;
>
>> +	for (i =3D 0; i < IB_UVERBS_SUPPORTED_FLAGS; i++)
>> +		if (u_flags & (1 << i))
>> +			res |=3D ib_uverbs_qp_create_flags[i];
>> +
>> +	return res;
>> +}
>> +
> This function can be replaced by compile time assert:
>
> BUILD_BUG_ON(IB_UVERBS_QP_CREATE_LSO !=3D IB_QP_CREATE_IPOIB_UD_LSO);
> BUILD_BUG_ON(IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK !=3D
> IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK);
>
> This way the values can be used without conversion.

We prefer to have larger flexibility here which we can do with run time=
=20
checks (this is slow path) and remain with the practice suggested by th=
e=20
original patch.


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
