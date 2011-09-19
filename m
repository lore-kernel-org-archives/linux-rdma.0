From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH/ibsim] Provide support for SubnSet(GUIDInfo)
Date: Mon, 19 Sep 2011 10:07:57 -0400
Message-ID: <CAKzyTsy6QsrufSAFrCDyUUZcZvQU+PHuPjEL7y9SrT3FuaD19Q@mail.gmail.com>
References: <20110916210611.GA6926@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110916210611.GA6926-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 16, 2011 at 5:06 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> Hardwire PortInfo.GUIDCap to 1 for both the switch and HCA case,

Why hardwire this to 1 ? This is not what most defaults are.

> then simply verify that the incoming SubnSet matches the RO data
> in block 0.

Is this just to make the set of guidinfo simple ? Longer term, this
should support a GUIDCap > 1 but I suppose that could be a follow on
patch to this.

-- Hal

> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
> =C2=A0ibsim/sim_mad.c | =C2=A0 25 +++++++++++++++++--------
> =C2=A0ibsim/sim_net.c | =C2=A0 =C2=A02 +-
> =C2=A02 files changed, 18 insertions(+), 9 deletions(-)
>
> I've put all our patches for ibsim on my github page:
>
> git://github.com/jgunthorpe/ibsim.git
>
> diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
> index 83d4e3b..60da7d2 100644
> --- a/ibsim/sim_mad.c
> +++ b/ibsim/sim_mad.c
> @@ -385,17 +385,26 @@ static int do_guidinfo(Port * port, unsigned op=
, uint32_t mod, uint8_t * data)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Node *node =3D port->node;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int status =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uint64_t portguid =3D node->nodeguid + por=
t->portnum;
> + =C2=A0 =C2=A0 =C2=A0 if (node->type =3D=3D SWITCH_NODE)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 portguid =3D node-=
>nodeguid;
>
> - =C2=A0 =C2=A0 =C2=A0 if (op !=3D IB_MAD_METHOD_GET) =C2=A0 =C2=A0//=
 only get currently supported (non compliant)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D ERR_MET=
HOD_UNSUPPORTED;
> -
> - =C2=A0 =C2=A0 =C2=A0 memset(data, 0, IB_SMP_DATA_SIZE);
> - =C2=A0 =C2=A0 =C2=A0 if (mod =3D=3D 0) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (node->type =3D=
=3D SWITCH_NODE)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 mad_encode_field(data, IB_GUID_GUID0_F, &node->nodeguid);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 if (op =3D=3D IB_MAD_METHOD_SET) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* The PortInfo.Gu=
idCap is hardwired to 1, so the only valid input
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0to a =
Set is the port GUID followed by zeros on block 0. */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int i =3D mod =3D=3D=
 0?1:0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (; i !=3D 8; +=
+i)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (mad_get_field64(data, i*8, IB_GUID_GUID0_F) !=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D ERR_BAD_PARAM;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mod !=3D 0 ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mad_=
get_field64(data, 0, IB_GUID_GUID0_F) !=3D portguid)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 status =3D ERR_BAD_PARAM;
> + =C2=A0 =C2=A0 =C2=A0 } else if (op =3D=3D IB_MAD_METHOD_GET) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(data, 0, IB=
_SMP_DATA_SIZE);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mod =3D=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0mad_encode_field(data, IB_GUID_GUID0_F, &portguid);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D ERR_MET=
HOD_UNSUPPORTED;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return status;
> =C2=A0}
> diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
> index 13c3b8c..59fc28e 100644
> --- a/ibsim/sim_net.c
> +++ b/ibsim/sim_net.c
> @@ -104,7 +104,7 @@ static const uint8_t hcaport[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A00x00, 0x00, 0x0F, 0xF9, 0x01, 0x03, 0x03, =
0x02,
> =C2=A0 =C2=A0 =C2=A0 =C2=A00x12, 0x52, 0x00, 0x11, 0x40, 0x40, 0x00, =
0x08,
> =C2=A0 =C2=A0 =C2=A0 =C2=A00x08, 0x04, 0xFF, 0x10, 0x00, 0x00, 0x00, =
0x00,
> - =C2=A0 =C2=A0 =C2=A0 0x00, 0x00, 0x20, 0x1F, 0x00, 0x00, 0x00, 0x00=
,
> + =C2=A0 =C2=A0 =C2=A0 0x00, 0x00, 0x01, 0x1F, 0x00, 0x00, 0x00, 0x00=
,
> =C2=A0 =C2=A0 =C2=A0 =C2=A00x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, =
0x00,
> =C2=A0};
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
