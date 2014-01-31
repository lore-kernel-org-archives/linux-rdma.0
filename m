From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA read does not update local memory
Date: Fri, 31 Jan 2014 09:26:44 -0500
Message-ID: <CADPSxAijWEk289LoqsV8G916wK6VSzKBD4Ky0-T=kUHbGCxD3Q@mail.gmail.com>
References: <03D88C61-964C-4FDE-B072-C96AC658701F@tu-dresden.de>
	<CADPSxAi72qNUhpJUBC5Z8FUkM=NySFcMJ+rdNkzdpstahkeK2w@mail.gmail.com>
	<77C22601-E2F0-43E1-98A1-BF2FB8AD5A90@tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <77C22601-E2F0-43E1-98A1-BF2FB8AD5A90-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Weisbach <hannes.weisbach-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Are you sure that the compiler knows that post_send() has side effects?


On Fri, Jan 31, 2014 at 8:28 AM, Hannes Weisbach
<hannes.weisbach-PZVgAJowwIsUtdQbppsyvg@public.gmane.org> wrote:
>
> Am 30.01.2014 um 22:36 schrieb Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>
>> Hannes,
>>
>> Have you tried marking the memory that is being read as "volatile"?
> Thanks for the suggestion, but I don't think that this solves the
> problem, because when I do:
>
> memset(...);
> rdma_post_read(...);
> /* wait */
> memcmp(...);
>
> The compiler may not optimize across rdma_post_read() (or rather
> ibv_post_send() and finally ioctl()), because these function may have
> side-effects (which they do).
> Anyway, I implemented a little helper memcmpv(volatile unsigned char *
> s1, volatile unsiged char * s2, size_t size) to compare the memory as
> volatile, but the memory still has the preset 0x55 instead of the
> contents of the remote memory.
> May that memset() be still in the cache, so that the memory accesses
> of the CPU hit the cache instead of main memory?  I can't imagine the
> cache isn't invalidated on reception of remote data.
>
> Best regards,
> Hannes
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
