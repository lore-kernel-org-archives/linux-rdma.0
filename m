From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] Avoid linker error with clang 3.0
Date: Sun, 9 Dec 2012 13:47:03 -0800
Message-ID: <ABB9B291-3AB5-4AE6-8CE2-5FE691E1AE02@gmail.com>
References: <alpine.BSF.2.00.1212090306300.64779@toaster.local> <50C490D9.1000301@acm.org> <CAGH67wS1P43ssD+-VFyCupLw3CT8U73wT-aT6N2AS5ddWApAoA@mail.gmail.com> <CAGH67wQt48zEp0KiN44w=wfYZy+FA6oc=ehuAHUL2QBo=A1nhw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGH67wQt48zEp0KiN44w=wfYZy+FA6oc=ehuAHUL2QBo=A1nhw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Dec 9, 2012, at 11:28 AM, Garrett Cooper wrote:

> On Sun, Dec 9, 2012 at 11:06 AM, Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> ...
> 
>    It's still an issue with clang 3.2; going to file a bug upstream,
> but the attached patch allows the linker stage to go through properly.
> Thanks,
> -Garrett
> 
> # clang -o /root/test_inline /root/test_inline.c
> /tmp/test_inline-JRJ1GD.o: In function `foo':
> /root/test_inline.c:(.text+0x36): undefined reference to `bar'
> /root/test_inline.c:(.text+0x5f): undefined reference to `bar'
> /root/test_inline.c:(.text+0x88): undefined reference to `bar'
> /root/test_inline.c:(.text+0xb1): undefined reference to `bar'
> clang: error: linker command failed with exit code 1 (use -v to see invocation)
> # clang
> clang        clang++      clang-cpp    clang-tblgen
> # clang --version
> FreeBSD clang version 3.2 (branches/release_32 168974) 20121130
> Target: i386-unknown-freebsd10.0
> Thread model: posix
> # cat /root/test_inline.c
> #include <stdio.h>
> 
> inline int
> bar(int i)
> {
> 
>        return (42 < i && i < 84 ? i : -1);
> }
> 
> static void
> foo(void)
> {
> 
>        printf("-4: %d\n", bar(-4));
>        printf("41: %d\n", bar(41));
>        printf("43: %d\n", bar(43));
>        printf("85: %d\n", bar(85));
> }
> 
> int
> main(void)
> {
> 
>        foo();
>        return (0);
> }

	After talking with some other more knowledgeable people than myself, it looks like opensm is depending upon gcc inline behavior: http://freebsd.1045724.n5.nabble.com/C99-inlines-td4157849.html , http://wiki.freebsd.org/PortsAndClang (look for "undefined or duplicate symbols while linking"). The previously attached patch should be ok for dealing with the linking problem as it just changes the scoping. Definitely learned a few things today about gcc :).
Thanks,
-Garrett--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
