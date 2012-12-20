From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 1/3] IB/srp: Track connection state properly
Date: Thu, 20 Dec 2012 09:13:56 +0100
Message-ID: <50D2C8C4.3030308@acm.org>
References: <50D1CD49.5080607@acm.org> <50D1CD7D.6030905@acm.org> <1355940274.23687.2.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355940274.23687.2.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/19/12 19:04, David Dillow wrote:
> On Wed, 2012-12-19 at 15:21 +0100, Bart Van Assche wrote:
>> The connection state must be initialized before srp_connect_target()
>> is invoked. Drop the assignment in srp_add_target() since it occurs
>> after srp_connect_target() and since scsi_host_alloc()
>> zero-initializes the Scsi_Host structure anyway.
>
> The commit message is still wrong. The issue is that
> srp_connect_target() has marked us as active, and this patch removes an
> assignment that reverses that.
>
> This shouldn't go upstream without the fixed commit message.

Hi Dave,

How about replacing the commit message by the following text:

"Remove an assignment that incorrectly overwrites the connection state 
update by srp_connect_target()."

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
