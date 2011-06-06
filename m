From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [RFC] [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Mon, 6 Jun 2011 11:07:06 -0700
Message-ID: <BANLkTikvz7grX-7qaovTpgDb+0B1zwQPJg@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373012B5B@ORSMSX101.amr.corp.intel.com>
 <4DED00A6.4010201@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DED00A6.4010201-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 6, 2011 at 9:30 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org=
> wrote:
> Will this mechanism allow an RDMA provider driver to export a new qp-=
related
> operation for use internally bit the supporting provider library? =A0=
IE Not
> exposes to the RDMA application, but an internal interface between th=
e
> library and driver. =A0I have need for this with the T4 driver.

Not sure I follow this... how specifically would this work?  Why does t=
he
userspace library need help to talk to the kernel driver?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
