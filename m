From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Fri, 04 Jul 2014 12:48:42 +0200
Message-ID: <53B6868A.3070705@acm.org>
References: <53B55E55.5040907@acm.org> <53B55F1F.6000704@acm.org> <1404407103.32754.3.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404407103.32754.3.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/03/14 19:05, David Dillow wrote:
> When we looked at this back in the 2.6.38 time-frame, there were several
> performance anomalies with this -- and an block-iopoll conversion -- and
> IIRC, neither was a win. It's possible that the issues were specific to
> the drivers and that newer hardware is better, but it'd be good to see
> the numbers.

Hello Dave,

Do you still have that measurement data available and/or the scripts
that were used to collect that data ? I'd like to have a look at which
test you ran such that I can repeat that test with Linus' master tree. A
lot has been changed since kernel 2.6.38 was released, e.g. several more
SCSI core and SRP initiator driver optimizations have been accepted
upstream since then. I have found an e-mail from you from 2010 with
measurement data attached in an .ods document but it's probably not that
e-mail that you are referring to
(http://www.spinics.net/lists/linux-scsi/msg49216.html).

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
