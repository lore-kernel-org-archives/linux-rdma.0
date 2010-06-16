From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] [PATCH v4] IB Core: RAW ETH support
Date: Wed, 16 Jun 2010 10:54:05 -0500
Message-ID: <4C18F39D.3040609@opengridcomputing.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com>	<1276513450.30132.51.camel@alst60.voltaire.com> <aday6eguhfn.fsf@roland-alpha.cisco.com> <4C18DB37.6050501@opengridcomputing.com> <4C18F21D.3050502@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C18F21D.3050502-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Moni Shoua wrote:
>  
>   
>> It doesn't even look like this patch and the mlx4 patch were ever posted
>> to linux-rdma. Only to the EWG list.
>>
>>     
> Not 100% correct. See thread from April 30.
> Patches to core, libibverbs and NES driver were presented there.
>
>   

I'll go look, but I thought the NES stuff was for RAW_ETY qp types.  Not 
RAW_ETH...

>> Granted our dev process may not be documented, but I always assumed the
>> general idea was to get changes accepted upstream, then pull into ofed.
>> OFED is just a mechanism to make top-of-tree linux work on distro
>> kernels. There are some exceptions, but this stuff shouldn't be an
>> exception.
>>
>> We should all follow this "upstream first" process IMO.
>>
>>     
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
