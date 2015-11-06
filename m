From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 1/1] staging: rdma: hfi1 : Prefer using the BIT macro
Date: Fri, 6 Nov 2015 15:26:09 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259A0184@fmsmsx120.amr.corp.intel.com>
References: <1446784603-8084-1-git-send-email-sunnyk@cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446784603-8084-1-git-send-email-sunnyk-If5XQcfNmg0@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sunny Kumar <sunny.kumar.roy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sunny Kumar <sunnyk-If5XQcfNmg0@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Cc: Sunny Kumar
> Subject: [PATCH v2 1/1] staging: rdma: hfi1 : Prefer using the BIT macro
> 
> This patch replaces bit shifting on 1 with the BIT(x) macro
> 
> Signed-off-by: Sunny Kumar <sunnyk-If5XQcfNmg0@public.gmane.org>
> ---

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
