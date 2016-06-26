From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Sun, 26 Jun 2016 19:54:21 +0300
Message-ID: <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3b89c411-72be-ddc5-5ebf-009eeee29692-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/23/2016 7:51 PM, Doug Ledford wrote:
> I'm preparing to make an official release of libibverbs soonish
> (thinking by the end of next week).  Even though I took the timestamp=
 v5
> patchset, I know there were still comments from Jason on the v4 set t=
hat
> weren't addressed in v5.  Those can be addressed (and should be) with
> incremental patches prior to the official release.  Yishai, can we
> please prioritize getting that done?
>

Listed below the main openings that were raised by Jason and our input=20
on, considering their need and priority.

Most of already answered as part of the discussion, will summarize it=20
all together to help evaluating the status/next steps.


 > I'm still very much of the opinion that extended CQs should only all=
ow
 > compatible QP's to be added.
--------------------------------------

Application may create a CQ with large subset of flags that may fit som=
e=20
of its attached QP types. Semantically, it is similar to what we have=20
today, it allows to put different QP types on the same CQ and by thus=20
allow application to have ordered completion events.

We don't see a good reason to change from current behavior and hurt=20
applications that expect that valid behavior.

 > Add a compatibility layer
-------------------------------

A real application wants to achieve performance, to use a compatibility=
=20
layer over a vendor that doesn=E2=80=99t support the new API, might be =
a very=20
bad idea as of below.

1) The legacy API doesn't support the batching API that was introduced=20
by the new API, this will lead to have a Door-Bell/PCI write per CQE as=
=20
internally the compatibility layer will need to call ibv_poll_cq with=20
size of 1.

2) There will 2 copies, one from the HW CQE to ibv_wc as part of the=20
internal legacy API, second, from the ibv_wc to the read_xxx output,=20
comparing the new API.

3) The *non-required* fields will be copied anyway as part of the=20
internal legacy ibv_poll_cq from the HW CQE to ibv_wc and hits the=20
performance.

In addition,
There is *no* one to one mapping in all the cases between the new API t=
o=20
the legacy one, it will lead to a *non* transparent usage of the=20
compatibility layer and ends by returning an error to the application i=
n=20
few cases.

Specifically,
One of major benefits in the new API is the ability to say as part of C=
Q=20
creation that it's going to be used by only one thread and have lock=20
less flow as part of polling the CQ. This is not supported in the legac=
y=20
API which assumes that multi-threaded access might be used.

It makes sense to return an error in the compatibility layer API lettin=
g=20
application knows that this service is not supported when it was asked=20
by the application.

Applications that look for performance expect to work in that single=20
threaded mode and might fail as part of using the compatibility layer o=
r=20
alternatively have no idea that they didn't get the service which=20
assumes to be bad behavior.

In addition, at the moment timestamping can=E2=80=99t be read via the l=
egacy API=20
means that the compatibility layer can=E2=80=99t handle it and should s=
upply an=20
error for. In the future there may be other fields/flows that can=E2=80=
=99t be=20
supported by the compatibility layer so application that will be writte=
n=20
over this layer will fail and won=E2=80=99t get the required benefit fr=
om using it.

To sum it up:
We don't see a real usage of such a layer, it has many limitations.
In case will be a real request from users, it can always be added in th=
e=20
future, minor priority for now.

 > Exact set of access flags
------------------------------

Application can ask for subset of the available bits, in addition, it=20
has an option to ask for all legacy ones (i.e. IBV_WC_STANDARD_FLAGS)=20
for a case that a CQ needs to support all legacy attribute and could be=
=20
attached to both RC and UD QPs.

We didn't find it useful at the moment to add other enums per QP type a=
s=20
application can say explicitly what it wants by using the ORed bits and=
=20
even per QP type application may not be always interested in all the=20
fields. (e.g. CQ that used for TX only completions in RC is not=20
interested in few fields that are relevant for the RX).

To sum it up:
Low priority issue that can be added in the future based on users deman=
d.

 > Exact set of accessors
--------------------------------

At the moment the API introduces an option to get each field by a=20
separate accessor (i.e ibv_read_wc_xxx), in addition, wr_id and status=20
have direct access as application expect to use them in most of their f=
lows.

During the discussion come up some ideas to add some extra accessors pe=
r=20
QP type (e.g. ibv_wc_read_ud, ibv_wc_read_rc, etc.).

This option makes sense when application really plans to read and use=20
all of the potential UD/RC fields, which *can't* be assumed as true in=20
the general case.

Even in a UD/RC QP the application may be interested in few of the CQE=20
fields while others are not needed.

 From bench mark testing, we found that gathering few fields in one=20
ibv_wc_read_xxx has low benefit comparing the case that each field is=20
read by itself.

In a case that *not* all fields are really needed the extra copy to=20
return the redundant fields found to be more expensive comparing the=20
ibv_wc_read_xxx when needed.

We can think of an application that may be interested in subset of=20
fields per QP type or per send/receive flows to be gathered in one call=
,=20
this ability can always be added in the future as the API cleanly
enables extensions.

If you still think that adding some extra ibv_wc_read_xxx groups from=20
day one is really needed, let's define it and add now by an incremental=
=20
patch. Till now didn't see any user specific request for.

 > Minor coding issues and micro optimizations
------------------------------------------------

Not sure what exactly that point refers to from API point of view,=20
assuming that it relates to few comments given on libmlx5 as of below.

 > +static inline uint32_t mlx5_cq_read_wc_qp_num(struct ibv_cq_ex *ibc=
q)
 > +{
 > +	struct mlx5_cq *cq =3D to_mcq(ibv_cq_ex_to_cq(ibcq));

 > You might want to look at having the caller pass in 'cq' from a memb=
er
 > in ibv_cq_ex. That way the caller can hold the cq in a register
 > instead of constantly reloading it like this - I'm assuming to_mcq i=
s
 > not just an container_of??

The assumption is *incorrect*, the internal access from ibv_cq_ex to=20
driver CQ is done via offsetof/container_of which is done in compile=20
time, no need to have some change from the clean usage of the API to=20
that mode.


 > +static inline uint32_t mlx5_cq_read_wc_qp_num(struct ibv_cq_ex
 > *ibcq)
 > You need to go through everything you've written and make sure it is
 > const-correct.
 > You should also annotate with restrict.
 > Doing this properly can increase performance by allowing the caller =
to
 > avoid reloads.

 From performance point of view we don't expect a change here, we=20
followed the created assembly code and saw no difference even when it=20
was annotated with 'restrict'.

In addition, please note the 'restrict' notation was only became=20
standard as part of C99, in previous compilers it may not work at all o=
r=20
requires different key word to be defined as part of the CONFIG step.

We can go ahead and define the ibv_wc_read_xxx with const qualifier on=20
its input struct ibv_cq_ex *ibcq in some extra incremental patch if=20
makes sense.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
