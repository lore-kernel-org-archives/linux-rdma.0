From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/2] Adding support for RoCE V2 specification
Date: Tue, 2 Dec 2014 08:47:06 +0200
Message-ID: <CAG9sBKNt0sKixnKj_8ANc3ef4kwEGgrH_5WcCWr3-VfSSf8Ldw@mail.gmail.com>
References: <51dd1341-8216-494f-9574-120634cad8e7@CMEXHTCAS1.ad.emulex.com>
	<CAG9sBKPGbHc49rLx+z3N+bgzMakFks2ihvgAkZpmjUz==2ZYDQ@mail.gmail.com>
	<7F44EA5110810A40B7DAFB605C41975D312F40F4@CMEXMB1.ad.emulex.com>
	<CAG9sBKMDLNnO1Q8QRNNq9cAnTdEL3DXPhpUqwKqFaN1aMGyomw@mail.gmail.com>
	<7F44EA5110810A40B7DAFB605C41975D312F4C7C@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F44EA5110810A40B7DAFB605C41975D312F4C7C-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 2, 2014 at 7:35 AM, Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> HI Moni,
>         Thank you for your comments , please find my response inline.
>
>
>> > The overarching goal behind this patch is to keep RDMA-CM as the
>> > central entity that decides the protocol (ROCEV2 /ROCEV1) and hides all the
>> address resolution details from applications.
>> I agree but with one comment. RDMA-CM, although preferred,  is not
>> mandatory to establish a connection. The solution needs to take care also for
>> apps that don't use RDMA-CM
>
> Agreed and this patch takes care of that as well thanks to the solution that was put in place
> for IP-based GIDs anyway in `modify_qp` effectively by means of the ib_resolve_l2_attrs().
>
>>
>> > This  is just a continuation of the existing RDMA-CM design philosophy
>> > for IP Based GIDs that lets applications operate over any form of RDMA
>> Service in a completely transparent way without any changes to the
>> applications themselves.
>> >
>> > Protocol Resolution(RoCEV2 or V1) must be done even before we send out
>> > the 1st connection request packet, the corresponding MAD pkt must be V2
>> for a destination that is behind  a router, correct?
>> > I am not sure we want to try sending out RoCEv2 connection requests first
>> and if that fails ,then fallback/retry with RoCEv1 request.
>> I agree but when you send the first packet (request or response) you know
>> the SGID index to be used. Knowing that and assuming you chose the SGID
>> index correctly there is no need to guess.
>> A suggestion for choosing the SGID index is:
>> 1. First, populate GID table with GIDs matching the IP address list of the
>> corresponding net devices. Each GID will appear twice, one for
>> RoCEv1 and one for RoCEv2.
>> 2. When connection is being established RDMA-CM will choose one of the
>> 2 matching indices based on a preferred protocol attribute for the rmda_id
>> (new attr.) 3. Proffered protocol is
>>      a) global for the node/fabric based on the administrator settings
>>      b) can be changed by applications that want to override the default
>> (requires extra API)
>
> Agree to point 1 which is what we were thinking of doing as well as part of the 'override' option.
> Still feel that the 'default' protocol resolution should be based on help from the IP/Networking stack
> as that would straight away enable existing applications and majority of use-case scenarios that use RDMA-CM to seamlessly
> work without any change for RoCE V2.
> What this means is now RDMA-CM will choose one of the 2 matching GID indices based on help from the IP stack.
>
> For this to happen , the 'gid_cache' structure will have to undergo a change to now incorporate a new 'gid_type' field.
> Accordingly the helper functions that find a cached gid entry - ib_find_cached_gid() will also undergo a change to take into account this new field.
>
> I plan to resubmit the patch series making the following changes
> a) Populating GID table with 2 entries per IP address
> b) Changes to the GID cache structure along with it's helper functions
> c) Make sure that RDMA-CM selects/finds the corresponding GID once a network type is chosen based on help from the IP stack.
>
>
> The only thing missing is the ability for end-nodes connected locally inside same subnet to communicate using V2 and that
> could be provided as an 'override' option using the 'preferred protocol' attribute setting on a system-wide basis or on an application basis
> as you have proposed.
> This I propose as an additional patch after the above patch goes in first.
>
> Does this sound like a plan ?
>
> Thanks
> Som
>
Hi Som
Generally, I agree with the changes you suggested. To summarize (and
make sure I got it right) your plan for V2 is to:

1. Associate gid_index with RoCE type in GID table and GID cache.
Requires helper functions to search for gid_index according to GID
value and type
2. Move the code that monitors IP address changes to populate GID
table from device driver to IB/core. Requires each RoCE device driver
to implement add_gid_entry/rem_gid_entry functions
3. Remove the RoCE type from address structure (e.g. ib_ah_attr).
Leave it only in rdma_addr to keep the hint from the IP stack
4. Choose sgid_index (from all matching entries) in RDMA-CM based on
hint from IP stack, user preference and admin policy

If so, I guess that we have a plan.

Thanks
Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
