From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 37/37] IB/rdmavt: Add support for new memory registration
 API
Date: Thu, 10 Dec 2015 17:02:37 +0200
Message-ID: <5669940D.4040402@dev.mellanox.co.il>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204540.8144.94303.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204540.8144.94303.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> commit 38071a461f0a ("IB/qib: Support the new memory registration API")"
> added support for map_mr_sg to qib. This patch brings that
> support into rdmavt, it also adds a register mr function that will be
> called from the post send routine which is inline with the qib patch.

Hi Dennis and Ira,

This question is not directly related to this patch, but given that
this is a copy-paste from the qib driver I'll go ahead and take it
anyway. How does qib (and rvt now) do memory key invalidation? I didn't
see any reference to IB_WR_LOCAL_INV anywhere in the qib driver...

What am I missing?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
