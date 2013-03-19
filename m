From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ib_srp-backport] ib_srp: bind fast IO failing to QP timeout
Date: Tue, 19 Mar 2013 13:22:07 +0200
Message-ID: <51484A5F.6040601@mellanox.com>
References: <51483B19.1070201@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51483B19.1070201-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/03/2013 12:16, Sebastian Riemer wrote:
> Hi Bart,
>
> now I've got my priority on SRP again.

Hi Sebastian,

Are these patches targeted to upstream or backports to some OS/kernel? 
if the former, can you please
send them inline so we can have proper review?

Or.

>
> I've also noticed that your ib_srp-backport doesn't fail the IO fast
> enough. The fast_io_fail_tmo only comes into play after the QP is
> already in timeout and the "terminate_rport_io" function is missing.
>
> My idea is to use the QP retry count directly for fast IO failing. It is
> at 7 by default and the QP timeout is at approx. 2s. The overall QP
> timeout is at approx. 35s already (1+7 tries * 2s * 2, I guess). Using
> only 3 retries I'm at approx 18s.
>
> My patches introduce that parameter as module parameter as it is quite
> difficult to set the QP from RTS to RTR again. Only there the QP timeout
> parameters can be set.
>
> My patch series isn't complete yet as paths aren't reconnected - they
> are only failed fast bound to the overall QP timeout. But it should give
> you an idea what I'm trying to do here.
>
> What are your thought regarding this?
>
> Attached patches:
> ib_srp: register srp_fail_rport_io as terminate_rport_io
> ib_srp: be quiet when failing SCSI commands
> scsi_transport_srp: disable the fast_io_fail_tmo parameter
> ib_srp: show the QP timeout and retry count in srp_host sysfs files
> ib_srp: introduce qp_retry_cnt module parameter
>
> Cheers,
> Sebastian
>
>
> Btw.: Before, I've hacked MD RAID-1 for high-performance replication as
> DRBD is crap for our purposes. But that's worthless without a reliably
> working transport.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
