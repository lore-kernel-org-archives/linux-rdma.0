From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 5/9] ib_srpt: Fix sport->port_guid formatting code
Date: Wed, 26 Oct 2011 20:23:47 +0200
Message-ID: <CAO+b5-qjOT2rqeLn=DJi5ogk+KTV8_Fi0tYwj4gECtcSNNhHRQ@mail.gmail.com>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
 <1319434422-15354-6-git-send-email-nab@linux-iscsi.org> <CAO+b5-pcNWgt1uxT2gH6KvDhdkkP1hbBbYnt81f-gHVr_UhdBg@mail.gmail.com>
 <1319487952.17450.72.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319487952.17450.72.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 10:25 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> On Mon, 2011-10-24 at 21:57 +0200, Bart Van Assche wrote:
>> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
>> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 snprintf(sport->port_guid, sizeof(sp=
ort->port_guid),
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "0x0=
000000000000000%016llx",
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 be64=
_to_cpu(sport->gid.global.interface_id));
>>
>> If I interpret Roland's e-mail correctly Roland asked to use GID tab=
le
>> entry 0 (http://www.spinics.net/lists/linux-rdma/msg09751.html) ?
>>
>
> I'll defer to Roland on this, as the port->gid.global.interface_id yo=
u
> recommended does exactly what we need. =A0I'm happy to test another c=
ode
> snippet if you have one handy.

Something like this should generate GID 0 in ASCII format (not tested
in any way, and using separators will help to make the output easier
to read):

snprintf(sport->port_gid, sizeof(sport->port_gid),
            "0x%016llx%016llx",
             be64_to_cpu(sport->gid.global.subnet_prefix),
             be64_to_cpu(sport->gid.global.interface_id));

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
