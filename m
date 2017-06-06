From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 10:35:12 +0300
Message-ID: <46b1a06d-5936-799c-7743-097c579971ef@grimberg.me>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 10/05/17 14:25, ahmad omary wrote:
> Introduction
> -------------------------------------------------------------------------------
> 
> Many types of user space application can get a real performance gain by using
> the internal memory of an IB device. This can be useful to decrease latency of
> a trading operation where data is already allocated in the device memory, to
> save the PCI round trip when doing atomic operations on semaphores remotely
> and also to save the PCI round trip when performing modification by the device
> on received traffic that should be transmitted directly after this modification.
> 
> The problem
> -------------------------------------------------------------------------------
> 
> Today there is no API in libibverbs that allow user space application to manage
> internal memory of IB devices.
> 
> We have considered using mmap(), but As the size of device memory may be limited
> ,the way to access it from host cpu may differ from vendor to vendor, due to
> the 4K (page) aligment limitation of mmap() and the need not to directly
> allow user to access the device memory, there is a need for a wrapper access
> methods API that allows allocating and managing chunks that are smaller than
> 4KB and not necessarily aligned to 4KB (page size).
> 
> Suggested Solution
> -------------------------------------------------------------------------------
> 
> In order for user space applications to use the internal device memory, we
> suggest to update libibverbs so it provides these applications access to
> allocate, free, register and memcopy operations from/to host memory.
> After the device memory is allocated for a process, it can be registered
> using ibv_reg_mr_ex. The registered memory can be used to process any operation
> like if it was registered on host memory mkey. It can be used for post_send,
> post_receive, RDMA WRITE/READ and atomic operations.
> 
> New suggested verbs:
> 
> ibv_alloc_dm: allocates device memory and returns an identifier structure that
> identify and define the allocated device memory
> 
> ibv_free_dm: free device memory.
> 
> ibv_memcpy_dm: Copy from device memory to host memory and from host memory
> to device memory.
> 
> ibv_reg_mr_ex: Extended to ibv_reg_mr that allow registering device memory.
> 
> 

This is useful to kernel consumers too, Adding Stephen and Logan to the
party.

Personally I agree with Christoph Lamater that we are far better off
sticking to standard mmap to expose it to user-space.

 From the thread I don't really understand the problem the API is trying
to solve, AFAICT it boils down to a plain bar, and as such it needs to
be treated as such.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
