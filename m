From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Hang in ib_umad when attempting to unregister.
Date: Mon, 3 May 2010 10:58:17 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A47409F6@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A47409EA@MNEXMB1.qlogic.org>
 <57C080F9018D4C488FD7F575E2CE231F@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57C080F9018D4C488FD7F575E2CE231F-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LINUX-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,

This has happened on a couple of different systems in our test fabric, but the most recent occurrences are with RHEL5 and SLES11:

RHEL5.3 2.6.18-128.el5
SLES11 2.6.27-19-5-default

-----Original Message-----
From: Sean Hefty [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Monday, May 03, 2010 11:48 AM
To: Mike Heinz; LINUX-RDMA
Subject: RE: Hang in ib_umad when attempting to unregister.

>In my company's test labs, we've been seeing nodes occasionally hang when a
>process tries to disconnect from the ib_mad interface. Can anyone suggest what
>might be causing this?

What kernel are you running?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
