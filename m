From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for 3.8 v3, resend 0/3] IB/SRP patches for kernel 3.8
Date: Tue, 5 Feb 2013 22:54:52 +0200
Message-ID: <CAJZOPZ+-Zg=jnqg4ZmFL5Yo4_2DoWGcgy=3u6g3Rf9y80pXnpg@mail.gmail.com>
References: <510BDCAA.204@acm.org>
	<CAJZOPZLKQV0QvrW5sK8hQJf7AZc+1nUzp+5YCkZ3iVU4oTWbLg@mail.gmail.com>
	<5111327F.6050402@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5111327F.6050402-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 5, 2013 at 6:25 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 02/04/13 22:11, Or Gerlitz wrote:

>> You wrote "resend" in the subject line, anything new, in these patches
>> OR in other patches merged through the SCSI tree for 3.8 vs. what you
>> had posted earlier on Dec 20th, 2012.

> I have just reposted my SCSI device removal patch series. There are

Bart, I'd like to sharpen the point: could you please clarify if the
series posted to linux-rdma stands for itself in the sense that SRP HA
scheme X (please state it) now works/better when the patches applied
on top of the latest 3.8-rc cut? OR for X to do better/work, one needs
this series AND the one you posted to linux-scsi.

Or.

> several changes in v8 of that patch series compared to v7, including:
> * Saving and restoring the host scribble field in the SCSI error handler.
> * A robustness improvement for when the SCSI timeout is below the
>   maximum LLD response processing time.
>
> Version eight of the SCSI device removal patch series can be found here:
> http://github.com/bvanassche/linux/tree/device-removal-fixes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
