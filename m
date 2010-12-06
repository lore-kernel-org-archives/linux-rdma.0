From: Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: Re: IPoIB to Ethernet routing performance
Date: Mon, 06 Dec 2010 21:47:42 +0100
Message-ID: <4CFD4BEE.5070205@shiftmail.org>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20101206112454.76bb85f1-xRPE6/W2vR9iM9LT7/dT9zWMkbuR3peG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>    The router is fitted with one ConnectX2 QDR HCA and one dual port Myricom 10G
> Ethernet adapter.
>
> ...
>
>    Here are some numbers:
>
>    - 1 IPoIB stream between client and router: 20 Gbits/sec
>
>      Looks OK.
>
>    - 2 Ethernet streams between router and server: 19.5 Gbits/sec
>
>      Looks OK.
>    


Actually I am amazed you can get such a speed with IPoIB. Trying with 
NPtcp on my DDR infiniband I can only obtain about 4.6Gbit/sec at the 
best packet size (that is 1/4 of the infiniband bandwidth) with this 
chip embedded in the mainboard: InfiniBand: Mellanox Technologies 
MT25204 [InfiniHost III Lx HCA]; and dual E5430 xeon (not nehalem).
That's with 2.6.37 kernel and vanilla ib_ipoib module. What's wrong with 
my setup?
I always assumed that such a slow speed was due to the lack of 
offloading capabilities you get with ethernet cards, but maybe I was 
wrong...?
Also what application did you use for the benchmark?
Thank you
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
