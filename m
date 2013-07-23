From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-3.11 7/7] IB/iser: Introduce fast memory registration
 model (FRWR)
Date: Tue, 23 Jul 2013 13:58:54 +0200
Message-ID: <51EE6FFE.8040802@acm.org>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com> <1374153931-7313-8-git-send-email-ogerlitz@mellanox.com> <51ED1B8E.7070703@acm.org> <51ED2F97.2080400@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51ED2F97.2080400-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/22/13 15:11, Sagi Grimberg wrote:
> So just to clarify the flow:
> . at connection establishment allocate pool of fastreg descriptors
> . upon each IOP take a fastreg descriptor from the pool
>      . if it is not invalidated - invalidate it.
>      . register using FRWR.
> . when cleanup_task is called - just return the fastreg descriptor to
> the pool.
> . at connection teardown free all resources.
> Still to come:
> . upon each IOP response, check if the target used remote invalidate -
> if so mark relevant fastreg as valid.

Hello Sagi and Or,

Thanks for the clarifications. I have one more question though. My 
interpretation of section "10.6 Memory Management" in the IB 
specification is that memory registration maps a memory region that 
either has contiguous virtual addresses or contiguous physical 
addresses. However, there is no such requirement for an sg-list. As an 
example, for direct I/O to a block device with a sector size of 512 
bytes it is only required that I/O occurs in multiples of 512 bytes and 
from memory aligned on 512-byte boundaries. So the use of direct I/O can 
result in an sg-list where the second and subsequent sg-list elements 
have a non-zero offset. Do you agree with this ? Are such sg-lists 
mapped correctly by the FRWR code ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
