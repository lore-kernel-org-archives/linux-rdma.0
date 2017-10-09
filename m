From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: use setup_timer() helper function.
Date: Mon, 09 Oct 2017 12:08:16 -0400
Message-ID: <1507565296.46071.31.camel@redhat.com>
References: <1506942951-10917-1-git-send-email-allen.pais@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506942951-10917-1-git-send-email-allen.pais-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Allen Pais <allen.pais-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-Kuom3nnY0e0@public.gmane.org, Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-02 at 16:45 +0530, Allen Pais wrote:
> From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> This series uses setup_timer() helper function. The series
> addresses the files under drivers/infiniband/hw/*.
> 
> Signed-off-by: Allen Pais <allen.pais-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hi Allen,

This patch is being superseded by other work in the community.  In
particular, they are making changes to the timer core, and instead of
using setup_timer() there is a new timer_setup() routine they want used
instead.  The people doing the work have posted those patches to the
rdma list so this one is being dropped in preference to those.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
