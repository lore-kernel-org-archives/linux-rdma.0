From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/53] IB/qib: Add qib_7322_regs.h
Date: Tue, 24 Nov 2009 16:15:38 -0800
Message-ID: <1259108138.992.527.camel@chromite.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	 <20091119233732.30356.15053.stgit@chromite.mv.qlogic.com>
	 <adaeino36vw.fsf@roland-alpha.cisco.com>
	 <1259094504.992.517.camel@chromite.mv.qlogic.com>
	 <ada1vjn36bz.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada1vjn36bz.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2009-11-24 at 14:29 -0800, Roland Dreier wrote:
> > The file is automatically generated from the HW description
>  > files we use internally. It is obviously easier for us to
>  > leave it as is but if you feel strongly, we can filter the
>  > output to only contain the ones we use.
> 
> This one file is bigger than the whole amso1100 driver.  Which seems
> pretty excessive to me.  I mean, 9734 lines of register defines?!

OK. It looks like I can shrink the 3 register header files by about 50%.
There really are a lot of registers and most of them are used.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
