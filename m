From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Wed, 21 Jul 2010 11:40:06 -0700
Message-ID: <AANLkTikgvfJ85iCaYaG2My7A92FFXz0Fb9vFhVXtUYyx@mail.gmail.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAA57@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAA57-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 21, 2010 at 11:13 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
> If this is what is happening, then removing the call to ib_send_cm_mr=
a() from cma_req_handler() should eliminate the crash. =A0The drawback =
is that connections may begin timing out under load, but it may be wort=
h trying. =A0I'll see if I can come up with a better fix.

Timed out connections might be something that can be compensated for
in the app.  It is definitely preferable to a kernel panic.  Still,
I'll work on making OFED-1.5.1 happy before playing around with
removing the ib_send_cm_mra() call.

-JE
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
