From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: ucma question - backlog limit
Date: Mon, 09 Aug 2010 12:28:06 -0500
Message-ID: <4C603AA6.6030409@opengridcomputing.com>
References: <OFD9132F2D.FEEEA35D-ONC125777A.005D920E-C125777A.005DF132@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFD9132F2D.FEEEA35D-ONC125777A.005D920E-C125777A.005DF132-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I agree.  I think it should default to say 1024.  Further, I propose we 
make this a sysctl variable such that admins can tweak it as needed.



On 08/09/2010 12:06 PM, Bernard Metzler wrote:
> I think that could be relaxed.
> Running OFED (and softiwarp) on larger installations,
> we already had to set this to some KByte...
>
> Bernard.
>
> linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 08/09/2010 04:34:31 PM:
>
>    
>> Hey Sean,
>>
>> What is the logic behind limiting the listen backlog to 128?
>>
>> ------
>>
>> snipit from ucma.c:
>>
>> enum {
>>           UCMA_MAX_BACKLOG        = 128
>> };
>>
>>
>> snipit from ucma_listen():
>>
>>           ctx->backlog = cmd.backlog>  0&&  cmd.backlog<
>>      
> UCMA_MAX_BACKLOG ?
>    
>>                          cmd.backlog : UCMA_MAX_BACKLOG;
>> ------
>>
>>
>>
>> Thanks,
>>
>> Steve.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>      
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
