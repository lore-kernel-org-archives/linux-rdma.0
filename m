From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: link width question / opensm
Date: Thu, 25 Feb 2010 09:45:04 -0500
Message-ID: <f0e08f231002250645u1a728u60e6269921affac8@mail.gmail.com>
References: <20100225063905.GA4690@X300.wifi.conference.usenix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100225063905.GA4690-XsFsJpinAmpgDlDR3U7vgBiktiNgz6Q3On3nfQqNrRM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dries Kimpe <dkimpe-zhzY/AYb9nBYTrM/R70HSA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 25, 2010 at 1:39 AM, Dries Kimpe <dkimpe-zhzY/AYb9nBYTrM/R70HSA@public.gmane.org> wrote=
:
>
> =C2=A0Hi,
>
> for various reasons I'm trying to force a specific setting for
> the link speed and link width of an IB link.
>
> I know opensm has an option to force link speed to a certain value. =C2=
=A0I
> modified OpenSM (3.3.5) and added a similar option for link width
> (link_width_enabled field of port info struct).
>
> Reading the IB spec, link_width_enabled is marked as read-write, just=
 as
> the link speed field.
>
> However, it doesn't seem to work. I verified that link_width_enabled =
is
> correctly set.

The link won't renegotiate automatically. The link needs to be reset
after updating the speed/width enabled values. Was that done ?

> My questions:
>
> - Is support for changing link width dependent on driver version
> or specific IB hardware?
>
> - Is there another way to get what I want (control over link width+sp=
eed)?

The latest ibportstate can do this.

-- Hal


> =C2=A0Thanks,
> =C2=A0Dries
>
> PS. Please cc me. I'm not on the list.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
