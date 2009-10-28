From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Adjusting minimum packet size or "wait to merge requests" in SRP
Date: Wed, 28 Oct 2009 12:47:45 -0600
Message-ID: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It appears that SRP tries to coalesce and fragment initiator I/O
requests into 64KB packets, as that looks to be the size requested
to/from the device on the target side (and the I/O scheduler is
disabled on the target).

Is there a way to control this, where no coalescing occurs when
latency is an issue and requests are small, and no fragmentation
occurs when requests are large?

Or, am I totally wrong in my assumption that SRP is coalescing/fragmenting data?

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
