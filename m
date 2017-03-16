From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] Registering non-contiguous memory
Date: Thu, 16 Mar 2017 13:32:31 +0000
Message-ID: <VI1PR05MB1278C01A5BCF968C40E0F2FFB9260@VI1PR05MB1278.eurprd05.prod.outlook.com>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <f40f326d-e76b-0471-dc7d-e81b7d07db78@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f40f326d-e76b-0471-dc7d-e81b7d07db78-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Tom Talpey [mailto:tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, February 28, 2017 2:31 PM
> To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [RFC] Registering non-contiguous memory
>=20
> On 2/5/2017 11:46 AM, Alex Margolin wrote:
> > Introduction
> > ----------------------------------------------------------------------
> > ---------- Numerous applications communicate buffers with a
> > non-contiguous memory layout.
> > For example, HPC applications often work on a matrix, and require
> sending a row or a column. Sending non-contiguous data requires
> specifying all the buffers being transferred, along with potentially the
> same amount of memory keys (should the buffers be registered under
> different memory regions). Extended memory windows are proposed to
> address complex memory layouts, and allow the user to send and receive
> them in an efficient manner.
> > This RFC proposes an extension for memory windows for the use of non-
> contiguous buffers.
> >
> ...
> > The layout is "switched on" as a bind parameter with an additional
> access flag, which is somewhat of a misuse, but since struct
> ibv_mw_bind_info is not easily expandable in the functions using it, the
> alternative is an additional verb.
> >
> > We do propose adding a verb for the allocation of such memory windows,
> which is required since the original memory window allocation function
> is not easily extendable, and we require an additional parameter to
> determine the amount of resources to allocate towards it (descriptors).
> In addition, this number is available for existing windows, in order to
> determine how to set this for a composite of two existing windows, or to
> keep track of resource use for it.
> >
> > Finally, we add the option to obtain a local memory key for memory
> windows, aside from the currently available remote key. This can be
> specified in an SGE to send data out of a memory layout. This key will
> only be valid if local access is requested in the access flags.
>=20
> How does the application detect whether the adapter supports this new
> verb? I don't see an attribute or other bit exposing it above the API.

The proposed alloc_mw_ex() will be detected with VERBS_CONTEXT_ALLOC_MW in =
enum verbs_context_mask.
It will only make sense to call this verb if the feature is enabled in stru=
ct ibv_ncm_caps.

>=20
> Also, what applications are likely to use it? It is my understanding
> that relatively few applications use Memory Windows-style registration
> today. Roughly what performance benefit do you expect they will achieve
> from the region descriptor format overall, motivating them to change?

The target applications are not necessarily the ones already using the exis=
ting memory windows. Applications which do matrix operations (e.g. multipli=
cation) or use non-contiguous datatypes (with MPI, for example) are good ca=
ndidates.=20
The performance benefit comes from passing the layout to the NIC once, then=
 only sending the base pointer for each send. In the case of a column in an=
 NxN matrix - each send will only give the pointer to the first element (an=
d the memory window) instead of an sge_list of size N. Similarly, a non-con=
tiguous datatype layout will be passed to the NIC only once.

>=20
> Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
