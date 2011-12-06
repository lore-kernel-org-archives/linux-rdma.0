From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: crash unloading mlx4 in 3.2-rc3
Date: Tue, 6 Dec 2011 10:19:13 -0800
Message-ID: <CAL1RGDWE1HkzWnrU0+Eke-Q2nmxc6jRaoB85s3hnEmEQs3xR6A@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373256536F5@ORSMSX102.amr.corp.intel.com>
 <CAL1RGDUkZHZqbLgOBE0PFK7xCV84f1Q-1gYH01p7UKiTYEPRBg@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A823732565377F@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732565377F-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 6, 2011 at 10:16 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> I don't know if this occurs on 3.1 without re-installing that kernel.

Yeah, no worries, since that patch works I think I understand the
problem.  And it was in 3.1 AFAICT too... came in with cfcde11c3d7a
("IB/mlx4: Use flow counters on IBoE ports") which was in 3.1.

I'll queue up my fix, thanks for testing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
