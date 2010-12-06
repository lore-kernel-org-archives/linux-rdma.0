From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V3] SA Busy Handling
Date: Mon, 6 Dec 2010 10:50:47 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4E4@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31E@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A20BC4@orsmsx501.amr.corp.intel.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3B0@MNEXMB1.qlogic.org>
 <adamxomlefp.fsf@cisco.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A96DF3@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4C0@MNEXMB1.qlogic.org>
 <4CFD1372.1090703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFD1372.1090703-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looking at the management source code, I don't see a single instance of umad_send() where retries is set to a non-zero value except saquery, which I think used to be zero as well.

-----Original Message-----
From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] 
Sent: Monday, December 06, 2010 11:47 AM
To: Mike Heinz
Cc: Hefty, Sean; Roland Dreier; Todd Rimmer; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH V3] SA Busy Handling

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
