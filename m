From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libmlx5] Add TSO support for RAW Ethernet QP
Date: Wed, 17 Aug 2016 14:55:44 +0000
Message-ID: <HE1PR05MB16423020CBBB3C19AC1E8BE5AA140@HE1PR05MB1642.eurprd05.prod.outlook.com>
References: <1469710139-17063-1-git-send-email-yishaih@mellanox.com>
 <50e8e02d-e770-8cdc-39cf-0c0187fd400d@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/17/2016 9:42 AM, Sagi Grimberg wrote:=0A=
>> diff --git a/src/mlx5.h b/src/mlx5.h=0A=
>> index feb095c..5833339 100644=0A=
>> --- a/src/mlx5.h=0A=
>> +++ b/src/mlx5.h=0A=
>> @@ -209,7 +209,7 @@ enum {=0A=
>>  	MLX5_OPCODE_RDMA_WRITE_IMM	=3D 0x09,=0A=
>>  	MLX5_OPCODE_SEND		=3D 0x0a,=0A=
>>  	MLX5_OPCODE_SEND_IMM		=3D 0x0b,=0A=
>> -	MLX5_OPCODE_LSO			=3D 0x0e,=0A=
>> +	MLX5_OPCODE_TSO			=3D 0x0e,=0A=
> Same opcode? was this a typo?=0A=
>=0A=
> Other than that, looks pretty straight forward,=0A=
>=0A=
> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>=0A=
>=0A=
We decided to change the name to TSO after discussing with community. LSO i=
s=0A=
kind of Windows name.=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
