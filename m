From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for 3.8 v3, resend 0/3] IB/SRP patches for kernel 3.8
Date: Mon, 4 Feb 2013 23:11:49 +0200
Message-ID: <CAJZOPZLKQV0QvrW5sK8hQJf7AZc+1nUzp+5YCkZ3iVU4oTWbLg@mail.gmail.com>
References: <510BDCAA.204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510BDCAA.204-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 1, 2013 at 5:18 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> This patch series avoids that SCSI error handling triggers an endless loop
> and also restores reporting of QP errors in the kernel log.

Bart,

You wrote "resend" in the subject line, anything new, in these patches
OR in other patches merged through the SCSI tree for 3.8 vs. what you
had posted earlier on Dec 20th, 2012
(http://marc.info/?t=135592692800001&r=1&w=2)?! as I wrote there, it
didn't work for me.

Dave, Roland, as I wrote here
http://marc.info/?l=linux-rdma&m=135603401830703&w=2 I think what we
need now is 2nd opinion, and I asked if Dave can give the patches a
try, no more but no less... we need to know if it works

Or.

> Changes between v3 and v2:
> - As proposed by Dave, added a patch that prevents sending of a task
>   management function over a closed connection.
>
> Changes between v2 and v1:
> - Track connection state properly.
> - Make srp_reset_host() reset requests even if reconnecting fails
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
