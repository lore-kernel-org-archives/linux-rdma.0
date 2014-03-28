From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] ib_sg_dma changes
Date: Fri, 28 Mar 2014 17:57:32 +0100
Message-ID: <1396025852.3297.78.camel@localhost.localdomain>
References: <20140328163500.5773.35838.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140328163500.5773.35838.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 28 mars 2014 =C3=A0 12:35 -0400, Mike Marciniszyn a =C3=A9c=
rit :
> This patch series modified the ib_sg_dma API to
> eliminate the .dma_len and .dma_address methods.
>=20
> In all present cases that overload these methods
> (ipath, qib, ehca), the lack of these methods are
> compensated for by code changes to the driver .map_sg
> to insure that the vanilla sg_dma_address() and
> sg_dma_len() will do the same thing as the equivalent
> former ib_sg_dma_address() and ib_sg_dma_len() calls
> into the drivers.
>=20
> This patch series is a followup to this recent submission
> http://marc.info/?l=3Dlinux-rdma&m=3D139602422108727&w=3D2
> and Bart's similar comment in
> http://marc.info/?l=3Dlinux-netdev&m=3D135643746610259&w=3D2.
>=20
> Roland, I'm not sure of the history of these methods and
> what rationale caused them to be added?
>=20
> There is obviously an interim step that could be done
> here to preseve the overload by not changing verbs, yet
> change qib/ipath/echa to not overload them.  This would
> allow the drivers to work even when the "correct" API's
> had not been used by the ULP.


Hum, you should re-order the patch the other way:
first remove the functions in drivers, then remove the call to the
functions, and finaly remove the function pointers in the structure.
Otherwise you might break build for people doing some git bisect.

It's just a matter of making patch "[PATCH 1/4] IB/core: Remove overloa=
d
in ib_sg_dma*" the last one.

BTW, You might want to provide a better explanation in the drivers
functions remove patches (just duplicate the explanation).

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
