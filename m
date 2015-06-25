From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re:  [PATCH V2] IB/mad: Remove improper use of BUG_ON
Date: Thu, 25 Jun 2015 18:06:07 +0300
Message-ID: <558C18DF.6010307@mellanox.com>
References: <1435240370-18161-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435240370-18161-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/25/2015 4:52 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny<ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> We recently added BUG_ON's which were inappropriate for a condition which
> should never happen. Change these to be WARN_ON_ONCE as a debugging aid.
>
> Fixes: 4cd7c9479aff ('IB/mad: Add support for additional MAD info to/from drivers')
>
> Signed-off-by: Ira Weiny<ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

remove the blank line,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
