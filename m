From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs] Add support for TX/RX checksum offload
Date: Thu, 10 Sep 2015 10:10:21 +0300
Message-ID: <55F12CDD.7000408@mellanox.com>
References: <1439826618-3015-1-git-send-email-bodong@mellanox.com>
 <55EA2C3D.2080904@redhat.com>
 <CAJ3xEMheigQt29mmb50PKHsXfx8pXMex+3bgJeobF0JBAjHsNQ@mail.gmail.com>
 <55F04E2E.5050100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F04E2E.5050100-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/9/2015 6:20 PM, Doug Ledford wrote:
> On 09/05/2015 03:59 PM, Or Gerlitz wrote:
>> --> they must not put any
>> additional bits on the wire
> Maybe.  For base level interop, sure, but for enhanced service in a homogeneous environment, not necessarily true.
>
>> --> RC isn't an option
> Not following here Or.  The IPoIB connected mode packet is 4 byte IPoIB
> Header followed by whatever header the TCP stack put on the packet
> (likely either IPv4 or IPv6).  The same ipoib_hard_header function is
> used for both CM and UD connections, the same ipoib_start_xmit() is used
> for both CM and UD connections, and we just hand off to the appropriate
> send routine when we have our neighbor lookup complete.  Why would you
> need new bits on the wire to do a checksum on an RC send and not for a UD send?

I didn't say that, I said (again) the offload engines will use just 
plain UD along the IPoIB RFC, b/c each IPoIB implementation would 
support that. It's true that an offload can use connected mode (CM) and 
fall back to UD if the other end don't support CM.

To make things concrete, exactly nothing in the libibverbs patch is made 
such it would work just for UD and RAW PACKET qps, except few TEXT 
comments and man page line. In other words, if there is HW vendor that 
supports checksum generation/validation on RC QPs too - the same API 
would just work.

It's pretty easy to add one line of check for the vendor send function 
such that it returns error if checksum generation isn't supported for 
the given QP type, and in that respect, before going and saying this 
submission is crappy, you could have just provided this reviewer comment 
"remove the assumption on QP types, make sure in libmlx4 you return 
error for non UD/RAW qps" and (see next)



>
>> , so for IPoIB we
>> just need an IPoIB UD QP in user space, and for Ethernet RAW PACKET
>> QP. This device capability is there  ~10y for IB UD and we just
>> naturally extend it to Eth RAW. If/when a vendor comes up with
>> supporting csum for RC, we can add another dev cap and say the well
>> established API applies on them too, with just a slight modification
>> to man pages and such, makes sense?
> So if we ever support RC, then any actual users of this API will have
> hardcoded which types of QPs are supported into their apps and they will
> *all* have to go modify their source code to re-hardcode the types into
> their app and recompile.
>
> Alternatively, we write a reasonable API.  One where the types of QPs
> are not set in stone, we tell users to query the API to determine if any
> given QP supports IP CSUM offloads, and then if we add more QP types in
> the future, the apps just automatically work even on the different QP
> types (assuming they used those QP types at all) because it was written
> to an API that allowed for it.
>
> Face it Or, the API in this patchset is crap.  I totally get why you are
> fighting for it so hard.  You already spelled it out: "This device
> capability is there  ~10y for IB UD and we just naturally extend it to
> Eth RAW".  I can read between the lines.  You have users of the API,
> probably some internal and some external, and if I go demanding a proper
> API, all of these people have to recode their apps to the new API, and
> you'd like to avoid that if possible.  However, if I don't, and then RC
> support is added, then they have to recode their apps anyway.  Wouldn't
> it be best to just do it right and get it over with?

(continuing) "show me a plan, how applications can determine the support 
matrix for QPs types and checksum offloads" -- e.g one can enhance the 
extended query device verbs to report that and such.

Indeed there are bunch of UD and RAW based applications out there which 
make perfect use of this API and I don't think we need to gate the 
libibverbs support with that extended query kernel patch.

Why not move forward with the vendor library flow to act along your 
request, removal of assumption from man pages and a kernel patch, which 
on top of, we can add another libibverbs patch that allows apps to query?

I find this approach practical on the one hand, and with clear plan to 
make it fully robust on the other hand.



>
> So, here's the API I'm proposing:
>
> - Add ibv_query_qp_ex
> - In new ibv_query_qp_ex struct, extend the ibv_qp_caps struct to add a
> flags element
> - Define a flag for IP_CSUM_SUPPORTED
> - Define IP_CSUM flag for send operations
> - Define the API so that IP_CSUM is ignored on all sends if the QP
> doesn't support IP_CSUM and only checked on QPs that support it.  This
> way other QP types don't suffer a penalty on send to check this and
> return EINVAL if its set
> - Define the return flags in the wc struct so we can signal that a CSUM
> was performed and succeeded
>
> A user app would then basically follow this flow:
>
> ibv_create_qp()
> ibv_query_qp()
>    check for IP CSUM and cache result
> ibv_post_send()
>    set IP_CSUM if QP supports it
>
> ibv_poll_cq()
>    if qp supports IP_CSUM, check CSUM result in wc
>
> That's what I would like to see for these changes.
>
basically OK, expect that the support matrix for QP types is a property 
of the device, e.g in a similar manner we have for ODP, right? and hence 
the plan I suggested above.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
