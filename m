From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 37/37] IB/rdmavt: Add support for new memory registration API
Date: Thu, 17 Dec 2015 10:52:29 -0500
Message-ID: <20151217155228.GA29455@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <20151207204540.8144.94303.stgit@phlsvslse11.ph.intel.com> <5669940D.4040402@dev.mellanox.co.il> <566EEBE8.8020007@dev.mellanox.co.il> <20151214171440.GC23833@phlsvsds.ph.intel.com> <5671653E.40501@dev.mellanox.co.il> <20151216142224.GA28117@phlsvsds.ph.intel.com> <56717733.7070105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56717733.7070105-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 04:37:39PM +0200, Sagi Grimberg wrote:
>
>>This patch exists to provide parity for what is in qib. Should we not
>>have it?  If not, why do we have:
>>
>>commit 38071a461f0a ("IB/qib: Support the new memory registration API")
>
>That was done by me because I saw this in qib and assumed that it was
>supported. Now that I found out that it isn't, I'd say it should be
>removed altogether shouldn't it?

I am not opposed to leaving the code in rdmavt. It gets removed from qib in 
the other patch series I posted. My preference is to leave it in rdmavt 
since it will be needed down the road. However I can go either way here, its 
easy to add back later.

>
>>>>That doesn't mean it can't be added to rdmavt as a future enhancement
>>>>though if there is a need.
>>>
>>>Well, given that we're trying to consolidate on post send registration
>>>interface it's kind of a must I'd say.
>>>
>>>>Are you asking because soft-roce will need it?
>>>
>>>I was asking in general, but in specific soft-roce as a consumer will
>>>need to support that yes.
>>
>>I think it makes sense to revisit when soft-roce comes in,
>
>I agree.
>
>>since qib/hfi do not need IB_WR_LOCAL_INV.
>
>Can you explain? Does qib/hfi have a magic way to invalidate memory
>regions?

Hfi1 does not currently have any support for memory registration in its post 
send. Qib had the "old FRWR API" support in post_send, which you removed 
since according to the commit message, is not used anymore.

I suppose a follow on patch to your "new memory registration API" patch 
would be needed to add the invalidate. This is the piece I think can be 
added later in rdmavt.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
