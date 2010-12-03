From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4] SA Busy Handling
Date: Fri, 03 Dec 2010 14:43:02 -0500
Message-ID: <4CF94846.1090705@dev.mellanox.co.il>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3AF@MNEXMB1.qlogic.org> <4CF93D10.9070307@dev.mellanox.co.il> <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3E1@MNEXMB1.qlogic.org> <4CF93FD3.9070405@dev.mellanox.co.il> <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3E6@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3E6-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/3/2010 2:09 PM, Mike Heinz wrote:
> Well, the reason I added it was I thought it would be useful for diagnosing a troubled fabric to know that MADs were getting
> BUSY responses (which would indicate that they were at least reaching the SM); but I agree that under very bad conditions
> it could end up flooding the log.

Wouldn't that be the "normal" case in large clusters running all to all 
MPI jobs when BUSY is being used by the SA ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
