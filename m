From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/srp: Fix crash when unmapping data loop
Date: Tue, 11 Mar 2014 16:00:17 +0100
Message-ID: <531F2501.9090005@acm.org>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-2-git-send-email-sagig@mellanox.com> <530B6444.1000805@acm.org> <530F225E.5070500@dev.mellanox.co.il> <53183B71.4090609@acm.org> <53189526.2010704@mellanox.com> <53189DDE.7090003@dev.mellanox.co.il> <53197FC5.4090102@acm.org> <531F11B8.5030202@dev.mellanox.co.il> <531F14D0.7010608@acm.org> <531F18A7.1000907@dev.mellanox.co.il> <531F1DBD.9070505@acm.org> <531F2221.2090403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531F2221.2090403-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/11/14 15:48, Sagi Grimberg wrote:
> But I think this lock can be taken conditionally. I mean in the
> sunny-day scenario we don't expect
> srp_terminate_io to race with srp_post_send. That can happen only when
> rport state transitions
> to FAIL_FAST right? and also in some strange case when the rport is in
> state RUNNING but the
> sdev is offline and queuecommand is not even invoked. Do you think that
> acquiring the target->lock
> in case rport state is FAST_FAIL suffices?

That would be tricky to implement since the rport state can change after
having checked it and while srp_post_send() is in progress.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
