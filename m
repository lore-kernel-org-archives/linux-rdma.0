From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: kernel inline sending / UARs / etc
Date: Mon, 08 Nov 2010 10:27:15 +0200
Message-ID: <4CD7B463.2030402@voltaire.com>
References: <Pine.LNX.4.64.1011080936200.14213@zuben.voltaire.com>	<E113D394D7C5DB4F8FF691FA7EE9DB443D1BB38721@MTLMAIL.mtl.com>	<4CD7ABF4.5090305@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443D1BB387C7@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443D1BB387C7-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> The idea is to let kernel consumers enjoy the improvements to latency that blue flame gives. And yes, SDP is motivating us but I am going to push to IPoIB too.
>   
 From my recollection of numbers, for user space apps, using inline 
accounts for about 1us improvement in the latency, if this is indeed the 
case, I'm sure if there's great value here for kernel consumers, do you 
have any numbers to support this patch?

> I want to take the opportunity that you raised the issue to hear others opinion about changing the bitmap allocator maintain an "avail" variable that will count the number of available UARs. I want to use this to limit the number of UARs that a kernel consumer can allocate so that there will always be some available for userspace 
Is this correct that today all the kernels QPs use the same UAR, any 
problem with that?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
