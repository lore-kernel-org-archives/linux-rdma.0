From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 13/15] IB/srp: Make HCA completion vector configurable
Date: Sun, 30 Jun 2013 17:26:29 -0400
Message-ID: <1372627589.12468.44.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD8846.4070400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD8846.4070400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-06-28 at 14:57 +0200, Bart Van Assche wrote:
> Several InfiniBand HCA's allow to configure the completion vector
> per queue pair. This allows to spread the workload created by IB
> completion interrupts over multiple MSI-X vectors and hence over
> multiple CPU cores. In other words, configuring the completion
> vector properly not only allows to reduce latency on an initiator
> connected to multiple SRP targets but also allows to improve
> throughput.

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
