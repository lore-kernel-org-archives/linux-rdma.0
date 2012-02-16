From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/core: add RAW Packet QP type
Date: Thu, 16 Feb 2012 05:59:01 +0200
Message-ID: <CAJZOPZKbdQF1pb7wQNjk23D4hpVgsYF1RNvtq9zDVURLxkLRzA@mail.gmail.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1201171337040.26871@ogerlitz.voltaire.com>
	<1828884A29C6694DAF28B7E6B8A823732DC04FDC@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732DC04FDC-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?Q?Christoph_Lameter_=E2=80=8E?= <clameter-6oY5ZUoS/cfwvR0lvYjcXw@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 19, 2012 at 3:28 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> Applications that use this qp type should build the whole packet,
>> including link level headers when sending. On the receive side, the
>> HW isn't expected to strip any headers. The new qp type designated
>> usage is from user-space in Ethernet environments, e.g by applicatio=
ns
>> that do TCP/IP offloading. Only processes with the NET_RAW capabilit=
y
>> may open such qp. The name raw packet was selected to resemble the
>> similarity to AF_PACKET / SOL_RAW sockets.

>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Roland,

Also here, Sean provided his reviewed-by signature, people (CCed
Christoph and others) keep asking me about this patch set and I didn't
get any feedback from you.

Or.


>> =A0drivers/infiniband/core/uverbs_cmd.c | =A0 =A03 +++
>> =A0drivers/infiniband/core/verbs.c =A0 =A0 =A0| =A0 =A01 +
>> =A0include/rdma/ib_verbs.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
>> =A03 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/uverbs_cmd.c
>> b/drivers/infiniband/core/uverbs_cmd.c
>> index b930da4..8722e96 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -1399,6 +1399,9 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_f=
ile *file,
>> =A0 =A0 =A0 if (copy_from_user(&cmd, buf, sizeof cmd))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
>>
>> + =A0 =A0 if (cmd.qp_type =3D=3D IB_QPT_RAW_PACKET && !capable(CAP_N=
ET_RAW))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;
>> +
>> =A0 =A0 =A0 INIT_UDATA(&udata, buf + sizeof cmd,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long) cmd.response + si=
zeof resp,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in_len - sizeof cmd, out_len - si=
zeof resp);
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/co=
re/verbs.c
>> index 602b1bd..f73e15b 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -479,6 +479,7 @@ static const struct {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [IB_QPT_=
UD] =A0=3D (IB_QP_PKEY_INDEX =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 IB_QP_PORT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 IB_QP_QKEY),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [IB_QPT_RA=
W_PACKET] =3D IB_QP_PORT,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [IB_QPT_=
UC] =A0=3D (IB_QP_PKEY_INDEX =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 IB_QP_PORT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 IB_QP_ACCESS_FLAGS),
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index c3cca5a..6220b8b 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -605,7 +605,7 @@ enum ib_qp_type {
>> =A0 =A0 =A0 IB_QPT_UD,
>> =A0 =A0 =A0 IB_QPT_RAW_IPV6,
>> =A0 =A0 =A0 IB_QPT_RAW_ETHERTYPE,
>> - =A0 =A0 /* Save 8 for RAW_PACKET */
>> + =A0 =A0 IB_QPT_RAW_PACKET =3D 8,
>> =A0 =A0 =A0 IB_QPT_XRC_INI =3D 9,
>> =A0 =A0 =A0 IB_QPT_XRC_TGT,
>> =A0 =A0 =A0 IB_QPT_MAX
>> --
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
