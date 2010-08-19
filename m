From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3 v5] IB/srp: Preparation for transmit ring response allocation
Date: Thu, 19 Aug 2010 10:29:32 -0700
Message-ID: <adaiq36se83.fsf@roland-alpha.cisco.com>
References: <201008162054.06416.bvanassche@acm.org>
	<1282175086.25848.17.camel@obelisk.thedillows.org>
	<AANLkTim=ESAvKNCocpCKGuqaGVnO4FMhBck9+NaoRBZB@mail.gmail.com>
	<1282214698.25848.35.camel@obelisk.thedillows.org>
	<AANLkTikNUWtw5fHR44HEWK=ceXQ+mxKSKKS1=qrgudXB@mail.gmail.com>
	<1282238719.9393.3.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282238719.9393.3.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org> (David Dillow's
	message of "Thu, 19 Aug 2010 13:25:18 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > Putting the rsv assignment on the same line as its declaration would
 > > make that line exceed 80 columns and hence would trigger a checkpatch
 > > complaint, so it's better to keep it as it is now.

 > I didn't check it with checkpatch, but vi tells me it is 78 characters.

In any case I think the 80 column thing should be treated as a flexible
guideline, not a strict rule.  If the code looks significantly better
with an 85 or 90 column line than split across two lines, then I think
it's better to keep it on one line.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
