From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Need help with strange mlx4_core error
Date: Mon, 3 Feb 2014 12:54:42 +0200
Message-ID: <CAJZOPZKydkaoru0XyT1nHQ5t9BGJQxbq1r4RcGZ0Gq9E9VGs=A@mail.gmail.com>
References: <CACaajQtQGZSepA8VLK1K20OspNa_WTv1DQ8SWYV7O9y6QV-Tgg@mail.gmail.com>
	<CAJZOPZJmdGutUQZ4icBrKRq-YPwD8TqtoLH9SgqNVx_CDjL0TQ@mail.gmail.com>
	<CACaajQtHzF9g2kp9MrAaQsvKUQdr10YVa+Np1danmAcR_rvLqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQtHzF9g2kp9MrAaQsvKUQdr10YVa+Np1danmAcR_rvLqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 3, 2014 at 9:27 AM, Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org> wrote:
> 2014-02-03 Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> What kernel you used before? can you please send here the dmesg output when
>> the mlx4_core driver loads with debug_level=1
>
>
> Before that i'm using 2.6.32 from debian squeeze... dmesg:
> [583789.683677] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
> [583789.683710] mlx4_core: Initializing 0000:03:00.0
> [583790.687071] mlx4_core 0000:03:00.0: FW version 2.6.900 (cmd intf
> rev 3), max commands 16


This is pretty much very old firmware, could you update it please with
the latest GA from the mellanox site and see if things smile back?
also send the "lspci | grep -i Mellanox"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
