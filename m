From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Add missing ioctx->buf + ->dma
 alloc_session_cb init
Date: Thu, 07 Apr 2016 15:31:40 -0700
Message-ID: <1460068300.18732.25.camel@haakon3.risingtidesystems.com>
References: <1459794233-19187-1-git-send-email-nab@linux-iscsi.org>
	 <5702B503.1060006@sandisk.com>
	 <1459809672.10124.18.camel@haakon3.risingtidesystems.com>
	 <5702EE56.10503@sandisk.com>
	 <1459810708.10124.25.camel@haakon3.risingtidesystems.com>
	 <57052BCB.6070405@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57052BCB.6070405-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-04-06 at 08:31 -0700, Bart Van Assche wrote:
> On 04/04/2016 03:58 PM, Nicholas A. Bellinger wrote:
> > Are you going to verify this patch..?
> 
> Hello Nic,
> 
> After that the ib_srpt driver has processed a few commands this patch 
> also triggers a kernel crash (list corruption).

What, no backtrace..?

>  I have a look myself into the percpu_ida conversion.
> 

I found a pair of old ConnectX2 in IB mode and I'll be fixing this up
for v4.6-rc, so don't even bother.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
