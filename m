From: =?UTF-8?B?WXVjb25nIFN1biAo5Y+26Zuo6aOeKQ==?= <sunyucong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Raid10 and page cache
Date: Tue, 6 Dec 2011 14:01:24 -0800
Message-ID: <CAJygYd0_YGDiBpndSKscbLmBSu8L17zco08Q1K2zSd0w8ZXFCA@mail.gmail.com>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

wrong list, sorry!

On Tue, Dec 6, 2011 at 1:29 PM, Yucong Sun (=E5=8F=B6=E9=9B=A8=E9=A3=9E=
) <sunyucong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> I recently setup raid10 on 4 physical disk and have a iscsi serve it
> as a block device, and have been trying to tweak for performance.
>
> First thing I notice that MD seems to rely on page cache to flush
> changes to disk, =C2=A0is there any way to turn that off so changes a=
re
> flushed to the disk? like O_FSYNC|O_DIRECT does? The reason I want to
> turn it off is to understand the performance difference, =C2=A0I want=
 to be
> sure that page cache is truly acting as a write-back cache, I know on=
e
> can tune the dirty_* to control the cache flush, but I want to make
> sure that it is actually doing what I think it does.
>
> Then I notice in output of free, =C2=A0the number in Cache column is =
very
> low, however the Buffer is very high, my question is does Buffer here
> serves as a read cache? I couldn't find the answer anywhere else.
>
> My last question is that since MD seems already doing the cache, =C2=A0=
what
> effect would it have if I want to setup a LO device in front of MD
> device, Is there going to be more caching, how is different than just
> plain MD device?
>
> Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
