From: Hannes Weisbach <hannes.weisbach-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Subject: Re: RDMA read does not update local memory
Date: Fri, 31 Jan 2014 17:05:37 +0100
Message-ID: <1EA7EFE4-793E-4188-8F33-16C89EB78C09@tu-dresden.de>
References: <03D88C61-964C-4FDE-B072-C96AC658701F@tu-dresden.de> <CADPSxAi72qNUhpJUBC5Z8FUkM=NySFcMJ+rdNkzdpstahkeK2w@mail.gmail.com> <77C22601-E2F0-43E1-98A1-BF2FB8AD5A90@tu-dresden.de> <CADPSxAijWEk289LoqsV8G916wK6VSzKBD4Ky0-T=kUHbGCxD3Q@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAijWEk289LoqsV8G916wK6VSzKBD4Ky0-T=kUHbGCxD3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Am 31.01.2014 um 15:26 schrieb Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:

> Are you sure that the compiler knows that post_send() has side effect=
s?
No, thats why I tested with the mentioned memcmpv.  I examined the
emitted code with objdump and the compiler issued the mov instructions
to read the bytes from memory - still didn=92t work.
I=92ll leave the memcpyv in for the moment just to be sure.

Best regards,
Hannes--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
