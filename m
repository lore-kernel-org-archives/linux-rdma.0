From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: libmlx4 and setting the doorbell qpn
Date: Sat, 8 Oct 2011 17:12:22 +0200
Message-ID: <CAO+b5-pXXBmVBomOFed7Js4LqyRqseoPEeVCsoeinA1VSTT==Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

While reviewing the compiler warnings triggered by the libmlx4 source
code, I came across this statement in src/qp.c:

        *(uint32_t *) ctrl->reserved |= qp->doorbell_qpn;

which triggers this warning:

    src/qp.c:399:3: warning: dereferencing type-punned pointer will
break strict-aliasing rules

because "reserved" is declared as follows:

struct mlx4_wqe_raddr_seg {
    uint64_t        raddr;
    uint32_t        rkey;
    uint32_t        reserved;
};

I see that a 32-bit integer is cast into a pointer. So on a 64-bit
platform that cast will cause a read past the end of the
mlx4_wqe_raddr_seg structure. Is there anyone who can explain me why
this makes sense ?

This code was added via commit
bb586a91fb00e7b674e14ea6f39d9aac8042a91a (April 2007).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
