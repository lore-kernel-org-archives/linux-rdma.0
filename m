From: Hannes Weisbach <hannes.weisbach-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Subject: Re: RDMA read does not update local memory
Date: Fri, 31 Jan 2014 14:28:38 +0100
Message-ID: <77C22601-E2F0-43E1-98A1-BF2FB8AD5A90@tu-dresden.de>
References: <03D88C61-964C-4FDE-B072-C96AC658701F@tu-dresden.de> <CADPSxAi72qNUhpJUBC5Z8FUkM=NySFcMJ+rdNkzdpstahkeK2w@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAi72qNUhpJUBC5Z8FUkM=NySFcMJ+rdNkzdpstahkeK2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Am 30.01.2014 um 22:36 schrieb Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:

> Hannes,
>=20
> Have you tried marking the memory that is being read as "volatile=93?
Thanks for the suggestion, but I don=92t think that this solves the
problem, because when I do:

memset(=85);
rdma_post_read(=85);
/* wait */
memcmp(=85);

The compiler may not optimize across rdma_post_read() (or rather
ibv_post_send() and finally ioctl()), because these function may have
side-effects (which they do).
Anyway, I implemented a little helper memcmpv(volatile unsigned char *
s1, volatile unsiged char * s2, size_t size) to compare the memory as
volatile, but the memory still has the preset 0x55 instead of the
contents of the remote memory.
May that memset() be still in the cache, so that the memory accesses
of the CPU hit the cache instead of main memory?  I can=92t imagine the
cache isn=92t invalidated on reception of remote data.

Best regards,
Hannes--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
