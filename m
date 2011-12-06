From: =?UTF-8?B?WXVjb25nIFN1biAo5Y+26Zuo6aOeKQ==?= <sunyucong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Raid10 and page cache
Date: Tue, 6 Dec 2011 13:29:23 -0800
Message-ID: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I recently setup raid10 on 4 physical disk and have a iscsi serve it
as a block device, and have been trying to tweak for performance.

First thing I notice that MD seems to rely on page cache to flush
changes to disk,  is there any way to turn that off so changes are
flushed to the disk? like O_FSYNC|O_DIRECT does? The reason I want to
turn it off is to understand the performance difference,  I want to be
sure that page cache is truly acting as a write-back cache, I know one
can tune the dirty_* to control the cache flush, but I want to make
sure that it is actually doing what I think it does.

Then I notice in output of free,  the number in Cache column is very
low, however the Buffer is very high, my question is does Buffer here
serves as a read cache? I couldn't find the answer anywhere else.

My last question is that since MD seems already doing the cache,  what
effect would it have if I want to setup a LO device in front of MD
device, Is there going to be more caching, how is different than just
plain MD device?

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
