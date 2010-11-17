From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] ibacm: check for special handling of loopback
 requests
Date: Wed, 17 Nov 2010 09:11:34 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B867EF9F@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE@orsmsx501.amr.corp.intel.com>
	 <1289953873.2365.179.camel@chromite.mv.qlogic.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616939@orsmsx501.amr.corp.intel.com>
	 <1289956127.2365.190.camel@chromite.mv.qlogic.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616977@orsmsx501.amr.corp.intel.com>
 <1289957852.9693.7.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289957852.9693.7.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I guess what I'm objecting to is hard coding mlx4.
> I was trying to think of a way that would allow other HCAs
> to support the block loopback option in the future.
> It looks like ipoib sets IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK
> for kernel QPs but this isn't defined in libibverbs yet.

If there's a per QP flag for kernel users, I don't understand why it was automatically disabled HCA wide.

> It seems reasonable to add that feature some time in the future
> and change ibacm to use it.
> 
> In the mean time, I guess I don't see an alternative to your patch.

The best alternative I can think of is to add a 'loopback' configuration option to acm.  The benefits of being able to block loopback multicast traffic may be greater than anything gained by not doing so.

I'll make this change and just use a default value that does not require loopback multicast.  At some point, when libibverbs exposes this capability, acm can take advantage of it.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
