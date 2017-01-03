From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/1 v2] ib_srp mr allocation failure
Date: Tue, 3 Jan 2017 15:49:29 +0200
Message-ID: <f23f7f76-c3e4-77f0-9515-6bfd9153879f@mellanox.com>
References: <1483451133-6308-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483451133-6308-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

please ignore the cover letter.
was sent by mistake.

On 1/3/2017 3:45 PM, Max Gurtovoy wrote:
> From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Changes from v1:
> 	- added "Fixes:"
> 	- Cc'ed stable kernel 4.7+
>
> Israel Rukshin (1):
>   IB/srp: fix mr allocation when the device supports sg gaps
>
>  drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
