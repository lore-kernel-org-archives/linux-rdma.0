From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 14/15] IB/srp: Make transport layer retry count configurable
Date: Mon, 01 Jul 2013 10:18:26 +0200
Message-ID: <51D13B52.5060803@acm.org>
References: <51CD856A.3010102@acm.org> <51CD8876.9020307@acm.org> <1372628891.12468.52.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372628891.12468.52.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/30/13 23:48, David Dillow wrote:
> On Fri, 2013-06-28 at 14:58 +0200, Bart Van Assche wrote:
>> From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Allow the InfiniBand RC retry count to be configured by the user
>> as an option in the target login string. The transport layer
>> timeout in nanoseconds is computed as follows from the retry count:
>>
>> rc_timeout = rc_retry_count * 4 * 4096 * (1 << qp->timeout)
>>
>> The default value for tl_retry_count is changed from 7 into 2.
>> Hence with a qp->timedout value of 19 this patch reduces the
>> default transport layer timeout from about 60s to about 17s. The
>> purpose of this patch is to reduce the time needed for SCSI error
>> handling significantly and at the same time to avoid activating
>> the SCSI error handler on an IB path with a regular BER or due to
>> brief IB network congestion.
>
> I keep vacillating between preserving the default of 7 and opting for
> easier/optimized configuration for the common case. It my internal
> argument over this today, I wondered about changing the QP timeout
> instead -- doesn't that achieve your goals of allowing for errors and
> network congestion while optimizing for a reasonable fabric? Going from
> 19 to 17 drops the timeout by about the same amount, while allowing for
> more errors.
>
> I agree that one or both of the items should be configurable, but I'm
> still worried about changing the defaults, given the feed back from
> those that want to use IB over the WAN.

The InfiniBand specification mentions the following about differential 
receiver inputs (C6-11.2.1): "A BER of 10^-12 shall be achieved when
connected to the worst case transmitter through any compliant channel". 
The maximum packet size for an InfiniBand packet is about 4 KB (see also 
section 7.7.8 in the spec). This means that with an 8b/10b encoding the 
chance to lose a packet over a single link due to bit errors is about 
4*10^-8. So the chance to lose a packet over a network consisting of n 
links with retry count r is about (n*4*10^-8)^r. With r=2 that results 
already in a really low value, even with multiple links. Since lowering 
the QP timeout might make congestion worse my preference is to lower the 
retry count.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
