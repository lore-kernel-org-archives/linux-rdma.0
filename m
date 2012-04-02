From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value returned
 when the port is down
Date: Mon, 02 Apr 2012 14:02:13 -0400
Message-ID: <4F79E9A5.8020208@dev.mellanox.co.il>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com> <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com> <4F79D558.1000908@dev.mellanox.co.il> <4F79D826.9070605@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F79D826.9070605-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 12:47 PM, Or Gerlitz wrote:
> On 4/2/2012 7:35 PM, Hal Rosenstock wrote:
>> Rather than always overwriting active_speed in this case, wouldn't it
>> be better to only do that for invalid values?
> 
> Yes, I have thought about that, however, spotting invalid values would
> make the code a bit ugly, 

The code for this already exists inside of sysfs.c:rate_show anyhow and
just needs to be made into a global validation routine so mlx4/main.c
can access it. Only a slightly larger patch...

-- Hal

> so I took this approach, Roland?
> 
> Or.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
