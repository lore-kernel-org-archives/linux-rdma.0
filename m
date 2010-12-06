From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: user SA notifications, redux
Date: Mon, 6 Dec 2010 12:19:18 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF503@MNEXMB1.qlogic.org>
References: <4CBF0AD7.80904@systemfabricworks.com>
 <4CC831C4.5030502@dev.mellanox.co.il>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D4675EEB@MNEXMB1.qlogic.org>
 <4CC959B9.7030402@dev.mellanox.co.il>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3DB@MNEXMB1.qlogic.org>
 <4CFD1423.7000201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFD1423.7000201-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Well, the first thing is that notices don't really include information on which subscription triggered them, although I suppose the receiver could keep track of all subscriptions and try to figure out which ones are fulfilled by the forwarded trap.

But I have to admit, while the spec says that entities that support forwarding will ignore duplicate informinfos I was wrong in saying that means anything that has the same trap #. The spec doesn't seem to specify at all.

So, I guess there's no problem in managing traps by lid range, gid, et cetera.

-----Original Message-----
From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] 
Sent: Monday, December 06, 2010 11:50 AM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: user SA notifications, redux

On 12/3/2010 1:50 PM, Mike Heinz wrote:
> My concern there is that my reading of the spec says that a node can only subscribe
> to a particular trap once;

Where in the spec do you see this ?

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
