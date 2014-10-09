From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rsocket: Return ECONNRESET when socket in recv is
 disconnected
Date: Thu, 9 Oct 2014 16:44:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DE7AE7@ORSMSX109.amr.corp.intel.com>
References: <1412806773-23776-1-git-send-email-sean.hefty@intel.com>
 <56553bcab94dc48bde61d36ae9eb5eaa@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56553bcab94dc48bde61d36ae9eb5eaa-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Thanks for the fix.  Now, we are able to see the similar behavior
> between tcp/ip and rsockets when the other end is suddenly closed
> while waiting on data.

Can you read and respond to Jason's comments on this patch?

> That isn't the whole story though - you only get ECONNRESET in some
> cases, and it is OS dependent.
 
> stackoverflow suggets:

> http://stackoverflow.com/questions/2974021/what-does-econnreset-mean-in-the-context-of-an-af-local-socket

> Which looks reasonable to me and matches my experience with socket
> programming on Linux. The Steven's book might have some authoritative
> clarifications on the subject as well.

Based on this information, it's not clear that the current behavior of returning 0 is wrong.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
