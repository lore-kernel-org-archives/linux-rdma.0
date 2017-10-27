From: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Fri, 27 Oct 2017 15:46:57 +0000
Message-ID: <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com>
 <b003f6e5-d7ce-3775-a1dc-0fd0f507a515@dev.mellanox.co.il>,<20171025151734.GA15557@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025151734.GA15557-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=A0  =20
On Wed, Oct 25, 2017 at 06:17:15PM +0300, Jason Gunthorpe wrote:
>On Wed, Oct 25, 2017 at 05:58:15PM +0300, Yishai Hadas wrote:
>
>> Hi Jason, please go over the patches/uapi, we believe that you'll find i=
t
>> quite easy to be used by an application, however we plan to improve as o=
f
>> below.
>
>No, it is not, this proposal relies too much on device-specific
>information to make sense in a multi-vendor context. Counters should
>not be grouped in a hardware unique way.

counters are not group in hardware unique but in an intuitive way.
all counters related to flow (ibv_flow) are grouped togeger, and following
the same pattern all counters related to QP (ibv_qp) should be grouped toge=
ther.

>
>But it is still hard to understand what you are talking about, so
>maybe if you provide a short and clearer example..
>
>> #The create API:
>> We found it better to stay with our suggested API with few changes, belo=
w
>> notes were considered.
>>=20
>> 1) There might be a hardware that doesn't support attaching a counter ob=
ject
>> to an existing object, your suggested API to set sampling points relay o=
n
>> that ability.
>
>That is unfortunate, and kind of lame, but you can still use the
>proposed API by re-ordering things. Continue to have
>ibv_add_sampling_point_flow, however a NULL flow argument will make
>the counters become added when the flow is created:
>
>=A0counters =3D ibv_create_counters([..]);
>=A0ibv_add_sampling_point_flow(counters, 1, NULL, [..])
>=A0flow_attr.counters =3D counters;
>=A0ibv_create_flow(qp, &flow_attr);

As mentioned earlier - current hardware support attachment of counters
only during the creation of the object (flow/qp/etc).
Your proposal could be useful in the case where a structure of a dynamic
counter set is to be modified. However - since it is not the current case,
there is no benefit in dividing the build of such a counter-set into severa=
l steps.
Hence we suggest to supply the creation API with instructions on how to cre=
ate such a set.=20
Having said that - I'm not saying that the partial steps are totally useles=
s.=20
These steps could be used as 'syntactic sugar' in order to change some kind
of structured which would be passed to the creation method.=20
Hence, methods such as =A0ibv_add_sampling_point_flow() should either be=20
user-space-verbs only, or as macros or totally not there.

>
>> 2) We prefer using one single system call to create the ib_counter objec=
t
>> with its required counters instead of creating it with sampling points w=
hich
>> might involve many system calls.
>
>No. More system calls are good for something like this, there is a lot
>of possibly future variety here. Systems calls are better than huge
>structs and comp mask.
>
>It allows you to ditch the silly describe API by making the creation
>side more granular.
See response above.

Guy

>
>Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
