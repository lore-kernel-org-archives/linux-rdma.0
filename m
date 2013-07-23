From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-3.11 7/7] IB/iser: Introduce fast memory registration
 model (FRWR)
Date: Tue, 23 Jul 2013 17:21:26 +0300
Message-ID: <CAJZOPZ+1TLQ-vwsZG8dgxhP332CQeDNOWfzGRdTbwRxLRhL95w@mail.gmail.com>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com>
	<1374153931-7313-8-git-send-email-ogerlitz@mellanox.com>
	<51ED1B8E.7070703@acm.org>
	<51ED2F97.2080400@mellanox.com>
	<51EE6FFE.8040802@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51EE6FFE.8040802-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 23, 2013 at 2:58 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>
> [...]
> Hello Sagi and Or,
>
> Thanks for the clarifications. I have one more question though. My interpretation of section "10.6 Memory Management" in the IB specification is that memory registration maps a memory region that either has contiguous virtual addresses or contiguous physical addresses. However, there is no such requirement for an sg-list. As an example, for direct I/O to a block device with a sector size of 512 bytes it is only required that I/O occurs in multiples of 512 bytes and from memory aligned on 512-byte boundaries. So the use of direct I/O can result in an sg-list where the second and subsequent sg-list elements have a non-zero offset. Do you agree with this ?



YES, this can happen.



>
> Are such sg-lists mapped correctly by the FRWR code ?



Bart, iSER's FMR and FRWR code works under the assumption that an SG
list is "4K aligned". For SGs which don't obey that assumption we're
using bounce buffer.

Note that the SG "page" size used by FMRs/FRWRs doesn't have to be 1:1
with the OS page size, so in that respect && down the road, we will
get rid of the bounce buffer thing with having another FMR/FRWR pool
whose "page" size is 512B and will be used for SG which are not "4K
aligned".

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
