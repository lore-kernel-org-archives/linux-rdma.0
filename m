From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][PATCH v2 0/6] i40iw: Fixes for i40iw
Date: Tue, 22 Aug 2017 15:39:35 -0400
Message-ID: <1503430775.78641.7.camel@redhat.com>
References: <20170809013848.29080-1-henry.orosco@intel.com>
         <1502897345.33760.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502897345.33760.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-16 at 11:29 -0400, Doug Ledford wrote:
> Hi Henry,
> 
> I took everything for -rc *Except* the Improve CQP timeout logic
> patch.
>  That patch qualifies as new development and not really a bug fix,
> and
> since we are at -rc5, new development needs to be in for-next
> instead.

Hi Henry,

I've pulled the CQP timeout patch into for-next.  Thanks.


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
