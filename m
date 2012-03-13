From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/RFC] mxl4_core: Scale size of MTT table with system RAM
Date: Tue, 13 Mar 2012 08:27:25 +0200
Message-ID: <4F5EE8CD.7020909@mellanox.com>
References: <1330970972-10225-1-git-send-email-roland@kernel.org> <CAJZOPZ+qLzZaH=fmKVRE0K559DoeQ1SsrsjSDY0TS-z8+WjnYQ@mail.gmail.com> <CAL1RGDVaGpVXukyKpJ2vPZE3br4UWn+td8Ba03fKHuY-53H2vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVaGpVXukyKpJ2vPZE3br4UWn+td8Ba03fKHuY-53H2vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/13/2012 1:29 AM, Roland Dreier wrote:
> It's just a heuristic, but I figured some app might want to register 
> essentially all of memory, and then we want some more to cover other 
> users. The amount of memory used for unused MTT space is pretty small, 
> I think. 

If an app registered essentially all memory, then practically nothing 
else left for other users, or you refer to the case where the driver 
consumed an MTT segment made of 8 elements on behalf of a certain app 
but didn't use all the MTT entries of that segment?

> I fixed the mxl4->mlx4, thanks.

sure,

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
