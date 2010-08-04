From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 3/4 v3] IB/srp: adjust can_queue
Date: Wed, 4 Aug 2010 18:44:25 +0200
Message-ID: <AANLkTimLXotTF5hSG8WRE-7evXz19zLbE1+6kG9k4gph@mail.gmail.com>
References: <201008031608.42244.bvanassche@acm.org>
	<1280849064.20446.46.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280849064.20446.46.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 3, 2010 at 5:24 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrot=
e:
> On Tue, 2010-08-03 at 16:08 +0200, Bart Van Assche wrote:
>> The SRP (draft) standard specifies that an SRP initiator must never =
queue more
>> than (SRP request limit) - 1 unanswered SRP_CMD information units. T=
his patch
>> makes sure that the SCSI mid-layer never tries to queue more than (S=
RP request
>> limit) - 1 SCSI commands to ib_srp. This improves performance for ta=
rgets
>> whose request limit is less than or equal to SRP_SQ_REQ_SIZE (63) by=
 reducing
>> the number of BUSY responses reported by ib_srp to the SCSI mid-laye=
r.
>
> Actually, the standard states we can never send more than REQUEST LIM=
IT
> requests. But we reserve 1 request for sending task management reques=
ts,
> so that's why we need to tell the mid-layer to not send us more than
> req_lim - 1 commands.

The SRP spec says the following about the request limit and management =
commands:

c) An SRP initiator port may send an SRP request on an RDMA channel
when the value of the RDMA
channel=92s Request Limit variable is greater than zero. An SRP
initiator port shall not send an SRP
request on any RDMA channel whose Request Limit variable has a value
less than or equal to zero; the
results of doing so are vendor-specific. To ensure that task
management requests may be sent, an SRP
initiator port may choose to send commands only when the value of the
Request Limit variable is greater
than one;

So reserving one queue element for management commands is not a
requirement but a recommendation. I agree that the patch description
has to be updated.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
