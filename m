From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: ucma question - backlog limit
Date: Mon, 09 Aug 2010 13:33:18 -0500
Message-ID: <4C6049EE.1020907@opengridcomputing.com>
References: <OFD9132F2D.FEEEA35D-ONC125777A.005D920E-C125777A.005DF132@ch.ibm.com> <4C603AA6.6030409@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954B79E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954B79E-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/09/2010 12:51 PM, Hefty, Sean wrote:
>> I agree.  I think it should default to say 1024.  Further, I propose we
>> make this a sysctl variable such that admins can tweak it as needed.
>>      
> The default is based on:
>
> #define SOMAXCONN       128
>
> I have no objection to making it adjustable.
>
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    


For TCP, a dropped SYN will cause the peer to retransmit the SYN, and 
the connection will be eventually established.  So a small backlog limit 
is probably ok for TCP.  With iWARP, the connect request is TCP payload 
an on established connection.  So the connection request is transmitted 
and acked at the TCP level by the time the connect request gets dropped 
in the ucma.  What finally happens is the peer times out (after many 
seconds typically) and kills the connection.  Further, a 32 node 256NP 
OpenMPI job will generate > 128 connect requests on some ranks.

So I think its reasonable to up default max value.   I'll post a patch 
to change the max and make it a sysctl variable as well.

Ok?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
