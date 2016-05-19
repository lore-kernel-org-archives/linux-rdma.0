From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Thu, 19 May 2016 11:35:41 -0500
Message-ID: <060c01d1b1ec$7b9e5fb0$72db1f10$@opengridcomputing.com>
References: <20160518220302.81260E09E9@smtp.ogc.us> <20160518222857.GB23835@obsidianresearch.com> <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > These days, in user space this sort of stuff should be done following
> > the C11 atomic memory ordering model and not by trying to shoe-horn in
> > the kernel model. Then the compiler takes care of things properly.
> >
> > This is using calls like atomic_store, atomic_load and
> > atomic_thread_fence to create the same sort of barriers.
> >
> > You could probably implement the Xmbs() with variations on
> > atomic_thread_fence ??
> 
> Looking at the documentation, it is not clear to me which parameter value
passed
> to atomic_thread_fence() maps to each of the mb services.  Is it correct to
> think that if I get it right, the resulting assembly should be what we
currently
> have for the mb services?
> 
> Or perhaps someone else can provide guidance?
> 

I created a simple program to call  __atomic_thread_fence() with the various
parameters, using the x64 architecture.  Only __ATOMIC_SEQ_CST seems to add any
code (mfence) when the binary is inspected with 'objdump -lS'.  The rest are
no-ops.  I'm not sure this will work for libibeverbs.  

Here is the program, compiled with -g -O0:

-----
[root@stevo3 ~]# cc -g -O0  atomic_thread_fence.c   -o atomic_thread_fence
[root@stevo3 ~]# cat atomic_thread_fence.c
#include <stdio.h>

#define mb() __atomic_thread_fence(__ATOMIC_SEQ_CST)

int main(int argc, char *argv[])
{
        int a;

        a = 1;
        printf("ATOMIC_RELAXED\n");
        __atomic_thread_fence(__ATOMIC_RELAXED);
        a = 2;
        printf("ATOMIC_CONSUME\n");
        __atomic_thread_fence(__ATOMIC_CONSUME);
        a = 3;
        printf("ATOMIC_RELEASE\n");
        __atomic_thread_fence(__ATOMIC_RELEASE);
        a = 4;
        printf("ATOMIC_ACQ_REL\n");
        __atomic_thread_fence(__ATOMIC_ACQ_REL);
        a = 5;
        printf("ATOMIC_SEQ_CST\n");
        __atomic_thread_fence(__ATOMIC_SEQ_CST);
        printf("a=%d\n", a);
}
-----

Here is the objdump snipit:

-----
int main(int argc, char *argv[])
{
  400580:       55                      push   %rbp
  400581:       48 89 e5                mov    %rsp,%rbp
  400584:       48 83 ec 20             sub    $0x20,%rsp
  400588:       89 7d ec                mov    %edi,-0x14(%rbp)
  40058b:       48 89 75 e0             mov    %rsi,-0x20(%rbp)
/root/atomic_thread_fence.c:9
        int a;

        a = 1;
  40058f:       c7 45 fc 01 00 00 00    movl   $0x1,-0x4(%rbp)
/root/atomic_thread_fence.c:10
        printf("ATOMIC_RELAXED\n");
  400596:       bf 90 06 40 00          mov    $0x400690,%edi
  40059b:       e8 b0 fe ff ff          callq  400450 <puts@plt>
/root/atomic_thread_fence.c:12
        __atomic_thread_fence(__ATOMIC_RELAXED);
        a = 2;
  4005a0:       c7 45 fc 02 00 00 00    movl   $0x2,-0x4(%rbp)
/root/atomic_thread_fence.c:13
        printf("ATOMIC_CONSUME\n");
  4005a7:       bf 9f 06 40 00          mov    $0x40069f,%edi
  4005ac:       e8 9f fe ff ff          callq  400450 <puts@plt>
/root/atomic_thread_fence.c:15
        __atomic_thread_fence(__ATOMIC_CONSUME);
        a = 3;
  4005b1:       c7 45 fc 03 00 00 00    movl   $0x3,-0x4(%rbp)
/root/atomic_thread_fence.c:16
        printf("ATOMIC_RELEASE\n");
  4005b8:       bf ae 06 40 00          mov    $0x4006ae,%edi
  4005bd:       e8 8e fe ff ff          callq  400450 <puts@plt>
/root/atomic_thread_fence.c:18
        __atomic_thread_fence(__ATOMIC_RELEASE);
        a = 4;
  4005c2:       c7 45 fc 04 00 00 00    movl   $0x4,-0x4(%rbp)
/root/atomic_thread_fence.c:19
        printf("ATOMIC_ACQ_REL\n");
  4005c9:       bf bd 06 40 00          mov    $0x4006bd,%edi
  4005ce:       e8 7d fe ff ff          callq  400450 <puts@plt>
/root/atomic_thread_fence.c:21
        __atomic_thread_fence(__ATOMIC_ACQ_REL);
        a = 5;
  4005d3:       c7 45 fc 05 00 00 00    movl   $0x5,-0x4(%rbp)
/root/atomic_thread_fence.c:22
        printf("ATOMIC_SEQ_CST\n");
  4005da:       bf cc 06 40 00          mov    $0x4006cc,%edi
  4005df:       e8 6c fe ff ff          callq  400450 <puts@plt>
/root/atomic_thread_fence.c:23
        __atomic_thread_fence(__ATOMIC_SEQ_CST);
  4005e4:       0f ae f0                mfence
/root/atomic_thread_fence.c:24
        printf("a=%d\n", a);
  4005e7:       8b 45 fc                mov    -0x4(%rbp),%eax
  4005ea:       89 c6                   mov    %eax,%esi
  4005ec:       bf db 06 40 00          mov    $0x4006db,%edi
  4005f1:       b8 00 00 00 00          mov    $0x0,%eax
  4005f6:       e8 65 fe ff ff          callq  400460 <printf@plt>
/root/atomic_thread_fence.c:25
}
  4005fb:       c9                      leaveq
  4005fc:       c3                      retq
  4005fd:       0f 1f 00                nopl   (%rax)
-----


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
