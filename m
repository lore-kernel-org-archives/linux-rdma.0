From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Thu, 20 Oct 2011 09:49:46 -0700
Message-ID: <CAL1RGDUgWRzNzWVCngcc-BUMfhJJc2VMXH_aXs4dzjTy0oF_vg@mail.gmail.com>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
 <CAO+b5-orW-iK6WiGAt8Ovd1g64e628tcOh13D5xA67SfJ-W-Vg@mail.gmail.com>
 <1319049335.18132.34.camel@haakon2.linux-iscsi.org> <CAO+b5-oJ38L7t=spKQPnEZxNOA6zoqG9DA3uw9q+eOTVvELRUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oJ38L7t=spKQPnEZxNOA6zoqG9DA3uw9q+eOTVvELRUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 11:47 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> =
wrote:
> I'm referring to this code:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sprintf(sport->port_guid, "0x000000000=
0000000%04x%04x%04x%04x",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0be16_t=
o_cpu(((__be16 *)&device->node_guid)[0]),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0be16_t=
o_cpu(((__be16 *)&device->node_guid)[1]),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0be16_t=
o_cpu(((__be16 *)&device->node_guid)[2]),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0be16_t=
o_cpu(((__be16
> *)&device->node_guid)[3]) + i);
>
> There is no guarantee that the above formula will match the numbers
> assigned by the HCA manufacturer. Also, what will happen if for the
> last two digits the sum exceeds 2**16 ?
>
> I would like to see the above code to be replaced by something like
> the following:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 snprintf(sport->port_guid, sizeof(sport->=
port_guid), "0x%016llx",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0be64_to_cpu(sport->gid=
=2Eglobal.interface_id));
>
> Please note that in the InfiniBand Architecture Manual the words "por=
t
> GUID" refer to a manufacturer-assigned EUI-64. So if you are going to
> use the name "port GUID" for an 128-bit quantity I'm afraid you are
> going to really confuse some people.

I agree that this looks broken.  I think the most sensible thing to do
would be to have a port_gid (GID, not GUID) and use GID table
entry 0, rather than doing this math on node GUID (that I agree is
totally bogus).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
