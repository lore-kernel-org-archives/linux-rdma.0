From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Tue, 18 Nov 2014 23:42:09 +0200
Message-ID: <CAJ3xEMh5f-qZuYQ30frjUa0ETNxexh2igguxxRm-pVtERCwn-Q@mail.gmail.com>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com>
	<1416312682-7899-2-git-send-email-yishaih@mellanox.com>
	<546B59E2.2050707@mellanox.com>
	<546B72A1.2080403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546B72A1.2080403-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 18, 2014 at 6:24 PM, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

> The IB device pointer is not valid at all spots, for example after the HW
> Device was removed, that's why we set this information on the uverbs device.

let this (flag on the uverbs object) be, but still, no-no for

object->xxx_supported
object->yyy_supported
object->zzz_supported

but rather do

object->flags & XXX
object->flags & YYY
object->flags & ZZZ

where each of XXX/YYY/ZZZ are bits that mark support for features xxx/yyy/zzz
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
