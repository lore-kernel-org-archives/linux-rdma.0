From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH V2 0/3] New RAW_PACKET QP type
Date: Fri, 05 Nov 2010 10:20:35 -0500
Message-ID: <4CD420C3.1090803@opengridcomputing.com>
References: <4CD171F0.8020506@voltaire.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8308783@orsmsx501.amr.corp.intel.com> <4CD41D5D.9030103@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D606E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D606E-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/05/2010 10:15 AM, Hefty, Sean wrote:
>> Not that it matters much, but doesn't "FRAME" and "PACKET" mean the same
>> thing?
>>      
> I associate frame with L2 and packet with L3.  Since the user is expected to provide the L2 header, frame seems clearer than packet.  Then when someone wants to introduce the RAW_PACKET where the user only provides the L3 header, we still have something we can call it.
>
> Or maybe we call this a LAYER2 QP..?
>    

The linux PF_PACKET interface comes to mind.  It allows 
sending/receiving raw ethernet frames:

----
        Packet  sockets  are  used to receive or send raw packets at the 
device
        driver (OSI Layer 2) level. They allow the user to  implement  
protocol
        modules in user space on top of the physical layer.
-----


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
