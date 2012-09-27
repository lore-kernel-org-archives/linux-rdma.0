From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Fix crash on uninitialized priv->cmd.slave_sem
Date: Thu, 27 Sep 2012 14:35:20 +0200
Message-ID: <50644808.8020101@mellanox.com>
References: <1348634552-21047-1-git-send-email-roland@kernel.org> <CAJZOPZKoMorYPBqUPbmUcsw1GcXOYo8oE-u2gA6HB6sb3eo1iw@mail.gmail.com> <CAG4TOxPBOMQW1XeB-CNjq+RHix3Rk-ZqfB_6d5YscMQKDOumtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPBOMQW1XeB-CNjq+RHix3Rk-ZqfB_6d5YscMQKDOumtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 27/09/2012 08:46, Roland Dreier wrote:
> On Wed, Sep 26, 2012 at 2:51 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>> What exactly did you mean by saying "for unlucky configurations"
>> above? what value did you use for mlx4_core's port_array_type module
>> param?
> I didn't set the parameter at all.  What I meant by "unlucky configs"=
 was
> all the conditions in the following code in mlx4_dev_cap():
>
> 		/*
> 		 * Link sensing is allowed on the port if 3 conditions are true:
> 		 * 1. Both protocols are supported on the port.
> 		 * 2. Different types are supported on the port
> 		 * 3. FW declared that it supports link sensing
> 		 */
> 		mlx4_priv(dev)->sense.sense_allowed[i] =3D
> 			((dev->caps.supported_type[i] =3D=3D MLX4_PORT_TYPE_AUTO) &&
> 			 (dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP) &&
> 			 (dev->caps.flags & MLX4_DEV_CAP_FLAG_SENSE_SUPPORT));
>
> 		/*
> 		 * If "default_sense" bit is set, we move the port to "AUTO" mode
> 		 * and perform sense_port FW command to try and set the correct
> 		 * port type from beginning
> 		 */
> 		if (mlx4_priv(dev)->sense.sense_allowed[i] && dev->caps.default_sen=
se[i]) {
> 			enum mlx4_port_type sensed_port =3D MLX4_PORT_TYPE_NONE;
> 			dev->caps.possible_type[i] =3D MLX4_PORT_TYPE_AUTO;
> 			mlx4_SENSE_PORT(dev, i, &sensed_port);
> 			if (sensed_port !=3D MLX4_PORT_TYPE_NONE)
> 				dev->caps.port_type[i] =3D sensed_port;
> 		} else {

Roland,

Looking deeper on the issues you reported, we noted that the bug is up=20
here on the RHS of

if (mlx4_priv(dev)->sense.sense_allowed[i] && dev->caps.default_sense[i=
])

as when a firmware sets the =93do_sense=94 bit as 1 (which is the defau=
lt in=20
2.11.0500), the driver begins to do sensing. This firmware somehow went=
=20
out without enough mfunc checking, bad. A fast solution would be a one=20
liner patch that forces the LHS of this line to be false under mfunc=20
mode, that is add forth condition to the three conditions above which i=
s=20
&& !mfunc

In the overall driver architecture level, auto-sending can/will be able=
d=20
in later state, when the PPF
can signal the VFs to reset/re-create their mlx4 device when the link=20
type change, as done in native
mode.

Or.



> I'm beginning to think it might be that I had nothing hooked up
> to my adapter initially, which seems to lead to the fatal SENSE_PORT
> call here.  I notice that once I bring up the link, the stream of fai=
ling
> SENSE_PORT calls (which don't ever work in SR-IOV mode AFAICT) stops =
as well.
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
