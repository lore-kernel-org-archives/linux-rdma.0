From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3] SA Busy Handling
Date: Mon, 06 Dec 2010 11:46:42 -0500
Message-ID: <4CFD1372.1090703@dev.mellanox.co.il>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31E@MNEXMB1.qlogic.org>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A20BC4@orsmsx501.amr.corp.intel.com>	<4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3B0@MNEXMB1.qlogic.org> <adamxomlefp.fsf@cisco.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A96DF3@orsmsx501.amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4C0@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4C0-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/6/2010 10:27 AM, Mike Heinz wrote:
>
> (In addition, none of the user-land tools use any kind of retries at all, but that's a different issue.)

Which user land tools are you referring to not using retries ?

Certain infiniband-diags do use the retry mechanism while others do not. 
It depends on the (nature of the) diag command. The simple manual 
query/response ones (using umad_send) do not use retry whereas others 
(more sophisticated ones like ibnetdiscover) do. In any case, if retries 
are appropriate and not currently implemented, it is simple to add them in.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
