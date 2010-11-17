From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] ibacm: check for special handling of loopback
	requests
Date: Wed, 17 Nov 2010 07:25:14 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616B1F@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE@orsmsx501.amr.corp.intel.com>
	<1289953873.2365.179.camel@chromite.mv.qlogic.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616939@orsmsx501.amr.corp.intel.com>
 <4CE39429.6030202@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE39429.6030202-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vainman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> To be precise, the bit avoids recieving multicast packets by the QP that
> --sent-- it, not by other QPs subscribed to that group on the same
> node/hca, the patch change-log even states that "Inter QP multicast
> packets on the relevant HCA will still be delivered". You can test that
> with two mckey processes running on a node which has the patch active.

yes - I confirmed that using mckey.

> So with acm the functionality you need is for the same QP to receive the
> packets it sent?

yes - the code treats all destination addresses the same.  (This is useful for testing and to populate remote caches.)  My patch works around the issue, but long term, I agree with Ralph.  User space needs some other way to determine if this is needed.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
