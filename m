From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Make compilation with BUG=n proceed
Date: Fri, 18 Nov 2011 08:52:18 +0100
Message-ID: <CAO+b5-oakXVhbxNMOh2LZ7bLKnuTz3B7Q-KbHF_XKjLjNnqueg@mail.gmail.com>
References: <201111172025.44546.bvanassche@acm.org>
	<CAL1RGDV+vgQ7J1VtyeGi-eNw00Bxe35xRJgBu0X4-5PAG4q-nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV+vgQ7J1VtyeGi-eNw00Bxe35xRJgBu0X4-5PAG4q-nQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2011 at 12:45 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:
> On Thu, Nov 17, 2011 at 11:25 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org=
> wrote:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("%s[%d]: unexpected opcode %d",=
 __func__, __LINE__,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0opcode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(true);
>
> Not a big deal, but I guess this could just be
>
> =A0 =A0 =A0 =A0WARN(1, "unexpected opcode %d", opcode);

As far as I can see with CONFIG_BUG=3Dn WARN() is defined as follows:

#define WARN(condition, format...) ({                                  =
 \
        int __ret_warn_on =3D !!(condition);                           =
   \
        unlikely(__ret_warn_on);                                       =
 \
})

So the changing pr_err(); WARN_ON(true); into WARN(1, ...) would cause
no error message to be printed if CONFIG_BUG=3Dn. Is that the way kerne=
l
code should behave if CONFIG_BUG=3Dn ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
