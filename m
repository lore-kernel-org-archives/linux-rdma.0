From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: Fix crash in request handlers
Date: Mon, 14 Mar 2011 21:22:58 -0700
Message-ID: <AANLkTi=jDsCFEsfhT0Vwq2APQKmF5ZYFFV91=rEMUe=+@mail.gmail.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C@orsmsx501.amr.corp.intel.com>
 <AANLkTinE3hzALRn9=5QOHiZCOGJU8RYm77c2vb_qzW5P@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB3A08D@orsmsx501.amr.corp.intel.com> <AANLkTi=O+An6XSFR-jWnYjQzsED63=DRnTBGF=itgAR3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=O+An6XSFR-jWnYjQzsED63=DRnTBGF=itgAR3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 14, 2011 at 7:27 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> Doesn't that mean unprivileged userspace could trigger a use-after-fr=
ee
> in the kernel? =A0(and it might be malicious code, not buggy userspac=
e)

=46rom reading the code a bit, I guess ucma is OK in this area.  I do s=
ee
what seems like an exploitable race in ucma_create_id():

 - one thread create an id with an invalid userspace pointer
   (so the copy_to_user in ucma_create_id returns -EFAULT
   and calls rdma_destroy_id before idr_remove)
 - another thread guess the id that is going to be returned and
   call ucma_destroy_id()

if the second thread hits the window where the cm_id is
destroyed but the ctx is still in the idr, it can trigger a double free=
=2E

But this is a completely different bug.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
