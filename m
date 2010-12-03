From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V4] SA Busy Handling
Date: Fri, 3 Dec 2010 13:09:48 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3E6@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3AF@MNEXMB1.qlogic.org>
 <4CF93D10.9070307@dev.mellanox.co.il>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3E1@MNEXMB1.qlogic.org>
 <4CF93FD3.9070405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF93FD3.9070405-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Well, the reason I added it was I thought it would be useful for diagnosing a troubled fabric to know that MADs were getting BUSY responses (which would indicate that they were at least reaching the SM); but I agree that under very bad conditions it could end up flooding the log.

-----Original Message-----
From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] 
Sent: Friday, December 03, 2010 2:07 PM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH V4] SA Busy Handling

On 12/3/2010 2:00 PM, Mike Heinz wrote:
> Hal said:
>> >  Is this really needed ? Won't this spam the log ?
>> >
>> >  -- Hal
> Should we reduce it to debug?

Why is it needed at all ?

> Sean has said that we should go back to the version that has no module parameter or external hooks. Should we go with that?
> Such a version would simply drop BUSY responses, except for the trap repress case.

I think that's fine with me but want to see/review the actual patch for 
this.

-- Hal


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
