From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 3/3] ibacm: check for special handling of loopback
 requests
Date: Tue, 16 Nov 2010 17:08:47 -0800
Message-ID: <1289956127.2365.190.camel@chromite.mv.qlogic.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE@orsmsx501.amr.corp.intel.com>
	 <1289953873.2365.179.camel@chromite.mv.qlogic.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616939@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616939-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-11-16 at 16:54 -0800, Hefty, Sean wrote:
> > This seems to introduce an HCA specific dependency.
> 
> yep :(  This is why ACM just handles it rather than exposing any sort of option to a user.
> 
> > Isn't ibacm supposed to work with different HCAs?
> 
> It does and still will, even in a mixed environment.
> 
> One could argue that this change is reasonable regardless of the OFED kernel patch.  It avoids sending multicast traffic when the destination is local.  The main drawback beyond the extra code is that a node can't send a multicast message to itself, with the intent that remote listeners will be able to cache the address data.
> 
> - Sean

Is there a way to make it HCA neutral?
Would it require extending the libibverbs API to set the option?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
