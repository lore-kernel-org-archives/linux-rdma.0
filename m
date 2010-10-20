From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
Date: Wed, 20 Oct 2010 10:37:03 +0200
Message-ID: <4CBEAA2F.6000009@kernel.org>
References: <4CBDB834.2050905@kernel.org> <1287508926.27343.299.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287508926.27343.299.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

On 10/19/2010 07:22 PM, Ralph Campbell wrote:
> On Tue, 2010-10-19 at 08:24 -0700, Tejun Heo wrote:
> 
>> * qib_cq_wq is a separate singlethread workqueue.  Does the queue
>>   require strict single thread execution ordering?  IOW, does each
>>   work have to be executed in the exact queued order and no two works
>>   should execute in parallel?  Or was the singlethreadedness chosen
>>   just to reduce the number of workers?
> 
> The work functions need to be called in-order and single threaded
> or memory will be freed multiple times and other "bad things".

I see, so they'll need to be converted to alloc_ordered_workqueue()
once -rc1 merge window opens up.  I'll follow up with the conversion.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
