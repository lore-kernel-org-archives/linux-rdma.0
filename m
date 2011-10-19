From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Wed, 19 Oct 2011 12:09:01 -0700
Message-ID: <1319051341.18132.53.camel@haakon2.linux-iscsi.org>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-orW-iK6WiGAt8Ovd1g64e628tcOh13D5xA67SfJ-W-Vg@mail.gmail.com>
	 <1319049335.18132.34.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-oJ38L7t=spKQPnEZxNOA6zoqG9DA3uw9q+eOTVvELRUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oJ38L7t=spKQPnEZxNOA6zoqG9DA3uw9q+eOTVvELRUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-10-19 at 20:47 +0200, Bart Van Assche wrote:
> On Wed, Oct 19, 2011 at 8:35 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > On Wed, 2011-10-19 at 19:56 +0200, Bart Van Assche wrote:
> > Not sure what you mean here.  Can you be more specific..?
> 
> I'm referring to this code:
> 
>                 sprintf(sport->port_guid, "0x0000000000000000%04x%04x%04x%04x",
>                                 be16_to_cpu(((__be16 *)&device->node_guid)[0]),
>                                 be16_to_cpu(((__be16 *)&device->node_guid)[1]),
>                                 be16_to_cpu(((__be16 *)&device->node_guid)[2]),
>                                 be16_to_cpu(((__be16
> *)&device->node_guid)[3]) + i);
> 
> There is no guarantee that the above formula will match the numbers
> assigned by the HCA manufacturer. Also, what will happen if for the
> last two digits the sum exceeds 2**16 ?
> 
> I would like to see the above code to be replaced by something like
> the following:
> 
>                snprintf(sport->port_guid, sizeof(sport->port_guid), "0x%016llx",
>                         be64_to_cpu(sport->gid.global.interface_id));
> 

Ok, but just to verify..  This change will still allow us to
differentiate between different struct srpt_port entries from the
perspective of configfs, correct..?  This was the reasoning behind the
'+ i' offset above, so that we can define an struct se_wwn endpoint for
each physical HCA port <-> struct srpt_port mapping..

Are sport->gid.global.interface_id going to be different for each struct
srpt_port..?

> Please note that in the InfiniBand Architecture Manual the words "port
> GUID" refer to a manufacturer-assigned EUI-64. So if you are going to
> use the name "port GUID" for an 128-bit quantity I'm afraid you are
> going to really confuse some people.
> 

Like I said before, the reason the 128 bit port name was used is to be
consistent with your original explict NodeACL code that uses the same
type of formatting..

Also, this is the same format (minus the fe00 prefix and colon
seperators) that it comes out of /sys/class/infiniband/*/ports/*/gids/0
that rtslib uses to determine which ports are available..  Obviously we
can add any type of sed formatting to wwn_from_files_filter in
ib_srpt.spec, but I still don't see why this should be different in
configfs from what /sys/class/infiniband/*/ports/*/gids/0 is already
doing..?

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
