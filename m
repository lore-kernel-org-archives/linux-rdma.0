From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 10:49:33 -0600
Message-ID: <6a12c83f-ba3f-663f-6f41-b434d016f420@deltatee.com>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <46b1a06d-5936-799c-7743-097c579971ef@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <46b1a06d-5936-799c-7743-097c579971ef-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

On 06/06/17 01:35 AM, Sagi Grimberg wrote:
> This is useful to kernel consumers too, Adding Stephen and Logan to the
> party.

Thanks for copying us.

> Personally I agree with Christoph Lamater that we are far better off
> sticking to standard mmap to expose it to user-space.
> From the thread I don't really understand the problem the API is trying
> to solve, AFAICT it boils down to a plain bar, and as such it needs to
> be treated as such.

We always get push back on IO safety (and for good reason). If the PCI
bar is exposed to userspace through mmap, users should be reading and
writing it through IO operations and if the buffers get used in any
kernel calls, the kernel also has to know that it is now dealing with IO
memory. The kernel is really not ready for this. A kernel-only API would
be able to do this safely and may make sense here.

However, without being able to do P2P DMAs with this memory (which is
what we have been working on) I don't really see the point. My intuition
is that copying from system to IO memory, or having the CPU populate
data structures in IO memory, would overall be slower than just doing it
in system memory and letting the DMA transfer be slightly slower.

Also, I have been told that, at least the two major RDMA NIC vendors
don't currently have working memory available in hardware to expose for
such uses. If there is hardware, I sure would like to get my hands on some.

In any case, this all seems slightly premature.

Logan




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
