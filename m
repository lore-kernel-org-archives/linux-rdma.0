From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB_CQ_VECTOR_LEAST_ATTACHED
Date: Thu, 04 Dec 2014 11:41:02 -0800
Message-ID: <5480B8CE.3080704@oracle.com>
References: <54809030.6090107@oracle.com> <5480AB49.1080209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5480AB49.1080209-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/04/2014 10:43 AM, Bart Van Assche wrote:
> On 12/04/14 17:47, Shirley Ma wrote:
>> What's the history of this patch?
>>     http://lists.openfabrics.org/pipermail/general/2008-May/050813.html
>>
>> I am working on multiple QPs workload. And I created a similar approach
>> with IB_CQ_VECTOR_LEAST_ATTACHED, which can bring up about 17% small I/O
>> performance. I think this CQ_VECTOR loading balance should be maintained
>> in provider not the caller. I didn't see this patch was submitted to
>> mainline kernel, wonder any reason behind?
> 
> My interpretation is that an approach similar to IB_CQ_VECTOR_LEAST_ATTACHED is useful on single-socket systems but suboptimal on multi-socket systems. Hence the code for associating CQ sets with CPU sockets in the SRP initiator. These changes have been queued for kernel 3.19. See also branch drivers-for-3.19 in git repo git://git.infradead.org/users/hch/scsi-queue.git.

What I did is that I manually controlled IRQ and working thread on the same socket. The CQ is created when mounting the file system in NFS/RDMA, but the workload thread might start from different socket, so per-cpu based implementation might not apply. I will look at SRP implementation.

Thanks,
Shirley
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
