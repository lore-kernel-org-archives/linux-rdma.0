From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: NULL pointer dereference in rdma_ucm
Date: Wed, 21 Jul 2010 13:51:31 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAC7A@orsmsx501.amr.corp.intel.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAA57@orsmsx501.amr.corp.intel.com>
 <AANLkTikgvfJ85iCaYaG2My7A92FFXz0Fb9vFhVXtUYyx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikgvfJ85iCaYaG2My7A92FFXz0Fb9vFhVXtUYyx-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Timed out connections might be something that can be compensated for
> in the app.  It is definitely preferable to a kernel panic.  Still,
> I'll work on making OFED-1.5.1 happy before playing around with
> removing the ib_send_cm_mra() call.

FYI - the possible issue I'm describing is in the upstream kernel, so it would also be in 1.5.1.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
