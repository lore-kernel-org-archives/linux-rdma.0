From: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Tue, 12 Nov 2013 11:16:25 +0100
Message-ID: <5281FFF9.5070705@gmail.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  Hi Anuj,

On 10/11/2013 11:46, Anuj Kalia wrote:
> How can this happen in the presence of memory barriers? With barriers,
> A[i].counter should be updated later and therefore should always be
> smaller than A[i].value.

memory barriers such as mfence synchronize memory operations from the 
point of view of CPUs only. Practically this means that the stores you 
wrote might go out to memory in a different order than what the 
processor sees and external devices such as a PCIe HCAs might thus see a 
different ordering even in the presence of memory barriers.

To ensure that an external devices sees your store in the order you 
meant you will need some form of external barrier though I do not know 
if it is possible at all in userspace and besides it will be a fragile 
solution.

Instead I would suggest you to use verbs atomic operations such as 
IBV_WR_ATOMIC_CMP_AND_SWP and IBV_WR_ATOMIC_FETCH_AND_ADD to implement 
what you have in mind.

  Gabriele
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
