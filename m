From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: With rxe, udaddy hangs and ibv_rc_pingpong fails.
Date: Sun, 19 Feb 2017 14:13:56 +0200
Message-ID: <357ff205-a774-e46c-ffd7-4860898fff7b@mellanox.com>
References: <CA+1F3TOxmYLO8Ae2-Czq8WnFgmH_PpeUJgsYfDGPScs+5FMO8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+1F3TOxmYLO8Ae2-Czq8WnFgmH_PpeUJgsYfDGPScs+5FMO8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Youngjae Lee <dhrkaeh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/17/2017 12:13 AM, Youngjae Lee wrote:
 > Hi, all.
 >
 > I've been testing soft roce (i.e. rxe) on 2 physical machines running
 > kernel 4.10-rc8 with the latest rdma-core.
 > It seems that a rxe0 device is properly setup on each machine, but any
 > test application from the rdma-core package, for example uddady and
 > ibv_rc_pingpong, fails as you can see below.
 > I've seen a post about similar issues a few weeks ago...any body has
 > had the same issues before ?? or any advice to solve this issue ??
 >
 > BTW, I've investigated it at the rxe kernel module level.
 > I found that the opcode and wr_id of wr are always 0 in the
Hi Youngjae,
We have nightly regression over Soft RoCE and everything seems
to work fine.
Both applications, ibv_rc_pingpong and udaddy run as part of our 
regression and pass successfully.
I suspect that you have a configuration/installation issue in your setup.
try deleting librxe and also re-install the kernel headers and then 
rebuild/install the user space libs.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
