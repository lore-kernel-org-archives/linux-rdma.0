From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: ib_srp and sg_tablesize
Date: Wed, 28 Dec 2011 19:46:14 +0000
Message-ID: <CAO+b5-ow93i7RuZuzg8XLO-wveVjJuZOG+weaHLvbH8H09=+RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Dave,

Something I noticed while working on the ib_srp sysfs documentation:
commit c07d424d6118d528ef71b22b7424bfc359c307a5 allows to specify the
value of sg_tablesize in the SRP login string but ignores that value
entirely. Was that on purpose ? Shouldn't the statement
"target->sg_tablesize = indirect_sg_entries ? : cmd_sg_entries" rather
have been something like "if (!target->sg_tablesize)
target->sg_tablesize = indirect_sg_entries ? : cmd_sg_entries" ?

Regards,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
