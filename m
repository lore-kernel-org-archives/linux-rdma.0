From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 37/37] IB/rdmavt: Add support for new memory registration
 API
Date: Wed, 16 Dec 2015 15:21:02 +0200
Message-ID: <5671653E.40501@dev.mellanox.co.il>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204540.8144.94303.stgit@phlsvslse11.ph.intel.com>
 <5669940D.4040402@dev.mellanox.co.il> <566EEBE8.8020007@dev.mellanox.co.il>
 <20151214171440.GC23833@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214171440.GC23833-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> This question is not directly related to this patch, but given that
>>> this is a copy-paste from the qib driver I'll go ahead and take it
>>> anyway. How does qib (and rvt now) do memory key invalidation? I didn't
>>> see any reference to IB_WR_LOCAL_INV anywhere in the qib driver...
>>>
>>> What am I missing?
>>
>> ping?
>
> In short, it doesn't look like qib or hfi1 support this.

Oh, I'm surprised to learn that. At least I see that
qib is not exposing IB_DEVICE_MEM_MGT_EXTENSIONS. But whats
the point in doing something with a IB_WR_REG_MR at all?

Given that this is not supported anyway, why does this patch
exist?

> That doesn't mean it can't be added to rdmavt as a future enhancement
> though if there is a need.

Well, given that we're trying to consolidate on post send registration
interface it's kind of a must I'd say.

> Are you asking because soft-roce will need it?

I was asking in general, but in specific soft-roce as a consumer will
need to support that yes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
