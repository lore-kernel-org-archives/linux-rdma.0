From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 37/37] IB/rdmavt: Add support for new memory registration API
Date: Thu, 17 Dec 2015 11:49:15 -0500
Message-ID: <20151217164914.GC29455@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <20151207204540.8144.94303.stgit@phlsvslse11.ph.intel.com> <5669940D.4040402@dev.mellanox.co.il> <566EEBE8.8020007@dev.mellanox.co.il> <20151214171440.GC23833@phlsvsds.ph.intel.com> <5671653E.40501@dev.mellanox.co.il> <20151216142224.GA28117@phlsvsds.ph.intel.com> <56717733.7070105@dev.mellanox.co.il> <20151217155228.GA29455@phlsvsds.ph.intel.com> <20151217163553.GA22222@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151217163553.GA22222-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 17, 2015 at 08:35:53AM -0800, Christoph Hellwig wrote:
>On Thu, Dec 17, 2015 at 10:52:29AM -0500, Dennis Dalessandro wrote:
>> I am not opposed to leaving the code in rdmavt. It gets removed from qib in
>> the other patch series I posted. My preference is to leave it in rdmavt
>> since it will be needed down the road. However I can go either way here, its
>> easy to add back later.
>
>Without setting IB_DEVICE_MEM_MGT_EXTENSIONS and implementing all the
>features required for it it's dead code.  There is no point to keep
>it around.

Ok, sounds good to me. I will drop this patch when I post the v2.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
