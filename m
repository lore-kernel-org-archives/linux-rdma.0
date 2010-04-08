From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: allow HCAs to create IB port sysfs files
Date: Thu, 08 Apr 2010 13:51:29 -0700
Message-ID: <adaeiipwtv2.fsf@roland-alpha.cisco.com>
References: <1258486848.992.407.camel@chromite.mv.qlogic.com>
	<adamxxdwtys.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxxdwtys.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org> (Roland Dreier's message
	of "Thu, 08 Apr 2010 13:49:15 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Rather than have the device driver call a new function that then calls
 > it back, how about if we just add a parameter to the
 > ib_register_device() call that is the callback to add the sysfs stuff?
 > This would let us avoid the race where the device is registered but not
 > all the sysfs stuff is created yet.

And as an improvement, maybe someday we could convert the existing
per-device driver-specific sysfs stuff to a similar approach.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
