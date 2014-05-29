From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v5 00/24] Series short description
Date: Thu, 29 May 2014 13:31:26 -0500
Message-ID: <007001cf7b6c$3375b430$9a611c90$@opengridcomputing.com>
References: <20140528142521.23214.39655.stgit@manet.1015granger.net> <005501cf7b5f$4e4359a0$eaca0ce0$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE01148@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD3FE01148-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Devesh Sharma' <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Note I just today published a new single patch for the server refactor change.  This is V3 of the patch.  It has a critical bug fix from the V2 version you're using.  Please use the V3 patch going forward.  The bug only manifested when using NFSv4 and certain tests though...

See: https://patchwork.kernel.org/patch/4266551/

Steve 

> -----Original Message-----
> From: Devesh Sharma [mailto:Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org]
> Sent: Thursday, May 29, 2014 1:28 PM
> To: Steve Wise; 'Chuck Lever'; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
> Subject: RE: [PATCH v5 00/24] Series short description
> 
> With Emulex device this series is tested I run iozone and cthon04. No regressions, cable pull
> test is pending.
> I included Steve's (the 3 patches which he posted recently) server side changes as well.
> 
> -Regrds
>  Devesh
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> > Sent: Thursday, May 29, 2014 10:29 PM
> > To: 'Chuck Lever'; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
> > Subject: RE: [PATCH v5 00/24] Series short description
> >
> > I tested this series over cxgb4 and mlx4, running cthon04, fio read/rand-rw,
> > and xfstests, and over mthca cthon04.  No regressions.
> >
> > Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> > body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
