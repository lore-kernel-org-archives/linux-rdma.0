From: Albert Strasheim <albert.strasheim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mellanox mlx4_core and SR-IOV
Date: Tue, 27 Nov 2012 06:54:48 +0200
Message-ID: <CALfB72AHagg7GF2i2vuBw4_M0QHw-xkbdSXmuJKvynv-ZjLMow@mail.gmail.com>
References: <AE94C31276ACE14591CDCF7F6B4E699455547DBF@SZXEML540-MBX.china.huawei.com>
 <CALY6xngZ2PTf6hiPcpQjaJDnGO=L9gMZg_h2d4S6MJx-+quUDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALY6xngZ2PTf6hiPcpQjaJDnGO=L9gMZg_h2d4S6MJx-+quUDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Zhangxiaofeng <victor.zhangxiaofeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello

TLDR: get firmware 2.9.1200 and wait for 3.7.

On Tue, Nov 27, 2012 at 4:30 AM, Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Nov 26, 2012 at 8:05 PM, Zhangxiaofeng
> <victor.zhangxiaofeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
>> Hello,
>> I tried to use SR-IOV virtualization for Mellanox ConnectX2 card with kernel 3.6.7.
>
> I'm not 100% sure, but I don't think that the CX2 supports SR-IOV - I
> think you need the CX3 for that.

It should work soon.

Some bits from Roland:

https://plus.google.com/115480450168703320714/posts/YmTB6sJM9GG

Also watch out for:

https://plus.google.com/115480450168703320714/posts/8AQ4oCA3o6k

Some bits from Mellanox:

"""
... this is a single function system where you pass the single
function to a guest VM. Issues related to FLR to a single function are
fixed in firmware release 2.9.1200.

The latest firmware GA version is 2.9.1000. You can create your own
intermediate firmware version 2.9.1200. Please, note that the
intermediate firmware version 2.9.1200 will not be supported.
"""

If you don't have the 2.9.1200 firmware, you will probably run into
this issue with function level reset:

http://marc.info/?t=132789095200001&r=1&w=2

2.9.1200 is hiding here:

http://www.mellanox.com/content/pages.php?pg=custom_firmware_table

See also:

http://www.mellanox.com/pdf/firmware/ConnectX2-FW-2_9_1200-release_notes.pdf

Cheers

Albert
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
