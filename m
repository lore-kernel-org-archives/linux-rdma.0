From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: CQ overrun with ib_send_bw
Date: Fri, 13 Aug 2010 12:21:37 -0700
Message-ID: <1281727297.2313.47.camel@chromite.mv.qlogic.com>
References: <4C659288.4030402@oracle.com>
	 <1281726396.2313.44.camel@chromite.mv.qlogic.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96887A2@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96887A2-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2010-08-13 at 12:14 -0700, Hefty, Sean wrote:
> > I know there is a bug with "ib_send_bw -b" (bi-directional)
> > since it doesn't create a CQ that is large enough for all the
> > posted sends *and* receives.  I have tried several times to get the
> > following patch applied but I never got a reply and nothing was
> > done.
> 
> Who's the maintainer of these tests?

I believe it is:

Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

git://git.openfabrics.org/~shamoya/perftest.git

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
