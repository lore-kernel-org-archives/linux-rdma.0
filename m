From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 3/4] rsockets: distribute completion queue vectors
 among multiple cores
Date: Tue, 16 Sep 2014 04:57:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DD3DA8@ORSMSX109.amr.corp.intel.com>
References: <f028f54b9900ee34fcd1abd1d90d10e6@imap.linux.ibm.com>
 <5409DB0D.6080103@acm.org>
 <850a2835b5917f6da62af3d1ea0288fd@imap.linux.ibm.com>
 <540D50E9.5050709@acm.org>
 <a8ac21f3c9d7c802ab089bc0d432e40b@imap.linux.ibm.com>
 <540DF3CC.1060304@acm.org>
 <edc2b05703209d2a7626a31abb170ceb@imap.linux.ibm.com>
 <ef556922e7b766360a38df904dff1c70@imap.linux.ibm.com>
 <5416ABFB.7040701@acm.org>
 <d5804c38cb47bcc79eb3962cf8ca6989@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d5804c38cb47bcc79eb3962cf8ca6989-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Thanks for your detailed thoughts and insights into comp vector
> assignment.  As you rightly pointed out, let's hear from wider
> community as well before we attempt another iteration on the path.
> I have included below some details about the latest patch to
> understand where we are currently.

Are there any similar mechanisms defined elsewhere that we can use as guidance?

I don't recall, does completion vector 0 refer to a specific vector or does it mean use a default assignment?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
