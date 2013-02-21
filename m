From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: ib_read_lat question
Date: Thu, 21 Feb 2013 12:34:39 -0600
Message-ID: <512668BF.4030908@opengridcomputing.com>
References: <51265E60.1070609@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823736F35235F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F35235F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/21/2013 12:27 PM, Hefty, Sean wrote:
>> ib_read_lat displays RTT latency, while the other lat programs display
>> RTT/2.  Is this intended?  Or is read_lat.c/print_report() missing a
>> divide-by-two?
> The tests should measure how long it takes the data to reach the destination.  For writes/sends, that would be RTT/2.  For reads, the destination is local, so you should want RTT.

Guess that makes sense.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
