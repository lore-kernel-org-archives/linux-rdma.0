From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA read does not update local memory
Date: Thu, 30 Jan 2014 16:36:55 -0500
Message-ID: <CADPSxAi72qNUhpJUBC5Z8FUkM=NySFcMJ+rdNkzdpstahkeK2w@mail.gmail.com>
References: <03D88C61-964C-4FDE-B072-C96AC658701F@tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <03D88C61-964C-4FDE-B072-C96AC658701F-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Weisbach <hannes.weisbach-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hannes,

Have you tried marking the memory that is being read as "volatile"?

--Anuj

On Thu, Jan 30, 2014 at 1:45 PM, Hannes Weisbach
<hannes.weisbach-PZVgAJowwIsUtdQbppsyvg@public.gmane.org> wrote:
> Hello all,
>
> I'm developing an (userspace) RDMA-application under Linux and came
> across a problem, I'm not able to solve.
>
> On machine A I had a chunk of memory registered with rdma_reg_read(),
> so others can read from that memory later.
>  Machine B has memory which is also registered with rdma_reg_read().
> Machine B tells machine A about that memory and the rkey.
>  Machine A rdma_post_read()s then from that memory on machine B in
> it's own memory.  The problem now is, that - although no error is
> reported - the contents of machine A's memory does not change.  I
> memset() it to 0x55 before the rdma_post_read() for debugging
> purposes and instead of having the contents I expect (an ASCII
> string), the memory is still 0x55 after the work completion is
> signaled.
>
> Thus, I've allocated different chunks of memory using malloc() and
> posix_memalign() with different sizes and registered them with
> rdma_reg_read(), to see if that makes a difference.  The
> rdma_post_read() works on all tested memory, except one chunk.
>
> I don't know what is different about that memory, where my mistake
> might be or how to debug this.
>
> Please note, that I check all return values for errors (there are
> none) and also the work completion reports IBV_SUCCESS.
> I hope you can give me some hints on how to proceed.
> I apologize if my problem description was too brief; please ask for
> details if I left important information out.
>
> Best regards,
> Hannes Weisbach--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
