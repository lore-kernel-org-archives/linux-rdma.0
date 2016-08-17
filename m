From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation offload
 (TSO)
Date: Wed, 17 Aug 2016 14:54:03 +0000
Message-ID: <HE1PR05MB1642C63E100E8950BF8FADE4AA140@HE1PR05MB1642.eurprd05.prod.outlook.com>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com>
 <4cf7c492-ed42-d9cc-38e8-15d8c50d585f@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/17/2016 9:35 AM, Sagi Grimberg wrote:=0A=
>> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h=0A=
>> index ccf1d51..87e4332 100644=0A=
>> --- a/include/infiniband/verbs.h=0A=
>> +++ b/include/infiniband/verbs.h=0A=
>> @@ -209,6 +209,13 @@ enum ibv_odp_general_caps {=0A=
>>  	IBV_ODP_SUPPORT =3D 1 << 0,=0A=
>>  };=0A=
>>=0A=
>> +#define ibv_is_qpt_supported(caps, qpt) ((caps) & (1 << (qpt)))=0A=
> This looks useful, but not directly related to this patch. Would=0A=
> be better to add it in a stand-alone patch (even if its a one-liner).=0A=
>=0A=
> Otherwise looks good,=0A=
>=0A=
> Reviewed-by: Sagi Grimberg <sag-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>=0A=
>=0A=
Hi Sagi,=0A=
=0A=
Thanks for reviewing. This macro will be used by the TSO to check the=0A=
capabilities(devinfo.c), so it's actually related to this patch.=0A=
=0A=
Best Regards,=0A=
=0A=
Bodong=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
