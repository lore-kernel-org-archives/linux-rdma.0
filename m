From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibumad: Increase the limit of UMAD_MAX_DEVICES
Date: Wed, 1 Sep 2010 15:43:39 +0300
Message-ID: <20100901124339.GQ5837@me>
References: <4C61E116.9060204@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C61E116.9060204-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 16:30 Tue 10 Aug     , Arputham Benjamin wrote:
> ibstat command doesn't show all HCAs when the number of HCAs in one system
> exceeds 20. We need to change this limit. Increase it to 32 to be consistent
> with the define "IB_UVERBS_MAX_DEVICES = 32"
> 
> Signed-off-by: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
