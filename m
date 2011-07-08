From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: dapltest question
Date: Fri, 8 Jul 2011 16:14:49 +0000
Message-ID: <2DDE0F15AAFF91448E6F813C42EF4CBE022102@ORSMSX101.amr.corp.intel.com>
References: <4E1720F1.5080201@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E1720F1.5080201-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>-----Original Message-----
>From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
>Sent: Friday, July 08, 2011 8:23 AM
>To: Davis, Arlin R
>Cc: linux-rdma
>Subject: dapltest question
>
>Hey Arlin,
>
>I have a dumb question:  Is dapltest designed to support multiple dapltest client processes running on multiple physical
>systems to connect to a single dapltest server process/system?
>
>I'm running tests where we have 4 client nodes running dapltest transaction clients connecting to the same dapltest
>server on a 5th node and I'm debugging a dapltest server hang.  I have more details if you're interested, but I just
>wanna make sure dapltest is designed to support this mode.
>

Hi Steve,
  Arlin is out for at least a week.
'dapltest' server is designed to service [1...n] dapltest clients and is routinely tested in this manner.
Send me your dapltest client/server invocations and I'll give them a try.
Which DAPL provider are you using?

Stan.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
