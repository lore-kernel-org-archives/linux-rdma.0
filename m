From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: librdmacm in rdma-core build warnings
Date: Mon, 2 Oct 2017 21:27:46 +0300
Message-ID: <CALq1K=+At0ytaxUs4NbznwkYx7+dL+XLtCUaxbVAMLb0WjyqRw@mail.gmail.com>
References: <20171002061532.GJ2031@mtr-leonro.local> <1828884A29C6694DAF28B7E6B8A82373AB199DAC@ORSMSX109.amr.corp.intel.com>
 <20171002175431.GB13149@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002175431.GB13149-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 2, 2017 at 8:54 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Oct 02, 2017 at 04:11:01PM +0000, Hefty, Sean wrote:
>> > [26/189] Building C object
>> > librdmacm/CMakeFiles/rspreload.dir/preload.c.o
>> > ../librdmacm/preload.c:818:9: warning: no previous prototype for
>> > ???readv??? [-Wmissing-prototypes]  ssize_t readv(int socket, const struct
>> > iovec *iov, int iovcnt)
>> >          ^~~~~
>> > ../librdmacm/preload.c:857:9: warning: no previous prototype for
>> > ???writev??? [-Wmissing-prototypes]  ssize_t writev(int socket, const
>> > struct iovec *iov, int iovcnt)
>>
>> Does including sys/uio.h fix this?
>
> Something like that is the right solution, probably caused by glibc
> changes not gcc changes...
>
> The prototype must come from glibc headers.

Thanks Sean and Jason.

It fixed the warnings, I'll send proper patch tomorrow once I'll be at
the office.

diff --git a/librdmacm/preload.c b/librdmacm/preload.c
index dfc23648..3ed0242e 100644
--- a/librdmacm/preload.c
+++ b/librdmacm/preload.c
@@ -51,6 +51,8 @@
 #include <stdlib.h>
 #include <stdio.h>

+#include <sys/uio.h>
+
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
 #include <rdma/rsocket.h>

Thanks

>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
