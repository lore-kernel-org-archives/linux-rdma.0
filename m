From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Wed, 21 Jul 2010 14:01:52 -0700
Message-ID: <AANLkTimaEocwvCNrqujSB33D2HQ3s1wUWLgJ7qjxfGDZ@mail.gmail.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAA57@orsmsx501.amr.corp.intel.com>
	<AANLkTikgvfJ85iCaYaG2My7A92FFXz0Fb9vFhVXtUYyx@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAC7A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAC7A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Upgrading 1.5.1 is the way to go for me.  I have other dependencies
tying me down to the CentOS kernel for the time being.  Hopefully any
patch to mainstream should apply fairly cleanly to 1.5.1.

-JE

On Wed, Jul 21, 2010 at 1:51 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> Timed out connections might be something that can be compensated for
>> in the app. =A0It is definitely preferable to a kernel panic. =A0Sti=
ll,
>> I'll work on making OFED-1.5.1 happy before playing around with
>> removing the ib_send_cm_mra() call.
>
> FYI - the possible issue I'm describing is in the upstream kernel, so=
 it would also be in 1.5.1.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
