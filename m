From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 12/14] IB/srp: Make HCA completion vector configurable
Date: Fri, 28 Jun 2013 14:29:11 +0200
Message-ID: <51CD8197.3040907@acm.org>
References: <51B87501.4070005@acm.org> <51B87904.1070803@acm.org>  <1372368256.32164.41.camel@frustration.ornl.gov> <51CD46F0.60301@acm.org> <1372421041.28740.14.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372421041.28740.14.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillow-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/28/13 14:04, David Dillow wrote:
> On Fri, 2013-06-28 at 10:18 +0200, Bart Van Assche wrote:
>> On 06/27/13 23:24, David Dillow wrote:
>> To me this looks like a standard procedure that applies to any HCA that
>> supports multiple MSI-X vectors ?
>
> To you and I, sure, this is relatively standard. And now that google has
> it, newcomers will be able to find it. However, this changes the login
> string and so Documentation/ABI/stable/sysfs-driver-ib_srp needs to be
> updated, with at least minimal text.

OK, will do.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
