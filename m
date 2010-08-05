From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] IB/srp: use multiple CPU cores more effectively
Date: Thu, 05 Aug 2010 09:58:49 -0700
Message-ID: <ada39ut573q.fsf@roland-alpha.cisco.com>
References: <201008031602.37294.bvanassche@acm.org>
	<4C59C34F.2000400@vlnb.net> <adak4o66rir.fsf@roland-alpha.cisco.com>
	<AANLkTikswdOfqoZOmSqmug4ue3KLv3V8NH9W1ME4tnfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikswdOfqoZOmSqmug4ue3KLv3V8NH9W1ME4tnfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Thu, 5 Aug 2010 12:55:17 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  > How about adding blk-iopoll support in ib_srp ? blk-iopoll is the NAPI
  > equivalent for block devices. More information about blk-iopoll can be
  > found here: http://lkml.org/lkml/2009/8/6/395.

Wow, I was not aware of that work at all.  Thanks for the pointer.

Anyway, yes, that does look like it should give a lot of the performance
boost of your kthread change without hurting latency as much.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
