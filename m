From: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Tue, 30 Nov 2010 13:07:42 +0200
Message-ID: <AANLkTimzy1UTWXC_mS6QY03hNgo9jHOzrNPC=+xDxAiR@mail.gmail.com>
References: <20101115140829.GA20355@mtldesk30>
	<ada62vxl046.fsf@cisco.com>
	<20101116180732.GB29132@mtldesk30>
	<ada1v6klwil.fsf@cisco.com>
	<20101117090134.GA20369@mtldesk30>
	<adasjyzkfyw.fsf@cisco.com>
	<20101118065142.GB20369@mtldesk30>
	<AANLkTinN43YgQW3ftbng-4f2NiNe9_oXPVCX5LPzh7uG@mail.gmail.com>
	<4CEE200B.70106@Voltaire.com>
	<1290675387.4050.51.camel@alst60.voltaire.com>
	<AANLkTikWrQRcA62bkM=1zWQuyH6nABSvqnbAeaAjfgcP@mail.gmail.com>
	<adafwukf2yy.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafwukf2yy.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 29, 2010 at 7:34 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
> =C2=A0> I afraid that you =C2=A0overloaded with dozen of e-mails and =
missed this
> =C2=A0> question, so I'd ask you again. Is there any reason why this
> =C2=A0> members_count patch cannot be applied?
>
> No, it is fine. =C2=A0I will merge it for 2.6.38. =C2=A0However this =
long thread
> should (I hope) show how the changelog could be improved -- if the
> original patch had said why the patch was needed then we could have
> avoided all this long discussion.
>
> =C2=A0- R.

Excellent news, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
