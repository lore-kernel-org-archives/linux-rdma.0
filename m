From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Thu, 3 Jul 2014 19:46:55 +0300
Message-ID: <CAJZOPZ+RPe8B_KhKZ-8-S6g871-EKQSnExZgsZ2Z+bo-9L=P9w@mail.gmail.com>
References: <53B55E55.5040907@acm.org>
	<53B55F1F.6000704@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B55F1F.6000704-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 3, 2014 at 4:48 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
[...]
>
> Limit the number of poll cycles per completion notification to preserve fairness

[...]

Any reason not to make use of the block layer NAPI like API for that
(blk-iopoll http://lwn.net/Articles/346187/) ?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
