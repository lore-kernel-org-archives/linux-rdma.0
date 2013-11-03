From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 07/10] IB/mlx5: Keep mlx5 MRs in a radix tree under
 device
Date: Sun, 3 Nov 2013 15:40:58 +0200
Message-ID: <5276526A.3090509@mellanox.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-8-git-send-email-sagig@mellanox.com> <5274131C.90601@acm.org> <52763E88.4050300@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52763E88.4050300-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/11/2013 14:16, Sagi Grimberg wrote:
> mlx5 currently doesn't support 32-bit platforms, I'll take your 
> suggestion. 

I think 32-bit x86 is supported, but anyway, as we're picking your 
suggestion, should be fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
