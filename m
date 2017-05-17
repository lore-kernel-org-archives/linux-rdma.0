From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 15/15] RDMA/bnxt_re: Disable FMR by default
Date: Wed, 17 May 2017 08:29:09 -0400
Message-ID: <be1696c2-f93f-5f5e-cbe8-968bf41903e7@intel.com>
References: <1495012791-5053-1-git-send-email-selvin.xavier@broadcom.com>
 <1495012791-5053-16-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495012791-5053-16-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/17/2017 5:19 AM, Selvin Xavier wrote:
> Adding a config mechanism to enable/disable FMR support.
> There are some issues seen with FMR implementation during
> stress traffic. So disabling it by default for now.

If it doesn't work maybe just remove it rather than adding another Kconfig?

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
