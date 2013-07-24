From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH, RFC] mlx4: Avoid that mlx4_cmd_wait() contributes to
 the system load
Date: Wed, 24 Jul 2013 20:06:04 +0300
Message-ID: <51F0097C.4010806@mellanox.com>
References: <51ED4E60.30203@acm.org> <51EFF018.7050409@mellanox.com> <51F0055F.7000703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F0055F.7000703-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 24/07/2013 19:48, Bart Van Assche wrote:
> I saw a load of 0.5 with several different upstream kernels (3.6..3.10 
> at least). The only IB-related process that was running on the system 
> was opensmd. This is definitely reproducible. It was only a month 
> after I had noticed this phenomenon that I started searching for the 
> root cause. 
do you see it also on systems that don't run opensm?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
