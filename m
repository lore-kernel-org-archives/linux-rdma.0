From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value returned
 when the port is down
Date: Wed, 4 Apr 2012 09:38:03 +0300
Message-ID: <4F7BEC4B.2030503@mellanox.com>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com> <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com> <CAL1RGDXvR-kk7TE3O33PrifuYoKkgdgAJ9aY5JkduywEf56w+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXvR-kk7TE3O33PrifuYoKkgdgAJ9aY5JkduywEf56w+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 10:27 PM, Roland Dreier wrote:
> This looks reasonable, applied

Thanks, so we're in a situation where there are / will be fixes for 3.4 
and new code for 3.5 is coming, how about that suggestion I made lately 
-  for-next to contain code for the next kernel (e.g 3.5 at this point) 
and have a different branch (maybe rc-fixes) to track fixes for the 
current kernel (e.g 3.4)?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
