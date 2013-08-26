From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Handling incoming RDMA CM connections when there is more than one
 IB HCA in a system
Date: Mon, 26 Aug 2013 12:17:11 -0700
Message-ID: <CACyXjPxyU6LO_31EVf9D_CwsX-aohEh_UbAQx97jJFh6PaLfgw@mail.gmail.com>
References: <CACyXjPzPJ=cZ1WkjYJ_o_4uLE50mn-TX93Answz7nw2rn619-Q@mail.gmail.com>
	<20130826174844.GD12296@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130826174844.GD12296-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 26, 2013 at 10:48 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Aug 25, 2013 at 04:41:59AM -0700, Richard Sharpe wrote:

[Deletia to be addressed later]

> From what I read about the SMB protocol it looks completely valid to
> bypass the TCP first stage and go directly to RDMA. Or go from TCP to
> TCP, or RDMA to TCP, or whatever.

Microsoft tells me that they never do an RDMA-only connection. It is
always TCP first then RDMA.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
