From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 08/13] IB/srp: Add srp_terminate_io()
Date: Wed, 03 Jul 2013 16:45:41 +0200
Message-ID: <51D43915.9000007@acm.org>
References: <51D41C03.4020607@acm.org> <51D41F52.4000409@acm.org> <1372860491.24238.0.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372860491.24238.0.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/03/13 16:08, David Dillow wrote:
> On Wed, 2013-07-03 at 14:55 +0200, Bart Van Assche wrote:
>> Finish all outstanding I/O requests after fast_io_fail_tmo expired,
>> which speeds up failover in a multipath setup. This patch is a
>> reworked version of a patch from Sebastian Riemer.
>>
>> Reported-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>> Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
>
> I don't believe I ack'd this; I don't want the callers doing the result
> shift, do it in srp_finish_req().

My apologies. You are correct, this patch was not yet acknowledged by you.

Regarding the shift itself: is it really that important whether the 
caller or callee performs that shift ? Having it in the caller has the 
advantage that the compiler can optimize the shift operation out because 
the number that is being shifted left is a constant. And if later on it 
would be necessary to set more fields of the SCSI result in a caller of 
srp_finish_req() then that will be possible without having to modify the 
srp_finish_req() function itself.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
