From: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Subject: Re: LID reconfiguration
Date: Mon, 9 Nov 2009 21:11:53 -1000 (HST)
Message-ID: <alpine.BSF.2.00.0911092110000.1226@desktop>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <4AF91138.7000809@Voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF91138.7000809-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 10 Nov 2009, Or Gerlitz wrote:

>> One more question;  I saw librdmacm which looked nice but it does not
>> support multi-path connections.  It would eliminate a lot of code if we
>> could use this
>
> what are your needs?

I would want a way to specify the alternate sockaddr with automatic 
failover between them.  Perhaps with some notification when a failover 
occured.

Jeff

>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
