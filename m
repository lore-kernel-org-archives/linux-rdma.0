From: David Binderman <linuxdev.baldrick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: linux-4.7-rc1/drivers/infiniband/hw/qib/qib_iba7322.c:6114]: (style)
 Redundant condition
Date: Mon, 30 May 2016 08:45:23 +0100
Message-ID: <CAMzoamY2xmK+Ffo8eDnXRGP6fwvcpetG+v090mD3t6-S_BsJGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello there,

linux-4.7-rc1/drivers/infiniband/hw/qib/qib_iba7322.c:6114]: (style)
Redundant condition: If '!EXPR', the comparison 'EXPR != ','' is
always true.

Source code is

       if (nxt == str || !*nxt || *nxt != ',') {

Also in the same file

[drivers/infiniband/hw/qib/qib_iba7322.c:6981]: (style) Boolean result
is used in bitwise operation. Clarify expression with parentheses.

Source code is

        sane = (hwhead >= swhead) & (hwhead <= swtail);

Maybe

        sane = (hwhead >= swhead) && (hwhead <= swtail);

And some more

drivers/infiniband/hw/qib/qib_iba7322.c:2350]: (style) Variable 'val'
is assigned a value that is never used.
[drivers/infiniband/hw/qib/qib_iba7322.c:7868]: (style) Variable 'rbc'
is assigned a value that is never used.

Regards

David Binderman
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
