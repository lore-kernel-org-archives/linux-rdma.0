From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFC ib_srp-backport] ib_srp: bind fast IO failing to QP timeout
Date: Tue, 19 Mar 2013 13:21:31 +0100
Message-ID: <5148584B.6080505@profitbricks.com>
References: <51483B19.1070201@profitbricks.com> <51484FCE.2070704@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51484FCE.2070704-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19.03.2013 12:45, Bart Van Assche wrote:
> On 03/19/13 11:16, Sebastian Riemer wrote:
>>
>> What are your thought regarding this?
>>
>> Attached patches:
>> ib_srp: register srp_fail_rport_io as terminate_rport_io
>> ib_srp: be quiet when failing SCSI commands
>> scsi_transport_srp: disable the fast_io_fail_tmo parameter
>> ib_srp: show the QP timeout and retry count in srp_host sysfs files
>> ib_srp: introduce qp_retry_cnt module parameter
> 
> Hello Sebastian,
> 
> Patches 1 and 2 make sense to me. Patch 3 makes it impossible to disable
> fast_io_fail_tmo and also disables the fast_io_fail_tmo timer - was that
> intended ?

I had a patch which has completely thrown out that fast_io_fail_tmo
parameter for ib_srp v1.2 as in my tests with dm-multipath it didn't
make any sense but having even longer to wait until IO can be failed. If
there is a connection issue, then all SCSI disks from that target are
affected and not only a single SCSI device. Today I've seen that you are
at v1.3 already and that patch didn't apply anymore. So I thought
disabling only the functionality shows what I'm trying to do here.

Can you please explain me what your intention was with that
fast_io_fail_tmo?
What I want to have is a calculateable timeout for IO failing. If the QP
retries are at 7 I can't get any lower than 35 seconds.

> Regarding patches 4 and 5: I'm not sure whether reducing the
> QP retry count will work well in large fabrics.

For me it is already a mystery why I measure 35 seconds at 2s QP timeout
and 7 retries. If the maximum is at 2s * 7 retries * 4, then I'm at 60
seconds. That's plain too long. The fast_io_fail_tmo comes on top of
that. How else should I reduce the overall timeout until I see in iostat
that the other path is taken?

> The iSCSI initiator
> follows another approach to realize quick failover, namely by
> periodically checking the transport layer and by triggering the
> fast_io_fail timer if that check fails. Unfortunately the SRP spec does
> not define an operation suited as a transport layer test. But maybe a
> zero-length RDMA write can be used to verify the transport layer ?

Hmmm, how do you want to implement that? This write would run into
(overall) QP timeout as well, I guess. The dm-multipath checks paths
with directio reads by polling every 5 seconds by default. IMHO this
does exactly that.

> I think the IB specification allows such operations. A quote from page 439:
> 
> C9-88: For an HCA responder using Reliable Connection service, for
> each zero-length RDMA READ or WRITE request, the R_Key shall not be
> validated, even if the request includes Immediate data.

And this isn't bound on the (overall) QP timeout? Can you send me a
proof of concept for this?

> Note: I'm still working on transforming the patches present in the
> ib_srp-backport repository such that these become acceptable for
> upstream inclusion.

I know that and I appreciate that. But I'm running out of time. Perhaps,
we can combine some efforts to implement something working first.
Doesn't have to be clean and shiny. For me also hacky is okay as long as
it works in the data center.

Yes, I have to admit that the patches 4 and 5 are hacky. Perhaps, I can
report you soon how it behaves reducing the retry count in a large
setup. ;-)

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
