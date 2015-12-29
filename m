From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 00/36] Add rdma verbs transport library
Date: Tue, 29 Dec 2015 15:41:02 +0200
Message-ID: <CAG9sBKO7s5+sDXDYs=LfLGqLr6HT-gGBuYJiu6bEKdL_-0rjVA@mail.gmail.com>
References: <20151228205612.29850.7328.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151228205612.29850.7328.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Changes since v1:
> Removed driver specific version
> Fixed license text to remove copyright and put on top
> Return 0 in rvt_map_sg instead of BAD_DMA_AGGRESS
> Remove #include of dma.h from dma.c
> Update comment about protection domain limit
> Remove comment on alternative design for private data
> Rename CDR macro to CHECK_DRIVER_OVERRIDE
> Change all the stubs to return EOPNOTSUPP
> Fix comment style for rvt_query_port
> Fix typo in subject
> Rename rdi.lk_table to rdi.lkey_table
> Rename rvt_sge.m => rvt_sge.cur_map (Sean)
> Rename rvt_sge.n => rvt_sge.cur_seg (Sean)
> Remove rvt_reg_phys_mr
> Drop support for commit 38071a461f0a ("IB/qib: Support the new memory
>                                        registration API")
>
I don't understand what in this change log justifies a V2 for this patch set
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
