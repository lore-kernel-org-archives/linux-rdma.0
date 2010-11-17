From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/3] ibacm: check for special handling of loopback	requests
Date: Wed, 17 Nov 2010 10:36:57 +0200
Message-ID: <4CE39429.6030202@voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE@orsmsx501.amr.corp.intel.com>	<1289953873.2365.179.camel@chromite.mv.qlogic.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616939@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616939-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vainman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> One could argue that this change is reasonable regardless of the OFED kernel patch.  It avoids sending multicast traffic when the destination is local.  The main drawback beyond the extra code is that a node can't send a multicast message to itself, with the intent that remote listeners will be able to cache the address data.
Sean,

To be precise, the bit avoids recieving multicast packets by the QP that 
--sent-- it, not by other QPs subscribed to that group on the same 
node/hca, the patch change-log even states that "Inter QP multicast 
packets on the relevant HCA will still be delivered". You can test that 
with two mckey processes running on a node which has the patch active. 
So with acm the functionality you need is for the same QP to receive the 
packets it sent?

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
