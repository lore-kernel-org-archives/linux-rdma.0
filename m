From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 07/10] xprtrdma: Display async errors
Date: Tue, 11 Nov 2014 22:30:08 +0200
Message-ID: <CAJ3xEMjE3AFEVAYwL-awgmFVACuDHmTPvh8qXeGXh+LkeCnxtg@mail.gmail.com>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net>
	<20141109011501.8806.23478.stgit@manet.1015granger.net>
	<54621D8D.7050508@dev.mellanox.co.il>
	<1D304B95-D745-42B2-9324-143A5002FB35@gmail.com>
	<54625A33.6000506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54625A33.6000506-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 11, 2014 at 8:49 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 11/11/2014 6:52 PM, Chuck Lever wrote:
>>
>>
>>> On Nov 11, 2014, at 8:30 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>> wrote:
>>>
>>>> On 11/9/2014 3:15 AM, Chuck Lever wrote:
>>>> An async error upcall is a hard error, and should be reported in
>>>> the system log.
>>>>
>>>
>>> Could be useful to others... Any chance you put this in ib_core for all
>>> of us?
>>
>>
>> Eventually. We certainly wouldn't want copies of this array of strings
>> to appear many times in the kernel. That would be a waste of space.
>>
>> I have a similar patch that adds an array for CQ status codes, and
>> xprtrdma has a string array already for connection status. Are those
>> also interesting?
>>
>
> Yep, also RDMA_CM events. Would certainly help people avoid source
> code navigation to understand what is going on...

Oh yes, Chuck, good if you can pick  this up, AFAIRemeber most of the
strings are already in the RDS code (net/rds) - please re-factor them
from there into some IB core helpers, thanks alot!!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
