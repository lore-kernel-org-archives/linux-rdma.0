From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fail I/O requests if the transport is offline
Date: Sun, 17 Feb 2013 23:06:25 -0500
Message-ID: <1361160385.7415.2.camel@obelisk.thedillows.org>
References: <510BDCAA.204@acm.org>
	 <CAJZOPZLKQV0QvrW5sK8hQJf7AZc+1nUzp+5YCkZ3iVU4oTWbLg@mail.gmail.com>
	 <5111327F.6050402@acm.org>
	 <CAJZOPZ+-Zg=jnqg4ZmFL5Yo4_2DoWGcgy=3u6g3Rf9y80pXnpg@mail.gmail.com>
	 <5112049B.8030406@acm.org> <5112CE60.2030607@mellanox.com>
	 <51136E74.9090209@acm.org> <5113F056.4020501@mellanox.com>
	 <511E024E.70002@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511E024E.70002-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-02-15 at 10:39 +0100, Bart Van Assche wrote:
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 8a7eb9f..b34752d 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -734,6 +734,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
>  
>  	scsi_target_unblock(&shost->shost_gendev, ret == 0 ? SDEV_RUNNING :
>  			    SDEV_TRANSPORT_OFFLINE);
> +	target->transport_offline = ret != 0;

Minor nit, that line is hard to read; I keep thinking it needs parens
around the conditional...

Perhaps
	target->transport_offline = !!ret;
or
	target->transport_offline = ret;

gcc should do the right conversion since we're assigning to a bool.


Or, Vu, does this solve the issue you've seen? I may have time to test
later this week, but not before.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
