From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Thu, 03 Jul 2014 10:05:03 -0700
Message-ID: <1404407103.32754.3.camel@haswell.thedillows.org>
References: <53B55E55.5040907@acm.org> <53B55F1F.6000704@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B55F1F.6000704-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[Apologies if you get this twice, mailer crashed during the first send]

On Thu, 2014-07-03 at 15:48 +0200, Bart Van Assche wrote:
> Reduce completion queue lock contention by polling for multiple
> work completions at once. Limit the number of poll cycles per
> completion notification to preserve fairness if multiple verbs
> applications use the same port or if multiple IB interrupts have
> been mapped to the same CPU core.

Do you have performance/CPU utilization numbers for this change?

When we looked at this back in the 2.6.38 time-frame, there were several
performance anomalies with this -- and an block-iopoll conversion -- and
IIRC, neither was a win. It's possible that the issues were specific to
the drivers and that newer hardware is better, but it'd be good to see
the numbers.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
