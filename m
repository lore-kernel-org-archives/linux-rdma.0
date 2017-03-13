From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: Re: ConnectX-3 on non-coherent AARCH64 system
Date: Mon, 13 Mar 2017 10:43:04 -0600
Message-ID: <40698e27-8b17-df09-8165-40420f16a37e@wwwdotorg.org>
References: <b01684b6-ba4a-65cc-ea20-b578e1e2fa2e@nvidia.com>
 <20170310170626.GE22960@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170310170626.GE22960-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/10/2017 10:06 AM, Jason Gunthorpe wrote:
> On Thu, Mar 09, 2017 at 04:59:40PM -0700, Stephen Warren wrote:
>
>> However, when I run the same test on a (non-cache-coherent) AArch64 (ARMv8)
>> machine (Cortex-A57, NVIDIA Tegra), the application does not work. In
>> particular, ivc_poll_cq() returns -2 when the application waits for an
>> ibv_post_send/recv() to complete.
>
> User space verbs are not supported on non-cache-coherent architectures
> for kernel bypass adapters and probably never will be.

In my case, I primarily want another "DMA device" to access the data 
read/written by Infiniband. If CPU access to the data buffers doesn't 
work correctly, it might not be such a big deal. So, I'd be willing to 
take a solution that only fixed the MMU setup issues for the pages used 
for ConnectX HW control. I expect making those uncached would work, and 
since the number of these control pages (compared to the data plane) is 
small, the performance probably wouldn't be too bad. Would it be 
possible for the kernel ConnectX driver to modify the process page 
tables to flip all known control pages from cached to uncached when the 
completion queues are created?

> Ideally the kernel would not create the uverbs device for DMA drivers
> on such architectures.. Is there a kernel API to detect cache
> incoherence?

I'm not aware of any right now (although I don't deal with Linux MM 
much, so probably wouldn't be). I am aware of dma_alloc_coherent(), and 
I assume that must choose uncached/cached/... based on the HW's 
coherence, so perhaps that information could be found.

Once upon a time, we might have got away with assuming the answer based 
on architecture, but I suspect that ARM==non-coherent is false in many 
cases these days.

>> than e.g. the kernel filling in the CQ), and there don't appear to be any
>> cache invalidation operations anywhere in libmlx4 (I'm not even sure if
>> cache manipulation is possible from user-space on ARM). I also
>> couldn't find
>
> Precisely.

P.S. Sorry about the email disclaimer last time around; I hadn't noticed 
that my email client defaulted to sending the message through the 
corporate mail server.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
