From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: RXE, should I use rdma-core or the older stand-alone code
Date: Thu, 2 Mar 2017 16:53:54 -0700
Message-ID: <CAANLjFru=X5RDEojsjMgzjjhe130raz3QPaPLZmS_W2Jru9Tkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm trying to get rxe working on CentOS 7.2 and running into problems
getting rdma-core working correctly. Since that is the only piece I
need, should I just use the old code repo? Will that work with 4.9.13?

I cloned rdma-core and built it using the build.sh scipt. I could use
the rxe_cfg from providers/rxe/, but I was getting '(?)' for the MTU
and I couldn't get iSER working, so I created the
/etc/libibverbs.d/rxe.driver file with it loading the driver from my
home directory. I get this error message.

libibverbs: Warning: couldn't load driver
'/home/rleblanc/rdma-core/build/lib/librxe': /lib64/libibverbs.so.1:
version `IBVERBS_PRIVATE_13' not found (required by
/home/rleblanc/rdma-core/build/lib/librxe-rdmav2.so)
IB device 'rxe0' wasn't found

So, I redirected the link /usr/lib64/libibverbs.so.1 to the library in
build/lib/. Then I get this error.

ibv_devinfo: ../libibverbs/init.c:376: try_driver: Assertion
`dev->_ops._dummy1 == ((void *)0)' failed.

I don't know how to get past this issue.

I also went into the build directory and ran cmake3 . -G"Unix
Makefiles" and then installed it and had the exact problem.

I have libibverbs-1.1.8-8.el7.x86_64 currently installed. Do I have to
completely remove all RDMA packages and install everything manually?
Can I build an RPM package for rdma-core? It looks like there is a
Fedora package, would I be better off rebuilding that instead?

Thank you,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
