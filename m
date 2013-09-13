From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Make queue size configurable
Date: Fri, 13 Sep 2013 16:31:27 +0200
Message-ID: <523321BF.9020403@acm.org>
References: <521363EA.8080906@acm.org> <52136609.3090406@acm.org>  <1378782080.3794.6.camel@feather.ornl.gov> <522F5A81.8040101@acm.org> <1378937796.6649.5.camel@haswell.thedillows.org> <5231E8CE.5060105@gmail.com> <5231EC1A.7030902@acm.org> <5232C76B.4010704@gmail.com> <5232CF86.20507@acm.org> <5232D9BC.7090808@acm.org> <5233043F.5020804@gmail.com> <52331444.8070007@acm.org> <52331854.9010607@gmail.com> <52331B47.9070202@acm.org> <52331E01.3060005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52331E01.3060005-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, David Dillow <dad-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/13/13 16:15, Jack Wang wrote:
> Hello Bart,
>
>> cat /sys/class/scsi_host/host36/req_lim
>> 64
>
> I just checked srp spec, which do define such behaviour, I wonder in
> SCST/SRPT, how the request limit is chosen, is it report from low level
> hardware driver?

Hello Jack,

The following code probably provides the information you are looking for:

/*
  * Avoid QUEUE_FULL conditions by limiting the number of buffers used
  * for the SRP protocol to the SCST SCSI command queue size.
  */
ch->rq_size = min(SRPT_RQ_SIZE, scst_get_max_lun_commands(NULL, 0));

In other words, req_lim can be increased by increasing both SRPT_RQ_SIZE 
and SCST_MAX_DEV_COMMANDS.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
