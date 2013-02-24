From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fail I/O requests if the transport is offline
Date: Sun, 24 Feb 2013 16:42:11 +0200
Message-ID: <CAJZOPZJcPp19VqcvjZxAgZXt3LNuNshkxULYtoaad76Z8KMVsA@mail.gmail.com>
References: <510BDCAA.204@acm.org>
	<CAJZOPZLKQV0QvrW5sK8hQJf7AZc+1nUzp+5YCkZ3iVU4oTWbLg@mail.gmail.com>
	<5111327F.6050402@acm.org>
	<CAJZOPZ+-Zg=jnqg4ZmFL5Yo4_2DoWGcgy=3u6g3Rf9y80pXnpg@mail.gmail.com>
	<5112049B.8030406@acm.org>
	<5112CE60.2030607@mellanox.com>
	<51136E74.9090209@acm.org>
	<5113F056.4020501@mellanox.com>
	<511E024E.70002@acm.org>
	<1361160385.7415.2.camel@obelisk.thedillows.org>
	<5121E217.3080003@mellanox.com>
	<5129CAB6.5030506@acm.org>
	<5129D665.3070206@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5129D665.3070206-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 24, 2013 at 10:59 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 2/24/2013 10:09 AM, Bart Van Assche wrote:
>> On 02/18/13 09:11, Sagi Grimberg wrote:
>>> On 2/18/2013 6:06 AM, David Dillow wrote:

>>>> Or, Vu, does this solve the issue you've seen? I may have time to test
>>>> later this week, but not before.

>>> This indeed solve scsi_host removal issues.
>>> Vu is on vacation, I'll perform some more failover tests...

>> Hello Sagi, Since no further feedback
>> was posted on the list I assume that means that all tests passed ?

> Hey Bart, Sorry for the delay I was just about to reply...
> From my end, the related patchset seems solve the scsi_host removal issue
> and prevents the SCSI error handling loop.


> Generally our tests passed, I still have some issue with long-term
> failover test but I'm not sure its SRP (perhaps might origin in IB layer).
> So ack from me...

OK

Dave/Roland - sounds like we did managed to get real progress here...
lets get these fix in for 3.9 and 3.8-stable too,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
