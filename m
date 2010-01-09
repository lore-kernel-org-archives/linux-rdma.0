From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is
 sequential I/O coalesced, and 3) why is iSCSI faster than SRP in some
 instances
Date: Fri, 08 Jan 2010 20:20:10 -0500
Message-ID: <1263000010.14204.45.camel@obelisk.thedillows.org>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
	 <1262829441.29991.10.camel@obelisk.thedillows.org>
	 <f3177b9e1001081340r323c53cela2fb22907212fc2b@mail.gmail.com>
	 <1262989053.14204.21.camel@obelisk.thedillows.org>
	 <f3177b9e1001081439j3730acefrbfcf523b0da06306@mail.gmail.com>
	 <1262992077.14204.39.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262992077.14204.39.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2010-01-08 at 18:07 -0500, David Dillow wrote:
> But this still isn't hurting you at the small request sizes we seem to
> be talking about. Or do you mean 58 KB, which is believable -- the
> default is 12, which guarantees a 48 KB request size is possible, and
> you'd only need a few pages to coalesce and you be there. Of course, 58
> isn't a multiple of 4, so maybe it isn't just me misunderstanding.

DOh, edited too fast, this should be "maybe it is just me
misunderstanding."

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
