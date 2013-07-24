From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH, RFC] mlx4: Avoid that mlx4_cmd_wait() contributes to
 the system load
Date: Wed, 24 Jul 2013 18:48:31 +0200
Message-ID: <51F0055F.7000703@acm.org>
References: <51ED4E60.30203@acm.org> <51EFF018.7050409@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51EFF018.7050409-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/24/13 17:17, Or Gerlitz wrote:
> On 22/07/2013 18:23, Bart Van Assche wrote:
>> Avoid that kernel threads running mlx4_cmd_wait() contribute to the
>> system load by setting the task state to TASK_INTERRUPTIBLE instead
>> of TASK_UNINTERRUPTIBLE while waiting. This patch reduces the load
>> average from about 0.5 to about 0.0 on an idle system with one mlx4
>> HCA and no IB cables connected.
>
> Before diving to the implications of the patch, lets discuss the
> phenomena you see...
> So the load average on this idle system is 0.5 or 0.05?
>
> I don't see 0.5 or a like on my systems that are installed with HCAs and
> are idle.  Could it
> be that some IB management entity is repeatedly  sending MADs to this
> system?

Hello Or,

I saw a load of 0.5 with several different upstream kernels (3.6..3.10 
at least). The only IB-related process that was running on the system 
was opensmd. This is definitely reproducible. It was only a month after 
I had noticed this phenomenon that I started searching for the root cause.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
