From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/cma: Fix null pointer issue
Date: Fri, 2 Feb 2018 11:38:56 -0700
Message-ID: <20180202183856.GZ23352@mellanox.com>
References: <1517553759-12272-1-git-send-email-guanglei.li@oracle.com>
 <c7f0ebf5-6e67-18d4-c04f-088bb558621d@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c7f0ebf5-6e67-18d4-c04f-088bb558621d-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yanjzhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, honglei.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 02, 2018 at 03:22:18PM +0800, yanjzhu wrote:
> Hi, Guanglei
> 
> The checkpatch checks your patch. The followings are the result.
> 
> CHECK: Alignment should match open parenthesis
> #148: FILE: net/rds/ib.c:349:
> +    cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler,
> +            NULL, RDMA_PS_TCP, IB_QPT_RC);
> 
> total: 2 errors, 0 warnings, 1 checks, 9 lines checked
> 
> NOTE: For some of the reported defects, checkpatch may be able to
>       mechanically convert to the typical style using --fix or
> 
> 1.patch has style problems, please review.

Also please try to write a more detailed commit message about what can
trigger this.. Is it userspace or remote network?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
