From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: iw_cxgb4: use wildcard mapping for getting remote addr info
Date: Thu, 07 May 2015 16:00:50 -0500
Message-ID: <554BD282.7060800@opengridcomputing.com>
References: <20150507145224.28735.97977.stgit@build.ogc.int> <20150507204508.GA1195@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150507204508.GA1195-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/7/2015 3:45 PM, Jason Gunthorpe wrote:
> On Thu, May 07, 2015 at 09:52:24AM -0500, Steve Wise wrote:
>> For listening endpoints bound to the wildcard address, we need to pass
>> the wildcard address mapping to iwpm_get_remote_info() instead of the
>> mapped address of the new child connection.
> It would be nice to see a discussion about what bug this fixes in the
> commit message...
>
> So we can answer the question: Does this need to go to -stable?
>

Without this fix, and with iwarp port mapping enabled, each iw_cxgb4 
connection that is spawned from a listening endpoint bound to the 
wildcard address, will generate an annoying dmesg entry about failing to 
find the remote address mapping info, and the connection state displayed 
in debugfs under /sys/kernel/debug/iw_cxgb4/<pci-slot-no>/eps  will not 
have the peer's address/port mapping info.  The connection still works 
though.

This does not need to hit stable because the remote_info logic was just 
added in 4.1 with:
---
commit 5b6b8fe64053b2649660ded2f3c5be25ebddbfdb
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Apr 21 16:28:41 2015 -0400

     RDMA/cxgb4: Report the actual address of the remote connecting peer
---


Doug, shall I resend the patch with an updated comment?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
