From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3.1] IB/umad: Fix error handling
Date: Tue, 20 May 2014 13:39:51 +0200
Message-ID: <1400585991.4198.1.camel@localhost.localdomain>
References: <53708666.6060209@acm.org> <537086BA.3020807@acm.org>
	 <1399889890.3017.6.camel@localhost.localdomain> <5375F094.30809@acm.org>
	 <5375F0CD.5080809@acm.org>
	 <1400574821-9562-1-git-send-email-ydroneaud@opteya.com>
	 <537B3BBE.4040202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537B3BBE.4040202-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 20 mai 2014 =C3=A0 13:25 +0200, Bart Van Assche a =C3=A9crit :
> On 05/20/14 10:33, Yann Droneaud wrote:
> > Please find a slightly modified version of your patch to simplify
> > a bit the error paths (no backward goto's) and to reduces the amoun=
t
> > of lines touched.
> >=20
> > I wasn't able to explain it clearly enough in the previous patch re=
view,
> > so I've made the changes directly in the file and propose the modif=
ied
> > patch for you to review.
> >=20
> > As it's only suggestion, feel free to integrate the changes in your
> > patch or discard them.
>=20
> Hello Yann,
>=20
> It seems like our opinions about backward goto's are different :-) I
> thought these are common at the end of error handling code in the Lin=
ux
> kernel. Anyway, what matters to me is that a fix gets upstream, not
> which fix. But please do not expect me to spend more time testing a
> patch that has been reworked only because of the coding style aspects
> mentioned in your e-mail.
>=20

Having a shorter diff might help to get the patch applied upstream.
YMMV.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
