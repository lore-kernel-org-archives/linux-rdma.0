From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 14/15] IB/srp: Make transport layer retry count configurable
Date: Mon, 01 Jul 2013 13:44:23 +0200
Message-ID: <51D16B97.904@acm.org>
References: <51CD856A.3010102@acm.org> <51CD8876.9020307@acm.org>  <1372628891.12468.52.camel@haswell.thedillows.org>  <51D13B52.5060803@acm.org> <1372677965.12468.57.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372677965.12468.57.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/01/13 13:26, David Dillow wrote:
> On Mon, 2013-07-01 at 10:18 +0200, Bart Van Assche wrote:
>> The InfiniBand specification mentions the following about differential
>> receiver inputs (C6-11.2.1): "A BER of 10^-12 shall be achieved when
>> connected to the worst case transmitter through any compliant channel".
>
> There are a _lot_ of networks out there with non-compliant channels,
> then. The spec says one thing, but the reality matters. Also, perhaps my
> math is wrong, but that seems to be one error every 18 seconds or so at
> FDR speeds?

If data is transferred at line rate on an FDR network, I agree that 
about one error is expected about every 18 seconds.

Sorry but it's not clear to me what makes you think that there are a lot 
of IB networks with non-compliant channels ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
