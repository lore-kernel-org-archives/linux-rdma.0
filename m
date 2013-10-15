From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in
 uverbs =?UTF-8?Q?create=5Fflow?=
Date: Tue, 15 Oct 2013 16:08:54 +0200
Message-ID: <122f1a29d6fe45449a6a153a3a9ba8b1@meuh.org>
References: <cover.1381510045.git.ydroneaud@opteya.com>
 <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
 <525C0BF2.2060201@mellanox.com> <72b95284386dc57dfa1c7c883b4f45af@meuh.org>
 <CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Le 14.10.2013 20:19, Roland Dreier a =C3=A9crit=C2=A0:
> On Mon, Oct 14, 2013 at 8:46 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>=
=20
> wrote:
>> Let's try for inclusion in v3.12-rc6
>=20
> Hi everyone.  First of sorry for being incommunicado for so long, bee=
n
> swamped with a lot of stuff.
>=20
> Anyway, given that everyone seems to agree we want something along th=
e
> lines of this series, but that the series is not ready yet, it really
> seems to be that at this point the best option is Yann's simple patch
> to temporarily disable these commands.
>=20
> Can anyone talk me out of that?
>=20

 From my point of view:

- commit 400dbc9 "IB/core: Infrastructure for extensible uverbs=20
commands"
   was introduced with the purpose of providing ground for new commands=
,
   but fail to actually provide real benefit, it just seems complicated
   for nothing.
   In fact, when reading the commit, I think the code is not doing
   what's advertised in the commit message and in the extended command=20
header:
   What's the point of splitting "core" from "provider" buffer ?

- commit 436f2ad "IB/core: Export ib_create/destroy_flow through uverbs=
"
   rely on the extensible uverbs infrastructure introduced in commit
   400dbc9, but it's not clear why it needs the infrastructure,
   perhaps bigger command buffer is needed for large set of flow_spec ?

   More important, ABI/API exposed would welcome some cleanups:

   - The public data structures need a bit of rework: renaming, removin=
g=20
struct ib_kern_spec

   - The size of the flow_spec list is computed by subtracting the=20
command
     header length and command to the total length.

       kern_attr_size =3D cmd.flow_attr.size - sizeof(cmd) -
                        sizeof(struct ib_uverbs_cmd_hdr_ex);

     The size must not depend on the command header, I believe they are=
=20
part
     of different layer. cmd.flow_attr.size should be the size of the=20
flow_spec list.

   - The parsing flow_spec is a bit incorrect, it goes wrong at=20
manipulating the size
     of flow_spec list. Additionally it should not rely on underflow=20
kern_attr_size to detect error.

- commit 22878db "IB/core: Better checking of userspace values for=20
receive flow steering"
   add checks for negative value on unsigned variables

- patch https://patchwork.kernel.org/patch/2924341/
   "IB/core: clarify overflow/underflow checks on ib_create/destroy_flo=
w"
   is improving ib_uverbs_create_flow() and ib_uverbs_destroy_flow()
   to fix the remarks I've made against commit 436f2ad and 22878db
   but introduce a bug, not adding the size of flow_attr, when allocati=
ng=20
memory
   for the flow_attr + flow_specs.

- Additionally, the improved extensible command scheme require changes
   in ib_uverbs_create_flow() and ib_uverbs_destroy_flow() function
   to use a new prototypes.

I've proposed fixe for ib_uverbs_create_flow(), ib_uverbs_destroy_flow(=
)
and public API.

I've proposed an improvement of the extensible scheme based on my=20
understanding
of the intent described in the commit 400dbc9 message. This scheme seem=
s=20
better,
but it's not the silver bullet: it doesn't address new requirements
provided by Matan Barak:

http://marc.info/?i=3D524AB54F.9050205-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

   > In addition, commands that have extensible sub-structures (for=20
example,
   > extended address handle in QP attributes in IP based addressing=20
patch)
   > should be given as a different UDATA in the cmd structure.=20
Therefore, we
   > need a comp_mask in the cmd structure header to describe which UDA=
TA
   > structure are included.

http://marc.info/?i=3D5253F37C.90508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

   > Regarding the last patch, you are right that it simplifies things=20
for
   > creating new uverbs where command parts are in-lined one after=20
another,
   > but the infrastructure got a bit more complex.

   > If we're going to this direction, I think the we should also deal=20
with
   > the problem of extending one of the command parts. Currently, we'l=
l=20
have
   > to put a comp_mask in the in-lined command part, consume this=20
command
   > part and then continue with the other parts. It might be better th=
an
   > using a pointer, but this put the burden of serializing the comman=
d
   > buffer into the kernel structures onto the uverb command writer.
   > We might want to avoid this.

   > Furthermore, the comp_mask of the command is different than the
   > comp_mask of the response. Therefore, I don't think we should pass=
=20
the
   > command's comp_mask to the uverb as a pointer, but just pass a=20
pointer
   > to value 0 that the uverb will set.

http://marc.info/?i=3D525C1149.6000701-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

   > I think that's a good idea to make the comp_mask field a part of o=
ur
   > infrastructure. But, I think we should consider making this=20
symmetrical.

   > If we use the command's comp_mask as an input parameter, shouldn't=
=20
we
   > use the response's comp_mask as an output parameter ?
   > What's about the provider's comp_mask ?

http://marc.info/?i=3D525C0FF2.5040905-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

   > This infrastructure (as well as the original one) doesn't deal wit=
h=20
the
   > case we discussed about in the previous patches. When a command=20
contains
   > a structure that can be extended, we don't have a clean nice way o=
f
   > doing that. Though, because it's a limitation of the original desi=
gn=20
and
   > this patch cleans up the functionality of the original=20
infrastructure,
   > I'm in favor of merging it.

I would summarize:

   - having the ability to extend multiple part of the command,
     independently of the other;
   - same for the response;
   - having comp_mask in command for uverbs (eg. core/) and for provide=
r=20
(eg. hw/);
   - same for the response.

I've provided a patch to handle "comp_mask" in response,
but I don't feel confident in it: design doesn't sound clean.

While I would like to address the unlimited command expansion problem,
I think the scheme I've proposed is the wrong way. But in the same time
I don't believe I have a good way to do it.

The proposed new scheme is only good for core / hw split.

But, in the mean time, we failed at providing the required=20
fixes/cleanups before v3.12-rc5.
We have not agreed on a definitive, small, urgent patchset for=20
v3.12-rc5.
And I think, and it's easy to think so, that Linus will be very upset t=
o=20
see more
than a couple of patches for the Infiniband subsystem for v3.12-rc6. If=
=20
there's a v3.12-rc6.

So instead of fighting to squeeze the last good patch hunk for v3.12, w=
e=20
should think
on what command/response scheme we need for v3.13.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
