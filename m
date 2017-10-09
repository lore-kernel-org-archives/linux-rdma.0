From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Mon, 09 Oct 2017 13:12:04 -0400
Message-ID: <1507569124.46071.47.camel@redhat.com>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
         <20171006214243.11296-4-bart.vanassche@wdc.com>
         <20171008100317.GR25829@mtr-leonro.local>
         <1507568205.46071.46.camel@redhat.com> <1507568492.2674.11.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507568492.2674.11.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-09 at 17:01 +0000, Bart Van Assche wrote:
> On Mon, 2017-10-09 at 12:56 -0400, Doug Ledford wrote:
> > On Sun, 2017-10-08 at 13:03 +0300, Leon Romanovsky wrote:
> > > It is a little bit strange to ask from user to decide if his
> > > adapter
> > > supports SRQ or not.
> > > 
> > > It should be automatically.
> > 
> > I think Bart's intent is that the driver not use SRQ as the default
> > behavior even if the adapter supports it, so querying the adapter
> > for
> > support and enabling it if it exists would not achieve his desired
> > result.  This would then be used to override that behavior.  Is
> > that
> > correct Bart?
> 
> Hello Leon and Doug,
> 
> The changes realized by this patch are:
> - Instead of using SRQ as default, use non-SRQ mode as default.
> - If SRQ has been chosen as default, and if SRQ is not supported,
> fall back
>   to non-SRQ mode (see also the if (IS_ERR(sdev->srq)) ... code).
> 
> Please let me know if you have any further questions about this
> patch.

Nope, I'm good.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
