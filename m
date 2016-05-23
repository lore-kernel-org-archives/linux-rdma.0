From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] Staging: rdma: hfi1: sdma.c: Fixed coding style issues
Date: Mon, 23 May 2016 08:43:15 -0400
Message-ID: <20160523124314.GC16764@phlsvsds.ph.intel.com>
References: <1463985362-8429-1-git-send-email-mayhs11saini@gmail.com> <1463985362-8429-2-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463985362-8429-2-git-send-email-mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 23, 2016 at 12:06:02PM +0530, Shyam Saini wrote:
>Fixed following checkpatch.pl warnings:
>    Prefer 'unsigned int' to bare use of 'unsigned'
>    Prefer READ_ONCE(<FOO>) over ACCESS_ONCE(<FOO>)

Same response [1] as to your previous patch. If you do spin the READ_ONCE 
bit please squash the two.

[1] http://marc.info/?l=linux-rdma&m=146400717024632&w=2

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
