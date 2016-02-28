From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] configfs: switch ->default groups to a linked list
Date: Sun, 28 Feb 2016 14:09:33 +0100
Message-ID: <20160228130933.GA21578@lst.de>
References: <1456490031-7132-1-git-send-email-hch@lst.de> <56D2D2E2.3000200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D2D2E2.3000200-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 28, 2016 at 12:58:42PM +0200, Sagi Grimberg wrote:
>> -As a consequence of this, default_groups cannot be removed directly via
>> +As a consequence of this, default groups cannot be removed directly via
>>   rmdir(2).  They also are not considered when rmdir(2) on the parent
>>   group is checking for children.
>>
>
> What's changed here?

I removed the underscore in default_groups - while we still have
a member of that name it's not exposed directly anymore, so I'd rather
not have the documentation refer to it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
