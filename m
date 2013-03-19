From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC ib_srp-backport] ib_srp: bind fast IO failing to QP timeout
Date: Tue, 19 Mar 2013 12:45:18 +0100
Message-ID: <51484FCE.2070704@acm.org>
References: <51483B19.1070201@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51483B19.1070201-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/19/13 11:16, Sebastian Riemer wrote:
> Hi Bart,
>
> now I've got my priority on SRP again.
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

Hello Sebastian,

Patches 1 and 2 make sense to me. Patch 3 makes it impossible to disable 
fast_io_fail_tmo and also disables the fast_io_fail_tmo timer - was that 
intended ? Regarding patches 4 and 5: I'm not sure whether reducing the 
QP retry count will work well in large fabrics. The iSCSI initiator 
follows another approach to realize quick failover, namely by 
periodically checking the transport layer and by triggering the 
fast_io_fail timer if that check fails. Unfortunately the SRP spec does 
not define an operation suited as a transport layer test. But maybe a 
zero-length RDMA write can be used to verify the transport layer ? I 
think the IB specification allows such operations. A quote from page 439:

C9-88: For an HCA responder using Reliable Connection service, for
each zero-length RDMA READ or WRITE request, the R_Key shall not be
validated, even if the request includes Immediate data.

Note: I'm still working on transforming the patches present in the 
ib_srp-backport repository such that these become acceptable for 
upstream inclusion.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
