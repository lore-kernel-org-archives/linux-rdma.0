From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCHv2] IB/srp: add change_queue_depth and change_queue_type
 support
Date: Fri, 30 Aug 2013 11:51:03 +0200
Message-ID: <52206B07.8030501@acm.org>
References: <521DB28C.9020803@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521DB28C.9020803-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/28/13 10:19, Jack Wang wrote:
> Hi,
>
> Below patch is new version which address comments from Bart.
>
>
>>From 62d87b4d546066b251e44a3cb468b16783df7ee4 Mon Sep 17 00:00:00 2001
> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Date: Mon, 26 Aug 2013 15:50:03 +0200
> Subject: [PATCH] IB/srp: add change_queue_depth/change_queue_type support
>
> Currently, it's not possible to change queue depth for device
> behind SRP host. Sometimes, we need to adjust queue_depth for
> performance reason(eg storage busy, we need lower queue_depth
> to avoid running into SCSI error handler), so this patch add
> support for SRP driver.
>
> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Tested-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
