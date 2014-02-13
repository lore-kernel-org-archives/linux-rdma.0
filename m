From: Hannes Weisbach <hannes.weisbach-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Subject: Re: RDMA read does not update local memory
Date: Thu, 13 Feb 2014 16:50:10 +0100
Message-ID: <AF061C28-ECF5-4761-A1AD-236DB817815F@tu-dresden.de>
References: <03D88C61-964C-4FDE-B072-C96AC658701F@tu-dresden.de> <CADPSxAi72qNUhpJUBC5Z8FUkM=NySFcMJ+rdNkzdpstahkeK2w@mail.gmail.com> <77C22601-E2F0-43E1-98A1-BF2FB8AD5A90@tu-dresden.de> <CADPSxAijWEk289LoqsV8G916wK6VSzKBD4Ky0-T=kUHbGCxD3Q@mail.gmail.com> <1EA7EFE4-793E-4188-8F33-16C89EB78C09@tu-dresden.de>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1EA7EFE4-793E-4188-8F33-16C89EB78C09-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

I found out that some code does madvise(MADV_DONTNEED) on the
allocated memory.  I think that this unmaps the memory from the user
space process.  If the process touches the memory again, a COW mapping
or even a new, zeroed out page is mapped in the process.  Either way,
the relation between the physical page, where the data from the RDMA
read ends up and the virtual page is broken.

I realize that calling madvise(MADV_DONTNEED) doesn=92t have any meanin=
g
for RDMA-registered memory.  I feel however that my observed behavior
is a bug and one of the following should happen:
=2E madvise() on pinned memory/I/O memory should fail, i.e. return EINV=
AL,
 EIO or ENOMEM (I didn=92t test what happens when you call=20
madvise(MADV_DONTNEED) on I/O mem.)
=2E RDMA actions on madvise()=92d memory should fail.

Best regards,
Hannes Weisbach--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
