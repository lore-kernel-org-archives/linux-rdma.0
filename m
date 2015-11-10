From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Tue, 10 Nov 2015 07:36:25 -0500
Message-ID: <5641E4C9.7000206@talpey.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
 <1447156270.7089.3.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447156270.7089.3.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/10/2015 6:51 AM, Yann Droneaud wrote:
> Le mardi 10 novembre 2015 =C3=A0 12:44 +0200, Sagi Grimberg a =C3=A9c=
rit :
>> Also, set rdma_read_access_flags in the relevant device drivers:
>> mlx4, mlx5, qib, ocrdma, nes: IB_ACCESS_LOCAL_WRITE
>> cxgb3, cxgb4, hfi: IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE
>>
>
> Why were those hw providers not modified to
> enforce IB_ACCESS_REMOTE_WRITE when needed, instead of asking users t=
o
> set it for them ?

Because the Linux verbs don't tell the driver whether the registration
is for an RDMA Read sink buffer.

Sagi, the Windows NDKPI has an NDK_MR_FLAG_RDMA_READ_SINK attribute
which the upper layer can use to convey this information, I've mentione=
d
it here before.
https://msdn.microsoft.com/en-us/library/windows/hardware/hh439908(v=3D=
vs.85).aspx

When this approach is used, the upper layer doesn't have to be aware
at all of the lower layer's details.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
