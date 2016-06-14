From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Tue, 14 Jun 2016 18:31:53 +0300
Message-ID: <CAG9sBKOa2-HkwjSNRcSvxSfH8HQj-1ZQZNiF5cuBoUd+ZT15Tw@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com> <CAG9sBKPa0qQ4uuhoWLfZaXP9E+DnLrkOcU-2yNXbdZFQKppN8w@mail.gmail.com>
 <20160609144554.GA14212@phlsvsds.ph.intel.com> <20160609191608.GA5408@leon.nu>
 <20160609194758.GA9017@phlsvsds.ph.intel.com> <CAG9sBKN3+Yf7dUG0ORNFNG=j+AgR1eq5mvPQxx6jZEXEGRpk3w@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0617C2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0617C2-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Ipath, qib, hfi1, and rxe all need to do a fully software implementation of IB transport.  How could they possibly share any code?

I didn't say they couldn't. I only said that rdmavt is too tied to
hfi1 and qib (or to be more accurate to the way they were built). This
in fact matches the first goal of rdmavt: avoid code duplication
between hfi1 and qib.

BTW, true that all examples drivers you gave implement IB transport
but only RXE does RoCE.

Anyway, I don't rule out a common generic SW driver that connects to a
thin HW driver but we need to agree on the interfaces first.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
