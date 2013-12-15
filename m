From: Ydroneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 for-3.13 8/9] IB/uverbs: check access to userspace response buffer in extended command
Date: Sun, 15 Dec 2013 18:44:00 +0100
Message-ID: <E1VsFjU-0003cU-6T@ou.quest-ce.net>
References: <CAL1RGDVThe_=F3EOCzYfxB8zCgv+4Z_PXiYEPqnphMEOi-drbw@mail.gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVThe_=F3EOCzYfxB8zCgv+4Z_PXiYEPqnphMEOi-drbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

> On Wed, Dec 11, 2013 at 2:01 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
>> Just like vfs_read(), uverbs_write() must check output buffer
>> (eg. response) with access_ok(VERIFY_WRITE,...) to ensure
>> it's in userspace memory before using the pointer in uverbs
>> functions.

> Is there any place where we use this pointer through something other
> than copy_to_user()?  I don't think there is or ever should be, in
> which case this check is redundant.

Since this check is applied on the 'extended' uverbs, there's only a limited amount
of existing code to check.
Anyway the purpose of this check is to ensure that *whole* buffer passed as response
buffer is valid, and the whole buffer may be larger than the response to be returned.

Just like the check in read(2) syscall, it's a sanity check to refuse to process
malformed syscall:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/read_write.c#n389

This particular check was added by Linus in 2005, the commit message might be interesting:

https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/?id=fd770e66c9a65b14ce114e171266cf6f393df502

  Make read/write always do the full "access_ok()" tests.
  
  The actual user copy will do them too, but only for the
  range that ends up being actually copied. That hides
  bugs when the range has been clamped by file size or other
  issues.

So I don't see this check as redundant with call to copy_to_user(),
it's checking a different thing.

Regards.

-- 
Yann Droneaud
OPTEYA
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
