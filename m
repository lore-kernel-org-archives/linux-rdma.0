From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 13/20] IB/hfi1: Adjust high temperature warning for QSFP
 cable
Date: Fri, 28 Apr 2017 13:43:15 -0400
Message-ID: <1493401395.3041.163.camel@redhat.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
         <20170409171646.10579.73509.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171646.10579.73509.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-04-09 at 10:16 -0700, Dennis Dalessandro wrote:
> --- a/drivers/infiniband/hw/hfi1/chip.c
> +++ b/drivers/infiniband/hw/hfi1/chip.c
> @@ -9325,7 +9325,7 @@ static int handle_qsfp_error_conditions(struct
> hfi1_pportdata *ppd,
>  
>         if ((qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_ALARM) ||
>             (qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_WARNING))
> -               dd_dev_info(dd, "%s: QSFP cable on fire\n",
> +               dd_dev_info(dd, "%s: QSFP cable temperature too
> high\n",
>                             __func__);

Aww, man, being professional takes the fun out of everything :-/

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
