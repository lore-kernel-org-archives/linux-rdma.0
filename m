From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Annoying gcc / rdma / networking warnings
Date: Sat, 11 May 2019 12:52:06 -0400
Message-ID: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>, David Miller <davem@davemloft.net>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Jason and Davem,
 with gcc-9, I'm now seeing a number of annoying warnings from the
rdma layer. I think it depends on the exact gcc version, because I'm
seeing them on my laptop but didn't see them on my desktop, probably
due to updating at different times.

The warning is because gcc now looks at pointer types for some
allocation sizes, and will do things like this:

In function =E2=80=98memset=E2=80=99,
    inlined from =E2=80=98rdma_gid2ip=E2=80=99 at ./include/rdma/ib_addr.h:=
168:3,
    inlined from =E2=80=98roce_resolve_route_from_path=E2=80=99 at
drivers/infiniband/core/addr.c:735:2:
./include/linux/string.h:344:9: warning: =E2=80=98__builtin_memset=E2=80=99=
 offset
[17, 28] from the object at =E2=80=98dgid=E2=80=99 is out of the bounds of =
referenced
subobject =E2=80=98_sockaddr=E2=80=99 with type =E2=80=98struct sockaddr=E2=
=80=99 at offset 0
[-Warray-bounds]
  344 |  return __builtin_memset(p, c, size);

because the "memset()" is done onto a "sockaddr_in6" (where it's not
out of bounds), but the rdma_gid2ip() function was passed a "sockaddr"
type (where it *is* out of bounds.

All the cases I found actually have good *allocations* for the
underlying storage, using a union of the different sockaddr types, and
includes a "sockaddr_in6". So the warning actually looks bogus from an
actual allocation standpoint, but at the same time, I think the
warning does show a real issue in the networking code.

In particular, a "struct sockaddr" is supposed to be a valid superset
of the different sockaddr types, and the rdma use is in that sense the
rdma use of "struct sockaddr *" is entirely sane.

BUT.

The Linux kernel sockaddr is actually just 16 bytes. While a
sockaddr_int is about twice that.

So if you look at the types like gcc does, then the rdma layer really
is passing a pointer to a 16-byte sockaddr, and then filling it with
(much bigger) sockaddr_ip6 data.

Arguably gcc is being stupid, and it should look at the actual
allocation, but that's not what it does. And I do think what gcc does
is at least understandable.

So David, arguably the kernel "struct sockaddr" is simply wrong, if it
can't contain a "struct sockaddr_in6". No? Is extending it a huge
problem for other users that don't need it (mainly stack, I assume..)?

Also equally arguably, the rdma code could just use a "struct
sockaddr_in6 for this use and avoid the gcc issue, couldn't it? It has
the type right there, and rdma_gid2ip() could just take that type
instead, since that's what it actually then uses anyway.

Comments?

               Linus
