From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4] SA Busy Handling
Date: Fri, 03 Dec 2010 14:06:59 -0500
Message-ID: <4CF93FD3.9070405@dev.mellanox.co.il>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3AF@MNEXMB1.qlogic.org> <4CF93D10.9070307@dev.mellanox.co.il> <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3E1@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3E1-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
