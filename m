From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Tue, 22 Sep 2015 10:19:06 +0300
Message-ID: <560100EA.8080302@mellanox.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <55FDEDD5.1090105@oracle.com> <55FE7E24.20300@dev.mellanox.co.il>
 <5600928A.7070202@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5600928A.7070202-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> As mentioned earlier, I have a WIP RDS fastreg branch [3]
> which is functional (at least I can RDMA messages across
> nodes ;-)).

Nice!

> So merging [2] and [3], I created [4] and applied
> a delta change based on your other patches. I saw ib_post_send
> failure with my HCA driver returning '-EINVAL'. I didn't
> debug it further but at least opcode and num_sge were set
> correctly so I shouldn't have seen it. So I did memset()
> on reg_wr which seems to have helped to fix the ib_post_send()
> failure.

Yep - that was my fault. When converting the ULPs I optimized by 
removing the memset but I forgot to set reg_wr.wr.next = NULL when
the ULP needed. This caused the driver to read a second bogus work 
request. Steve just reported this as well so I'll fix that in v2.

>
> But I got into remote access errors which tells me that I
> have messed up setup(rkey, sge setup or access flags)

One thing that pops is that in the old API the MR was registered
with iova_start = 0 (which is probably what was sent to the peer),
but the new API the iova is implicitly sg_dma_address(&sg[0]).

The registered MR holds these attributes in:
mr->rkey
mr->iova
mr->length

These should be passed to a peer to perform rdma.

Hope this helps,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
