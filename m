From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: Documentation for libiverbs?
Date: Wed, 13 Jan 2010 13:44:25 +0200
Message-ID: <4B4DB219.2020406@mellanox.co.il>
References: <S1752421Ab0AMJqp/20100113094645Z+1609@vger.kernel.org> <4B4D9B1E.1020604@eso.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B4D9B1E.1020604-hv++7WL8WN4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Werther Pirani <wpirani-hv++7WL8WN4@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/13/2010 12:06 PM, Werther Pirani wrote:
>    Hello,
>
> I've been redirected to this list from OpenFabrics' web site, so let 
> me apologise right away if this is not the right place for this question.
>
> We are writing an application that requires high throughput and low 
> latency. More specifically, we need to take advantage of features like 
> RDMA, possibly through the ibv_ API in libiverbs, but the 
> documentation available is really too sketchy to be of any help (and 
> even the OpenFabrics' web site isn't of any use in this respect).
>
> At the moment all I have to go by is the RDMA_RC_example in the "RDMA 
> Ware Network Programming User's Manual" from Mellanox, but it's really 
> not quite enough. Since even searching the web isn't turning out any 
> documentation, I was wondering if anyone here has any to share.
>
>
You can look at the ping-pong examples that come with libibverbs. 
http://www.openfabrics.org/downloads/libibverbs/
Also you can look at the performance tests (ib_write_lat, ib_write_bw, 
etc). http://www.openfabrics.org/downloads/perftest/

Tziporet


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
