From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-3.2 v1 3/5] ib/mlx4: Add extended port capabilities support
Date: Sun, 16 Oct 2011 10:23:37 +0200
Message-ID: <CAN+0-cbb6UA+uj59ba1vSrKDBtjQxH4=+xSrWEwpDSt2TaEU8w@mail.gmail.com>
References: <201110031755.41883.marcela@dev.mellanox.co.il>
	<CAL1RGDUc=5=Xce9PXTFe3p55kZPnQKcBxRwRnkAwASKc9MFAVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUc=5=Xce9PXTFe3p55kZPnQKcBxRwRnkAwASKc9MFAVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,
Thanks for the review.

The extended capabilities are indeed per port. It is possible that
every port has its own extended capabilities.

The reason I used a 64bit field for a bit is to prepare a field for
future extended capabilities.
In my opinion new capabilities will be appended to this field sooner
or later and I want it to be ready.
It seems to me more elegant to prepare this field in advance, rather
than append a new field for each such a feature.

What do you think?
  Marcel

On Tue, Oct 11, 2011 at 9:30 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> This seems a bit obfuscated: we add a u64 ext_port_cap for each port,
> and then have a special setup function that just ORs in a single bit =
to
> that value (done by passing in a pointer).
>
> Is there any reason mlx4_get_ext_port_caps() couldn't be more like
> mlx4_check_ext_port_caps(), and have that function set
> MLX4_FLAG_EXTENDED_PORT_INFO? =A0Is it possible that
> only some ports on the same HCA handle the extended port info query?
>
> If so is there some reason this one bit needs a u64 to hold it?
>
> On Mon, Oct 3, 2011 at 8:55 AM, Marcel Apfelbaum
> <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>
>> An Extended Port Info packet is sent to each hw port during HCA init
>> and if returns without error it is assumed the port supports
>> extended port capabilities.
>>
>> Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> =A0drivers/net/mlx4/main.c =A0 =A0 | =A0 10 ++++++++++
>> =A0drivers/net/mlx4/mlx4.h =A0 =A0 | =A0 =A01 +
>> =A0drivers/net/mlx4/port.c =A0 =A0 | =A0 41 ++++++++++++++++++++++++=
+++++++++++++++++
>> =A0include/linux/mlx4/device.h | =A0 =A07 +++++++
>> =A04 files changed, 59 insertions(+)
>>
>> --- a/drivers/net/mlx4/main.c
>> +++ b/drivers/net/mlx4/main.c
>> @@ -881,6 +881,7 @@ static int mlx4_setup_hca(struct mlx4_de
>> =A0 =A0 =A0 =A0struct mlx4_priv *priv =3D mlx4_priv(dev);
>> =A0 =A0 =A0 =A0int err;
>> =A0 =A0 =A0 =A0int port;
>> + =A0 =A0 =A0 u64 ext_port_default_caps;
>> =A0 =A0 =A0 =A0__be32 ib_port_default_caps;
>>
>> =A0 =A0 =A0 =A0err =3D mlx4_init_uar_table(dev);
>> @@ -998,6 +999,15 @@ static int mlx4_setup_hca(struct mlx4_de
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"=
ib capabilities (%d). Continuing with "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"=
caps =3D 0\n", port, err);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev->caps.ib_port_def_cap[port] =3D i=
b_port_default_caps;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_port_default_caps =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D mlx4_get_ext_port_caps(dev, po=
rt, &ext_port_default_caps);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlx4_warn(dev, "failed=
 to get port %d extended "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "p=
ort capabilities support (%d). Assuming "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "n=
ot supported\n", port, err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev->caps.ext_port_cap[port] =3D ext_p=
ort_default_caps;
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D mlx4_SET_PORT(dev, port);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mlx4_err(dev, "Failed=
 to set port %d, aborting\n",
>> --- a/drivers/net/mlx4/mlx4.h
>> +++ b/drivers/net/mlx4/mlx4.h
>> @@ -450,6 +450,7 @@ void mlx4_init_vlan_table(struct mlx4_de
>>
>> =A0int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port);
>> =A0int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *=
caps);
>> +int mlx4_get_ext_port_caps(struct mlx4_dev *dev, u8 port, u64 *get_=
ext_caps);
>>
>> =A0int mlx4_qp_detach_common(struct mlx4_dev *dev, struct mlx4_qp *q=
p, u8 gid[16],
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0enum mlx4_protoco=
l prot, enum mlx4_steer_type steer);
>> --- a/drivers/net/mlx4/port.c
>> +++ b/drivers/net/mlx4/port.c
>> @@ -464,6 +464,47 @@ int mlx4_get_port_ib_caps(struct mlx4_de
>> =A0 =A0 =A0 =A0return err;
>> =A0}
>>
>> +int mlx4_get_ext_port_caps(struct mlx4_dev *dev, u8 port, u64 *get_=
ext_caps)
>> +{
>> + =A0 =A0 =A0 struct mlx4_cmd_mailbox *inmailbox, *outmailbox;
>> + =A0 =A0 =A0 u8 *inbuf, *outbuf;
>> + =A0 =A0 =A0 int err, packet_error;
>> +
>> + =A0 =A0 =A0 inmailbox =3D mlx4_alloc_cmd_mailbox(dev);
>> + =A0 =A0 =A0 if (IS_ERR(inmailbox))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(inmailbox);
>> +
>> + =A0 =A0 =A0 outmailbox =3D mlx4_alloc_cmd_mailbox(dev);
>> + =A0 =A0 =A0 if (IS_ERR(outmailbox)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlx4_free_cmd_mailbox(dev, inmailbox);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(outmailbox);
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 inbuf =3D inmailbox->buf;
>> + =A0 =A0 =A0 outbuf =3D outmailbox->buf;
>> + =A0 =A0 =A0 memset(inbuf, 0, 256);
>> + =A0 =A0 =A0 memset(outbuf, 0, 256);
>> + =A0 =A0 =A0 inbuf[0] =3D 1;
>> + =A0 =A0 =A0 inbuf[1] =3D 1;
>> + =A0 =A0 =A0 inbuf[2] =3D 1;
>> + =A0 =A0 =A0 inbuf[3] =3D 1;
>> +
>> + =A0 =A0 =A0 *(__be16 *) (&inbuf[16]) =3D MLX4_ATTR_EXTENDED_PORT_I=
NFO;
>> + =A0 =A0 =A0 *(__be32 *) (&inbuf[20]) =3D cpu_to_be32(port);
>> +
>> + =A0 =A0 =A0 err =3D mlx4_cmd_box(dev, inmailbox->dma, outmailbox->=
dma, port, 3,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MLX4_CMD_MAD_IF=
C, MLX4_CMD_TIME_CLASS_C);
>> +
>> + =A0 =A0 =A0 packet_error =3D be16_to_cpu(*(__be16 *) (outbuf + 4))=
;
>> +
>> + =A0 =A0 =A0 if (!err && !packet_error)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *get_ext_caps |=3D MLX_EXT_PORT_CAP_FL=
AG_EXTENDED_PORT_INFO;
>> +
>> + =A0 =A0 =A0 mlx4_free_cmd_mailbox(dev, inmailbox);
>> + =A0 =A0 =A0 mlx4_free_cmd_mailbox(dev, outmailbox);
>> + =A0 =A0 =A0 return err;
>> +}
>> +
>> =A0int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
>> =A0{
>> =A0 =A0 =A0 =A0struct mlx4_cmd_mailbox *mailbox;
>> --- a/include/linux/mlx4/device.h
>> +++ b/include/linux/mlx4/device.h
>> @@ -82,6 +82,12 @@ enum {
>> =A0 =A0 =A0 =A0MLX4_DEV_CAP_FLAG_COUNTERS =A0 =A0 =A0=3D 1LL << 48
>> =A0};
>>
>> +#define MLX4_ATTR_EXTENDED_PORT_INFO =A0 cpu_to_be16(0xff90)
>> +
>> +enum {
>> + =A0 =A0 =A0 MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO =A0 =A0 =A0 =A0=
=3D 1 << =A00
>> +};
>> +
>> =A0enum {
>> =A0 =A0 =A0 =A0MLX4_BMME_FLAG_LOCAL_INV =A0 =A0 =A0 =A0=3D 1 << =A06=
,
>> =A0 =A0 =A0 =A0MLX4_BMME_FLAG_REMOTE_INV =A0 =A0 =A0 =3D 1 << =A07,
>> @@ -276,6 +282,7 @@ struct mlx4_caps {
>> =A0 =A0 =A0 =A0u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_mask=
;
>> =A0 =A0 =A0 =A0enum mlx4_port_type =A0 =A0 possible_type[MLX4_MAX_PO=
RTS + 1];
>> =A0 =A0 =A0 =A0u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_count=
ers;
>> + =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_port_c=
ap[MLX4_MAX_PORTS + 1];
>> =A0};
>>
>> =A0struct mlx4_buf_list {
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
