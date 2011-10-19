From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Wed, 19 Oct 2011 20:47:19 +0200
Message-ID: <CAO+b5-oJ38L7t=spKQPnEZxNOA6zoqG9DA3uw9q+eOTVvELRUA@mail.gmail.com>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
 <CAO+b5-orW-iK6WiGAt8Ovd1g64e628tcOh13D5xA67SfJ-W-Vg@mail.gmail.com> <1319049335.18132.34.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319049335.18132.34.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 8:35 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> On Wed, 2011-10-19 at 19:56 +0200, Bart Van Assche wrote:
> Not sure what you mean here. =A0Can you be more specific..?

I'm referring to this code:

                sprintf(sport->port_guid, "0x0000000000000000%04x%04x%0=
4x%04x",
                                be16_to_cpu(((__be16 *)&device->node_gu=
id)[0]),
                                be16_to_cpu(((__be16 *)&device->node_gu=
id)[1]),
                                be16_to_cpu(((__be16 *)&device->node_gu=
id)[2]),
                                be16_to_cpu(((__be16
*)&device->node_guid)[3]) + i);

There is no guarantee that the above formula will match the numbers
assigned by the HCA manufacturer. Also, what will happen if for the
last two digits the sum exceeds 2**16 ?

I would like to see the above code to be replaced by something like
the following:

               snprintf(sport->port_guid, sizeof(sport->port_guid), "0x=
%016llx",
                        be64_to_cpu(sport->gid.global.interface_id));

Please note that in the InfiniBand Architecture Manual the words "port
GUID" refer to a manufacturer-assigned EUI-64. So if you are going to
use the name "port GUID" for an 128-bit quantity I'm afraid you are
going to really confuse some people.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
