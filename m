From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/nes: Convert timers to use timer_setup()
Date: Thu, 5 Oct 2017 09:32:12 -0400
Message-ID: <622bfd9d-69df-9d78-d72b-5bd49d979afa@redhat.com>
References: <20171005004527.GA22607@beast>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vb3qPXbkm8n9n0WQKJ6921J8llagmUvGF"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171005004527.GA22607@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vb3qPXbkm8n9n0WQKJ6921J8llagmUvGF
Content-Type: multipart/mixed; boundary="rWeWmt6D2rM16QDpsnOkxBP4bkwPblrsN";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>
Message-ID: <622bfd9d-69df-9d78-d72b-5bd49d979afa@redhat.com>
Subject: Re: [PATCH] RDMA/nes: Convert timers to use timer_setup()
References: <20171005004527.GA22607@beast>
In-Reply-To: <20171005004527.GA22607@beast>

--rWeWmt6D2rM16QDpsnOkxBP4bkwPblrsN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/4/2017 8:45 PM, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointe=
r to
> all timer callbacks, switch to using the new timer_setup() and from_tim=
er()
> to pass the timer pointer explicitly. A pointer from nesadapter back to=

> nesdev was added.
>=20
> Cc: Faisal Latif <faisal.latif@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This requires commit 686fef928bba ("timer: Prepare to change timer
> callback argument type") in v4.14-rc3, but should be otherwise
> stand-alone.

What is your intention with this, and the other RDMA related, patches?
Is it your intention that I should pick these up or is someone else
supposed to (you sent it to linux-kernel and only Cc:ed linux-rdma)?
Also, are you intending this to go into -rc?  If so, why is it dependent
on a patch that didn't land until -rc3?


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--rWeWmt6D2rM16QDpsnOkxBP4bkwPblrsN--

--vb3qPXbkm8n9n0WQKJ6921J8llagmUvGF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZ1jRcAAoJELgmozMOVy/dKa8P/ikQd+9+dLqrKojoFrpeqQ2/
oLks67eBgPydMebBEwWYGaX+fi06xwF2fXrw71ZwBRX9jOBLE9SpFTTwUvoz5AQd
gEL/XZR7Jy5AmCF6OXzm4uMlzBMquUbih1OKdozVDX2iBHck5fGmdBskpYrwCPcK
llp4JuyXdC+cQV2Hm9nxXQwYQQSrww4xMVuM9nNZgSmLFvVkTSn/mRqtg6vurGGz
jEcYMzlzjkRsN3Bjzlel9Q9Z1mbwyRM0IjjaFefjsCKge4VuTkfag6sUJ+MmqpbD
Le45r0vgVlynP4asvDiqSUuypyIOsXDi4n6+xWIWu0+RVHr/eeSnd+NtyYKAMHKC
obN4/qkwSVeMXXbdh6eVcm+9R+SsaU+qxiW7ibSqJWl9Tm0EEj4nr86PCfItbLyF
hLAHlrww636NR6mDD1RvpjQzSEcRaE9BjF374ibzTEUWiVLep7q+McgPBtSxp6Rv
+FokKxd0oHmnodxTX1rhCUSH6eDxPPKAGL3nA0vpZX3PqC7su2FWWtoPAn86OPsw
t3VE1CDhuwzcUdUCFGACsmKeVD8HF73DOXK51KUigdG5AfwXASnqBYs4e2iubnfR
tyJnfKHMbIG9dTCGoOPyrwxyz4E0of6rTnFxXicO2+bkkBE1nhp3WMq9zGG3/Snt
MH1avjsXxO7ASthVYaqv
=qCLW
-----END PGP SIGNATURE-----

--vb3qPXbkm8n9n0WQKJ6921J8llagmUvGF--
