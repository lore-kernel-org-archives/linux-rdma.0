From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2 00/26] New fast registration API
Date: Mon, 28 Sep 2015 14:32:22 -0500
Message-ID: <560995C6.3040909@opengridcomputing.com>
References: <1443116118-10730-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443116118-10730-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/24/2015 12:34 PM, Sagi Grimberg wrote:
> I don't have access to other HW devices (qib, nes) nor iwarp devices so RDS is
> compile tested only. Santosh reports
>
> I'm targeting this to 4.4 so I'll appreciate more feedback and a bigger testing
> coverage.
>
> The code is available at: https://github.com/sagigrimberg/linux/tree/reg_api.4

With these NFSRDMA fixes applied on top of reg_api.4:

https://patchwork.kernel.org/patch/7233211/
https://patchwork.kernel.org/patch/7233231/
https://patchwork.kernel.org/patch/7233251/

I tested NFSRDMA client and server over iw_cxgb4 with NFSv3 and NFSv4.

Looks good.

Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
