From: Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] complib/cl_timer.c: fixing cl_timer calculation
Date: Wed, 25 Aug 2010 22:15:58 +0300
Message-ID: <4C756BEE.3090404@dev.mellanox.co.il>
References: <4C7287C8.1040106@dev.mellanox.co.il> <20100823185529.GG5837@me> <4C73B333.3080007@dev.mellanox.co.il> <4C73B4B3.1030204@dev.mellanox.co.il> <20100825160727.GI5837@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100825160727.GI5837@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tzachi Dar <tzachid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 25-Aug-10 7:07 PM, Sasha Khapyorsky wrote:
> On 15:01 Tue 24 Aug     , Yevgeny Kliteynik wrote:
>>
>> BTW, any idea what are the (obviously historical)
>> reasons for these lines in the code?
>>
>> 323:	/* do not do 0 wait ! */
>> 324:	/* if (delta_time<  1000.0) {delta_time = 1000;} */
> 
> Have no idea. This is from day zero of git history.

Well, it's not there any more.

-- Yevgeny

> Sasha
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
