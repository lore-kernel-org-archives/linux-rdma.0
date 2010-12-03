From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3] SA Busy Handling
Date: Fri, 3 Dec 2010 10:57:18 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A20DC5@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31E@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A20BC4@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3B0@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3B0-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Not at this time, because the last time we discussed this, several
> individuals insisted that we provide a user space mechanism for selecting
> it.
> 
> If we don't want to use this, then we should just go all the way back to
> the original patch I submitted in the spring. That version does not have
> the user space hook or the module parameter.

This is more of what I was suggesting.  Long term, I believe that we want more policy in the mad layer.  It should limit the number of outstanding queries against the SA, adjust timeouts based on calculated values, determine how many times to retry based on a total timeout provided by the user, etc.  If we can get agreement on this direction, then handling busy responses would be part of this.  Until the infrastructure is in place to do this, simply dropping busy responses for now is acceptable to me.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
