From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bug 15095] New: ib_srp module removal triggers circular locking complaint
Date: Wed, 20 Jan 2010 11:15:33 -0800
Message-ID: <adar5pk8u5m.fsf@roland-alpha.cisco.com>
References: <bug-15095-11804@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bug-15095-11804-V0hAGp6uBxO456/isadD/XN4h3HLQggn@public.gmane.org/>
	(bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org's message of "Wed, 20 Jan 2010
	19:06:59 GMT")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Looks like a sysfs problem or maybe a SCSI - sysfs interaction that
doesn't have much to do with ib_srp in particular.  The two locks
involved, namely s_active and attribute_container_mutex, are completely
outside of ib_srp and are taken out of its control.

This is probably triggering now because of the new commit 846f9974
("sysfs: Add lockdep annotations for the sysfs active reference") that
is tracking s_active nesting now.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
