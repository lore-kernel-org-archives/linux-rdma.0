From: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ANNOUNCE] libmlx4 1.0.3 is released
Date: Mon, 26 Mar 2012 16:56:28 -0500
Message-ID: <CAKBbMu0RB7SDb2AOnhi24rikr1OcG52P807v6Oe3UjRPeSa-ug@mail.gmail.com>
References: <1332782243-26729-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332782243-26729-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 26, 2012 at 12:17 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wro=
te:
> libmlx4 is a userspace driver for Mellanox ConnectX InfiniBand/IBoE
> HCAs. =A0It si a plug-in module for libibverbs that allows programs t=
o
> use Mellanox hardware directly from userspace.
>
> A new stable release is available from
>
> =A0 =A0http://www.openfabrics.org/downloads/mlx4/libmlx4-1.0.3.tar.gz
>
> with sha1sum
>
> =A0 =A00fea988f8cf9b3b02cd038949aee3ad86281976a =A0libmlx4-1.0.3.tar.=
gz
>
> I also pushed the latest tree and tag out to kernel.org:
>
> =A0 =A0git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git
>
> (the name of the tags is libmlx4-1.0.3)
>
> This release contains support for IBoE and ConnectX-3 adapters.
>
> The git shortlog since libmlx4 1.0.2 is:
>
> Or Gerlitz (6):
> =A0 =A0 =A0Add IBoE support
> =A0 =A0 =A0Add IBoE UD/VLANs support
> =A0 =A0 =A0Align the list of supported ConnectX devices with kernel
> =A0 =A0 =A0Use Ethernet 802.1Q VLAN-related fields in CQE
> =A0 =A0 =A0Add link_layer field to mlx4 QPs
> =A0 =A0 =A0Fix IBoE SL -> 802.1Q priority-bits mapping
>
> Roland Dreier (6):
> =A0 =A0 =A0Update to Debian standards version 3.9.2
> =A0 =A0 =A0Acknowledge Debian NMU
> =A0 =A0 =A0Moving plugin out of /usr/lib means we now depend on libib=
verbs 1.1.3
> =A0 =A0 =A0Add "foreign" option to AM_INIT_AUTOMAKE
> =A0 =A0 =A0Fix possible missed completion event
> =A0 =A0 =A0Roll libmlx4 1.0.3 release

Hey Roland,

This still lacks multicast IBoE support:

http://permalink.gmane.org/gmane.linux.drivers.rdma/11204

What needs to be done to get this patch applied?

Thanks,
Shawn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
