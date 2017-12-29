From: Michael Tang <mita4829-UWkI3MzZw7X2fBVCVOL8/A@public.gmane.org>
Subject: Re: RDMA Setup Research Assistances
Date: Thu, 28 Dec 2017 18:08:22 -0700
Message-ID: <88330CD5-B5A2-4D13-B50C-9DDCB737E013@colorado.edu>
References: <88AEEA39-87AC-4344-B88D-B94223906142@colorado.edu>
 <005301d37cc0$596bfa10$0c43ee30$@soft-forge.com>
 <36710BBF-8E0A-47E6-8205-86AB00D375AB@colorado.edu>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36710BBF-8E0A-47E6-8205-86AB00D375AB-UWkI3MzZw7X2fBVCVOL8/A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Thank for the resources,
>=20
> I do have a question specifically about the repository examples. My =
environment is OpenSUSE 12.3 Linux running on a Microsoft Azure H8 =
instance. I cloned the rdma-core repository and ran:

> $ bash build.sh=20
> $ zypper install cmake gcc libnl3-devel libudev-devel ninja pkg-config =
valgrind

> Then I tried to run the rping example in build/bin, but I=E2=80=99m =
getting a no such device error.=20

> teamcu@CU-RDMA-1:~/rdma-core/build/bin> ./rping -s
> rdma_create_event_channel: No such device

> I have a few speculations: I didn=E2=80=99t fully set up the necessary =
rdma libraries, the Azure instance does not support InfiniBand, or the =
Azure instance does not have capable hardware to support rdma?=20
>=20
> Best,
> Michael=20
>=20
>> On Dec 24, 2017, at 7:05 AM, RSD@SFI <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org> wrote:
>>=20
>> There are better sources - see below.=20
>>=20
>> =
https://secure-web.cisco.com/1QCZ_ow0iQxM9bWBpKZemA7T0Xj1exulwu3DNz1k7gh_w=
J18bXSCWGsHcUT6dIwrWZlMXBATlSBEAeM7SqFcLIlaBLttBXcI4TKiqYOJKLyxJ9tFd-JRguT=
7WgDc2zDv5KotziXC-Ggn2gq4vcBlNYH-uGuWMn4lFWRFVCNTDx0pZup0TBOEJdgTiyRH-TPts=
rX9LXzcxH798skCjwxm-Ja5oYrnBJUhbfPoIuocb1qWysC3Y63-VZbsYhHuqH5S2Uzo7Gs-8Lj=
72Oet0LK9D4sud3Fkv9QXcswC-IOY9x9lopj7jiCmDjGY5QglJsmy5k61N1jeHNBjBEbZ_RlHn=
28W9nFWv1OGm0M25JtR_bZLXU9YFSERzOFSMYXrhekqdxDGlPhM-rtL_u8ZZbpGWe7V1Gga09e=
dgEoWtZB2fcK-ugQpzS3G1j3EZZCl-PL3a/https%3A%2F%2Fwww.openfabrics.org%2Find=
ex.php%2Fofs-user-community.html
>>=20
>> =
https://secure-web.cisco.com/1yPiwZuVy2gY9BzjNV38kXtZw9tuCxqvn9h15oGoeYw89=
bc4C2OjJJ2B43ffmsDqYOkI68BhNs3Ru_qPcOc1g0kgTOm6kuz_YOCr1k_JtV5HxWPvbRznpSn=
wbjtUIcCcH5lCSwGEJGeO3SrT51_Fs93Qw2lWkyTPHMRFeXIYRk4z-LQJAUgKY5jVH8zQ92PUM=
LHiHCtHE0A-dHymHy3mAM-7lYXYlUqC6eBv8y85YGBnqDXaH8nK1R-KDk0cLP0fJFH0Hi6mS0f=
NJAIiFa5APixWGF7eT_VOouIvs4LnF-tkT626poFs_dgYNduvQ2Hp_7mroHDFU6HS_81g844qU=
oF8iNzWnQ3O5xHTuT_OFiVAmV7Vb4A083hhuFqyW8uMMrmbhep0aMZl2eNJVV4BqvDNsLiN9Fu=
YBe6ZgR63dvK9lGyfj0EzeqoeoFL6NelGR/https%3A%2F%2Fwww.openfabrics.org%2Find=
ex.php%2Fworking-groups.html
>>=20
>> FYI - there are a lot more experts on the Linux side than windows - =
it is not clear what you are using.
>>=20
>>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org =
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Michael Tang
>> Sent: Saturday, December 23, 2017 5:28 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: RDMA Setup Research Assistances
>>=20
>> Hello,=20
>>=20
>> I hope this message finds someone who can potentially help me. My =
name is Michael, and I=E2=80=99m a computer science student at the =
University of Colorado - Boulder. I=E2=80=99m researching RDMA, and =
I=E2=80=99m trying to install and run an example program found on the =
rdma-core repository hosted on your git. I=E2=80=99m running into some =
difficulties with just setting up RDMA, and knowledge of how to resolve =
these issues remain sparse online. I presume the hardware is set up =
correctly, for I have two Microsoft Azure instances with RDMA =
capabilities so I just need some advice with the software side. I=E2=80=99=
m wondering if this email address is an appropriate communication =
channel to ask for assistance or if I can be directed to some place =
where I can get assistant.=20
>>=20
>> Best,
>> Michael
>>=20
>> Michael Tang, Teaching Assistant
>> Department of Computer Science, Mathematics College of Engineering =
and Applied Sciences University of Colorado =E2=80=94 Boulder -- To =
unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info =
at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
