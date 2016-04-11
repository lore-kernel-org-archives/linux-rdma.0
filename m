From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/11] IB/hfi1: Additional fixes for 4.6
Date: Mon, 11 Apr 2016 09:52:44 -0400
Message-ID: <20160411135243.GA16403@phlsvsds.ph.intel.com>
References: <20160315174916.613.12254.stgit@scvm10.sc.intel.com> <20160407202403.GA7211@phlsvsds.ph.intel.com> <570A8C88.1040409@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570A8C88.1040409-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 10, 2016 at 08:25:28PM +0300, Sagi Grimberg wrote:
>Hey Dennis,
>
>>I have some additional patches as well. Perhaps it is more than we want
>>in an RC. I'm going to reorder things and submit two patch sets. One
>>that fixes critical bugs, and should most likely go in RC.
>
>I was just about to point out that the last two patches really don't
>look like RC material. I'd suggest deferring these two for the next
>merge window...

Yes I tend to agree. There are three patches from this series that I think 
need to go in the next RC:

[PATCH 03/11] IB/rdmavt: Fix adaptive pio hang
http://marc.info/?l=linux-rdma&m=145806446130951&w=2

[PATCH 04/11] IB/hfi1: Prevent NULL pointer deferences in caching code
http://marc.info/?l=linux-rdma&m=145806447530956&w=2

[PATCH 05/11] IB/hfi1: Fix deadlock caused by locking with wrong scope
http://marc.info/?l=linux-rdma&m=145806447730959&w=2

I have some others that I hope to get out really soon as well, they also fix 
major bugs. I'll re-send a new series soon.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
