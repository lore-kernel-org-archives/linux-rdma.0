From: Reeted <reeted-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 05 Sep 2012 19:50:16 +0200
Message-ID: <504790D8.7010307@shiftmail.org>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <FFD82983-4A73-4A52-B6BE-C63DA16A507C-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/29/12 21:35, Atchley, Scott wrote:
> Hi all,
>
> I am benchmarking a sockets based application and I want a sanity check on IPoIB performance expectations when using connected mode (65520 MTU).....

I have read that with newer cards the datagram (unconnected) mode is 
faster at IPoIB than connected mode. Do you want to check?

What benchmark program are you using?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
