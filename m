From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Wed, 6 Oct 2010 12:57:27 -0700
Message-ID: <AANLkTik0gwzoFx9fi8WU3qwN9zOYKQQJtfPZVNH2yguA@mail.gmail.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAA57@orsmsx501.amr.corp.intel.com>
	<AANLkTimVvGGW6e=f-gL_Xz1vV4azHuST=6wy8Eba1G35@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B532D218@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B532D218-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Good news!  I'll apply this and test right away.

-JE

On Wed, Oct 6, 2010 at 12:04 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> I tried the suggestion of removing the call to ib_send_cm_mra().
>> Unfortunately, doing this wedges the stack 100% of the time. =A0Sinc=
e
>> the original post, I've upgraded to CentOS-5.5 with OFED-1.5.1. =A0T=
he
>> NULL pointer reference now occurs far less frequently but still with
>> some regularity. =A0I have full memory dumps from a crashed kernel, =
but
>> don't really know how to debug it.
>
> upstream commit 50a025c69ee749d822c301f9bf63dee13c113680 should corre=
ct this issue. =A0I'm not sure when OFED will pick up this patch.
>
> - Sean
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
