From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: IB_CQ_VECTOR_LEAST_ATTACHED
Date: Thu, 04 Dec 2014 19:43:21 +0100
Message-ID: <5480AB49.1080209@acm.org>
References: <54809030.6090107@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54809030.6090107-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/04/14 17:47, Shirley Ma wrote:
> What's the history of this patch?
> 	http://lists.openfabrics.org/pipermail/general/2008-May/050813.html
>
> I am working on multiple QPs workload. And I created a similar approach
 > with IB_CQ_VECTOR_LEAST_ATTACHED, which can bring up about 17% small I/O
 > performance. I think this CQ_VECTOR loading balance should be maintained
 > in provider not the caller. I didn't see this patch was submitted to
 > mainline kernel, wonder any reason behind?

My interpretation is that an approach similar to 
IB_CQ_VECTOR_LEAST_ATTACHED is useful on single-socket systems but 
suboptimal on multi-socket systems. Hence the code for associating CQ 
sets with CPU sockets in the SRP initiator. These changes have been 
queued for kernel 3.19. See also branch drivers-for-3.19 in git repo 
git://git.infradead.org/users/hch/scsi-queue.git.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
