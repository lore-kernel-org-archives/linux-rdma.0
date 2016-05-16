From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Mon, 16 May 2016 13:27:36 -0400
Message-ID: <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com>
References: <20160315155441.222586021@linux.com>
 <20160315155455.173645653@linux.com>
 <057c8ac8-1d34-e7b9-c0ad-91d805c81139@redhat.com>
 <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org>
 <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com>
 <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s9OpGwNBiK852kamqVk5xllbtcWTsd0IS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605161203010.26453-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s9OpGwNBiK852kamqVk5xllbtcWTsd0IS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 01:04 PM, Christoph Lameter wrote:
> On Mon, 16 May 2016, Doug Ledford wrote:
>=20
>>>> Secondly, do *not* use a BUG_ON in this patch.  I saw at least two o=
f
>>>> them.  There is nothing in this patch so serious that we should cras=
h
>>>> the kernel.  Any failure here is something we can work around and ke=
ep
>>>> running.
>>>
>>> WARN_ON_ONCE then?
>> Yep.
>=20
> BUILD_BUG_ON works even better once we have the enum. Revised patch
> follows:

There's still one BUG_ON.  See below...

> +static struct attribute_group *create_protocol_stats(struct ib_device =
*device,
> +						     struct kobject *kobj,
> +						     u8 port) {
> +	struct attribute_group *ag;
> +	struct rdma_protocol_stats stats =3D {0};

We allocated our struct on the stack.  We have a static length counter
array in this struct.

> +	u32 counters;
> +	u32 i;
> +	int ret;
> +
> +	ret =3D device->get_protocol_stats(device, &stats, port);

We then pass our struct to get_protocol_stats to fill out.

> +
> +	if (ret || !stats.name)
> +		return NULL;
> +
> +	ag =3D kzalloc(sizeof(*ag), GFP_KERNEL);
> +	if (!ag)
> +		return NULL;
> +
> +	ag->name =3D stats.dirname;
> +
> +	for (counters =3D 0; stats.name[counters]; counters++)
> +		;

We count how many names there are...

> +
> +	BUG_ON(counters > MAX_NR_PROTOCOL_STATS);

And we BUG_ON if there are more names than we allocated static counters
in our struct.  However, by now, it's too late.  The device's
get_protocol_stats function has already likely written beyond the end of
our array and smashed our stack.  Let's fix this another way entirely...


> +	/* Emsure we provided all values */

Typo in comment...

> +	BUILD_BUG_ON(NR_COUNTERS !=3D (sizeof(names) / sizeof(char *)) - 1);

Here's where we ant to fix the problem.  We need a second BUILD_BUG_ON
that reads:

	BUILD_BUG_ON(NR_COUNTERS > MAX_NR_PROTOCOL_STATS);

Then we can safely reduce the size of the MAX_NR_PROTOCOL_STATS and know
that if we exceed our allocation, the build will fail and we can
increase it accordingly.  So in all of the get_stats routines we want
both build time checks to make sure that the counter structs are sized
appropriately and the name/enum list lengths match.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--s9OpGwNBiK852kamqVk5xllbtcWTsd0IS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOgMIAAoJELgmozMOVy/daagP+wSSRy2TlmFMBJLUiwh4g/Nw
k1N8vhg2EbHNrl1bhecXMdDRZMQ8clRQdIIn2fuihy/Fuev7zV25Jq9m4gc5Z+Xl
7xV9MiEMUMo8o+G/qWaMWBPUYXVSMQYmvhiighDZYtpKTA7Hx8xrgwMCfHK1+tfN
Qf71pVHN5Qa6KMTvqcv+6t+uNv5O1p1/nJsYzOsggQsmwgAZBhGurOq6Fumx/CQ7
+AenbMR+2ScoLOK6LJG9AN7oJeQb7WW3o5V+vWM1AxLBJWnQioQildTmYEb+j0PU
UnoDpgQ4ej219RDAMImk4KjJSFPu1L/IOIViu88m9a08FDQekNSexfIpnNrRVgpB
Ntyk5Zb4MMm+XmiDrHBy10rOP9K1EDc5gWO0UKSj2W7+7Ap6kh2eFDyR9RfP1sFG
y+VkLpxokB+G4w2CukdIdKW8czCbtKuWM19asbd7Hi+OSaqfNs6hkPic7YAc0Oq7
9NMs9/0IR1/gHyFwW2JVvcgvc3Qp8duYktF48zSLfphTi9depOGOqWUq23jrGDF4
cfwf7aqoJP6+KtwGmS3nAydi12IZsK8rfLhBhfhWlROH0GwsAlfXq+qxn352i8Wx
lC3B6Wdzo0DyWv8122NtZLc3AYRAumwq7Rr6Icfj5SZROWvgMuERfqz6qbkZwki8
lZ6TUPYFd/lrxAiLpkAp
=Ur9+
-----END PGP SIGNATURE-----

--s9OpGwNBiK852kamqVk5xllbtcWTsd0IS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
