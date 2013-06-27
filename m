From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 12/14] IB/srp: Make HCA completion vector configurable
Date: Thu, 27 Jun 2013 17:24:16 -0400
Message-ID: <1372368256.32164.41.camel@frustration.ornl.gov>
References: <51B87501.4070005@acm.org> <51B87904.1070803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B87904.1070803-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2013-06-12 at 15:35 +0200, Bart Van Assche wrote:
> Several InfiniBand HCA's allow to configure the completion vector
> per queue pair. This allows to spread the workload created by IB
> completion interrupts over multiple MSI-X vectors and hence over
> multiple CPU cores. In other words, configuring the completion
> vector properly not only allows to reduce latency on an initiator
> connected to multiple SRP targets but also allows to improve
> throughput.

Shouldn't there be some documentation about how to set this? What
happens when you try to set it on an HCA that doesn't support this how
does the user know what's wrong?

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
