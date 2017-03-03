From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 16/20] IB/hfi1: Add receive fault injection feature
Date: Fri, 3 Mar 2017 18:15:08 +0200
Message-ID: <20170303161508.GF14379@mtr-leonro.local>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
 <20170302182610.28851.42687.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170302182610.28851.42687.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 02, 2017 at 10:26:17AM -0800, Dennis Dalessandro wrote:
> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Add fault injection capability:
>   - Drop packets unconditionally (fault_by_packet)
>   - Drop packets based on opcode (fault_by_opcode)
>
> This feature reacts to the global FAULT_INJECTION
> config flag.
>
> The faulting traces have been added:
>   - misc/fault_opcode
>   - misc/fault_packet
>
> See 'Documentation/fault-injection/fault-injection.txt'
> for details.
>
> Examples:
>   - Dropping packets by opcode:
>     /sys/kernel/debug/hfi1/hfi1_X/fault_opcode
> 	# Enable fault
> 	echo Y > fault_by_opcode
> 	# Setprobability of dropping (0-100%)
> 	# echo 25 > probability
> 	# Set opcode
> 	echo 0x64 > opcode
> 	# Number of times to fault
> 	echo 3 > times
> 	# An optional mask allows you to fault
> 	# a range of opcodes
> 	echo 0xf0 > mask
>     /sys/kernel/debug/hfi1/hfi1_X/fault_stats
>     contains a value in parentheses to indicate
>     number of each opcode dropped.
>
>   - Dropping packets unconditionally
>     /sys/kernel/debug/hfi1/hfi1_X/fault_packet
> 	# Enable fault
> 	echo Y > fault_by_packet
>     /sys/kernel/debug/hfi1/hfi1_X/fault_packet/fault_stats
>     contains the number of packets dropped.

It will be so nice to have this functionality extended to objects and
placed in IB/core. For example, VNIC and IPoIB will be able to use
faults by packet, while all other drivers and ULPs will use faults by
objects.

Does it make sense?

Thanks

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli5lowACgkQ5GN7iDZy
WKfzig/+IWKtRIG9goJWbaphKFCiqex8AtA7J+IzpeN++lFyZ54UqLR22MvnqpS/
AAZ5hk5EWZFharn+//1EXvWmW/NBu7W23oeChcvhOS8+w3lTy2RFr1M3KQdpHR4q
3hT4QneeIeDPA/NSbM6jDOc+eyjDl0ysEqJSxYwbPkKDPQ3xAtkaPFLz4xps2PS4
1iHquBuwLJWPfYiGyH05aWsL9kTqQTSvOzR4p33Rbu4ng+eXYnxUje62CekBJKP0
zcbLVLcJPh1Tkrfh3hQD4WXOrF0ox80X8LzpL8uUeN8/DsJqW2FgA+X1XEXfDNnC
YyvaYoAxMaXDEM9lbW4/t4cFW6pMyceIwEVMr9+7IcdzQi0pjCoT81N43yW6a2qY
KbxRM2GCAon/OtrZQfYcHC8lnD5HJRhyd0qINhDM+pomoGHv30qCODVFUYjN4h7m
WwLCCFWNWYsqWFX7jLWYhHSw1j/REj+Qjuf/HD13EABlm2gv9FpX53bLlMWi/C0N
ZaqTyMKifp6g15vOg7GnEL1CvEYK48Np4qAY0UYUExUXOhZZOOyHgS7p0u/HE+3n
kI0u/6K6oFZSE59xDipVN4EhEs+UPG3PkM9ep6Jxn/7Zi/i4VqyZi/IgES2jJThC
hDPxo64iNLdULQsAVxgnfftsyVZyY0IFQH+i2Jo6Y6n8MUICb34=
=EffZ
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
