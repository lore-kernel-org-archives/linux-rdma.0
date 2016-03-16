From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [WTF] utterly tasteless ABI in hfi1 (around ->write()/->write_iter())
Date: Tue, 15 Mar 2016 21:34:03 -0700
Message-ID: <CA+55aFyQ5=OTcsw8i6WKrVT9r0gDWsGh=Bii-YyC7B3UVLO0sw@mail.gmail.com>
References: <20160316041717.GJ17997@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160316041717.GJ17997@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Marciniszyn <infinipath@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 15, 2016 at 9:17 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         Take a look at drivers/staging/rdma/hfi1/file_ops.c in -next and
> compare hfi1_write_iter() with hfi1_file_write().  Folks, this ABI is too
> ugly to live, let alone to be allowed breeding.
>
>         It's also brittle as hell - trivial massage around fs/read_write.c
> and fs/aio.c is quite capable of breaking that shit.  Arguably, IOCB_CMD_PWRITE
> and IOCB_CMD_PWRITEV both triggering your writev() semantics is an example of
> just such breakage.  Sigh...

We could just decide that if a file descriptor has both ->write and
->write_iter entities, we always pick ->write_iter in the vfs layer.

That way it's always consistent.

Simple ordering change in __vfs_write()..

We can switch is back later, but make sure it hits a release or two.
Or at least a few rc's, to flush out any problems.

Anybody who thinks that they can have different semantics for write()
and writev() is just completely broken.

              Linus
