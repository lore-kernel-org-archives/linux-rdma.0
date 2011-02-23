From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: patches for OFED 1.5.3RC4
Date: Wed, 23 Feb 2011 08:30:55 +0100
Message-ID: <20110223083055.5b3ee7d9@b012350-ux.fr.ad.bull.net>
References: <6203933669E90E4AB42B5BC4EDE38D350D0FB6B1B4@orsmsx510.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6203933669E90E4AB42B5BC4EDE38D350D0FB6B1B4-qERRe+bbXDTTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 22 Feb 2011 09:43:32 -0800
"Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> We tried to compile OFED 1.5.3RC4 on a RH DEVELOPMENT kernel for RH6 =
(aka a pre-version of the next update to the RH6 kernel) and run into a=
 series of issues
>=20
> We managed to compile it using the patches attached (to be applied di=
rectly against the tar tree in SRPMS/ofa_kernel-1.5.3-OFED.1.5.3.rc4.sr=
c.rpm)
>=20
> mostly it's warning stuff, some routines defined by templates expect =
more/different parameter types.
>=20
> Nothing serious, but do you want this for the 1.5.3 release?
>=20


  Hi Donald,

  looks like your diff should be the other way around.

  I have essentially the same thing to be able to build on an RHEL6 bas=
ed kernel
now that the build has become really pedantic (which is a good thing).

  S=C3=A9bastien.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
