From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 06/17] IB/core: Add support for extended query device
 caps
Date: Wed, 10 Dec 2014 16:54:14 +0200
Message-ID: <54885E96.4040401@mellanox.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
	 <1415723783-2138-7-git-send-email-haggaie@mellanox.com>
 <1418216676.11111.45.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418216676.11111.45.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/12/2014 15:04, Yann Droneaud wrote:
> Le mardi 11 novembre 2014 =C3=A0 18:36 +0200, Haggai Eran a =C3=A9cri=
t :
>> From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>
>> Add extensible query device capabilities verb to allow adding new fe=
atures.
>> ib_uverbs_ex_query_device is added and copy_query_dev_fields is used=
 to copy
>> capability fields to be used by both ib_uverbs_query_device and
>> ib_uverbs_ex_query_device.
>>
>> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
=2E..

>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniba=
nd/core/uverbs_cmd.c
>> index 5ba2a86aab6a..74ad0d0de92b 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c

=2E..

>> @@ -3253,3 +3259,36 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverb=
s_file *file,
>> =20
>>  	return ret ? ret : in_len;
>>  }
>> +
>> +int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>> +			      struct ib_udata *ucore,
>> +			      struct ib_udata *uhw)
>> +{
>> +	struct ib_uverbs_ex_query_device_resp resp;
>> +	struct ib_uverbs_ex_query_device  cmd;
>> +	struct ib_device_attr attr;
>> +	struct ib_device *device;
>> +	int err;
>> +
>> +	device =3D file->device->ib_dev;
>> +	if (ucore->inlen < sizeof(cmd))
>> +		return -EINVAL;
>> +
>> +	err =3D ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
>> +	if (err)
>> +		return err;
>> +
>=20
> I believe you should had a check on cmd.comp_mask being 0.
> ib_uverbs_ex_create_flow() has such check.

I agree create_flow() should have such a check, but I think that would
be problematic for a query verb like query_device(). Imagine a newer
version of libibverbs and user space application running against an
older kernel. The application wants to know which newer feature it can
use, so it turns on every bit they are interested in their comp_mask.
The older kernel doesn't support all these features, so it fails the
request. The application will now need to try again, with a subset of
the features.

This flow seems unnecessarily complicated to me. I think in a verb that
has no side effects like this one, it would be better for the kernel to
just return the supported features in the response comp_mask field.

>> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/i=
b_user_verbs.h
>> index 26daf55ff76e..ed8c3d9da42c 100644
>> --- a/include/uapi/rdma/ib_user_verbs.h
>> +++ b/include/uapi/rdma/ib_user_verbs.h
>> @@ -201,6 +202,15 @@ struct ib_uverbs_query_device_resp {
>>  	__u8  reserved[4];
>>  };
>> =20
>> +struct ib_uverbs_ex_query_device {
>> +	__u32 comp_mask;
>=20
> _ex command buffer are supposed to be aligned on 64bit boundary.
> You should add some padding at the end of the structure and add a che=
ck
> for it being 0.

You're right. I will send an updated patch.

>=20
>> +};
>> +
>> +struct ib_uverbs_ex_query_device_resp {
>> +	struct ib_uverbs_query_device_resp base;
>> +	__u32 comp_mask;
>> +};
>> +
>=20
> _ex response buffer are supposed to be aligned on 64bit boundary:
> you should probably add padding at the end of the structure and ensur=
e
> it's cleared before send it to userspace.
>=20
> See commit f21519b23c1b ('IB/core: extended command: an improved
> infrastructure for uverbs commands').

I will do that.

Thank you for reviewing the patch,

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
