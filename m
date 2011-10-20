From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Thu, 20 Oct 2011 08:24:44 +0200
Message-ID: <CAO+b5-quJkZdSsAmL1gZz1V6mwB3Q8abOu_Q+96MxO89bhg6EA@mail.gmail.com>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
 <CAO+b5-orW-iK6WiGAt8Ovd1g64e628tcOh13D5xA67SfJ-W-Vg@mail.gmail.com>
 <1319049335.18132.34.camel@haakon2.linux-iscsi.org> <CAO+b5-oJ38L7t=spKQPnEZxNOA6zoqG9DA3uw9q+eOTVvELRUA@mail.gmail.com>
 <1319051341.18132.53.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319051341.18132.53.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 9:09 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> Ok, but just to verify.. =A0This change will still allow us to
> differentiate between different struct srpt_port entries from the
> perspective of configfs, correct..?

Yes.

> Also, this is the same format (minus the fe00 prefix and colon
> seperators) that it comes out of /sys/class/infiniband/*/ports/*/gids=
/0
> that rtslib uses to determine which ports are available.. =A0Obviousl=
y we
> can add any type of sed formatting to wwn_from_files_filter in
> ib_srpt.spec, but I still don't see why this should be different in
> configfs from what /sys/class/infiniband/*/ports/*/gids/0 is already
> doing..?

If you have a look at the output of the command ibv_devices -v
(maintained by Roland), you will see that in the output of that
command ports are identified by a 64-bit GUID.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
