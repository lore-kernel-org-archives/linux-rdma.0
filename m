From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Add missing ioctx->buf + ->dma
 alloc_session_cb init
Date: Mon, 04 Apr 2016 15:42:06 -0700
Message-ID: <1459809726.10124.19.camel@haakon3.risingtidesystems.com>
References: <201604050303.V0jVrIjf%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201604050303.V0jVrIjf%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2016-04-05 at 03:11 +0800, kbuild test robot wrote:
> Hi Nicholas,
> 
> [auto build test WARNING on v4.6-rc2]
> [also build test WARNING on next-20160404]
> [cannot apply to rdma/master]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Nicholas-A-Bellinger/ib_srpt-Add-missing-ioctx-buf-dma-alloc_session_cb-init/20160405-023227
> 
> 
> coccinelle warnings: (new ones prefixed by >>)
> 
> >> drivers/infiniband/ulp/srpt/ib_srpt.c:1987:3-8: WARNING: NULL check
> before freeing functions like kfree, debugfs_remove,
> debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
> reorganizing relevant code to avoid passing NULL values.
> 
> Please review and possibly fold the followup patch.
> 

Folding into the original patch.

Thanks Fengguang!

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
