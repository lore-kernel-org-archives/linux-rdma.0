From: "Young, Eric R." <Eric.Young-itBhTGHPdi0@public.gmane.org>
Subject: Trying to link with DAT 2.0 function
Date: Tue, 12 Oct 2010 08:15:50 -0500
Message-ID: <1F77938CC2143D47AE7204B1DB33104C02C9FE84@XMBIL151.northgrum.com>
References: <1F77938CC2143D47AE7204B1DB33104C02C9FC57@XMBIL151.northgrum.com> <E3280858FA94444CA49D2BA02341C983011B575529@orsmsx506.amr.corp.intel.com> <1F77938CC2143D47AE7204B1DB33104C02C9FD0E@XMBIL151.northgrum.com> <E3280858FA94444CA49D2BA02341C983011B5755C8@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <E3280858FA94444CA49D2BA02341C983011B5755C8-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

My motivation for using the dat_cno_fd_create() is that I am able
register a file descriptor with a reactor (all events go through a
reactor which has multiple I/O including I/O which is not at all tied to
uDAPL). An application is able to work on other tasks while waiting for
the reactor to call back on the file descriptor when an event is
available. To achieve the same behavior with a dat_cno_wait(), I would
have to spawn off another thread which blocks on dat_cno_wait(), then
notify the reactor (to queue up a reactor event) when the dat_cno_wait()
is unblocked, lock critical sections of code, etc.,. If the
dat_cno_fd_create() function was available to me, it would seem to be a
cleaner way to achieve this functionality.

-----Original Message-----
From: Davis, Arlin R [mailto:arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Monday, October 11, 2010 5:34 PM
To: Young, Eric R.; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: EXTERNAL:RE: Trying to link with DAT 2.0 function

>Do you have a roadmap available? Is this planned to be implemented in
>the near future?

There are no plans. I really don't know how this call even made
it in the specification given that DAT is suppose to be O/S agnostic.

In any case, can you use dat_cno_wait() on top of the EVD's 
as a means to support/trigger multiple event streams? What is driving 
your choice to use dat_cno_fd_create()? Maybe we can come up 
with an alternative with the existing API.

Arlin





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
